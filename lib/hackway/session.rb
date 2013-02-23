# encoding: utf-8

require 'open-uri'
require 'net/irc'
require 'nokogiri'

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
    end

    def main_channel
      '#hackernews'
    end

    def on_user(message)
      super
      post(@nick, JOIN, main_channel)

      @monitoring_thread = Thread.start do
        loop do
          @log.info('monitoring articles...')
          monitoring(main_channel)
          @log.info("sleep #{@opts.wait} seconds")
          sleep @opts.wait
        end
      end
    rescue => e
      @log.error(e.to_s)
    end

    def on_disconnected
      @monitoring_thread.kill rescue nil
    end

    private
      def monitoring(channel)
        articles = Nokogiri::HTML(open('http://news.ycombinator.com/news')).search('.title')
        subtexts = Nokogiri::HTML(open('http://news.ycombinator.com/news')).search('.subtext')

        while articles.size > 1
          articles.shift
          article = articles.shift.at('a')
          subtext = subtexts.shift

          url = article.attributes['href'].text
          next if @notified_articles.include?(url)
          @notified_articles << url

          title    = article.text
          score    = subtext.at('span').text
          user     = subtext.search('a').first.text
          comments = extract_comments(subtext.search('a').last)

          privmsg(user, channel, "#{title} #{url} (#{score}) #{comments[:count]} - #{comments[:url]}")
        end
      rescue Exception => e
        @log.error(e.inspect)
        e.backtrace.each { |l| @log.error "\t#{l}" }
        sleep 300 # Retry after 300 seconds.
      end

      def privmsg(nick, channel, message)
        post(nick, PRIVMSG, channel, message)
      end

      def extract_comments(comments_dom)
        {
          count: comments_dom.text,
          url:   "http://news.ycombinator.com/#{comments_dom.attributes['href'].text}"
        }
      end
  end
end
