require 'open-uri'
require 'net/irc'
require 'rest-firebase'

module Hackway
  class Session < Net::IRC::Server::Session
    def server_name
      :Hackway
    end

    def server_version
      Hackway::VERSION
    end

    def initialize(*args)
      super
      @notified_articles = []
      @firebase = RestFirebase.new(
        site: 'https://hacker-news.firebaseio.com/',
        auth: false,
        max_retries: 3,
        log_method: method(:puts)
      )
    end

    def main_channel
      '#hackernews'
    end

    def on_user(message)
      super
      post(@nick, JOIN, main_channel)

      es = @firebase.event_source('v0/topstories')

      es.onerror     { |error| raise error }
      es.onreconnect { true }

      es.onmessage do |event, data|
        next unless event == 'put'
        news = @firebase.get("v0/item/#{data['data'].first}")
        url  = news['url']

        next if @notified_articles.include?(url)
        @notified_articles << url

        title = news['title']
        score = news['score']
        user  = news['by']

        privmsg(user, main_channel, "#{title} #{url} (#{score})")
      end

      es.start
    rescue => e
      @log.error(e.to_s)
    end

    def on_disconnected
      RestFirebase.shutdown
    end

    private

    def privmsg(nick, channel, message)
      post(nick, PRIVMSG, channel, message)
    end
  end
end
