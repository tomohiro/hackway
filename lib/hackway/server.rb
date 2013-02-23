require 'net/irc'
require 'slop'

module Hackway
  class Server < Net::IRC::Server
    def initialize(opts = nil)
      opts ||= parse_options
      super(opts[:server], opts[:port], Hackway::Session, opts)
    end

    def parse_options
      opts = Slop.parse(help: true) do
        banner 'Usage: iig [options]'
        on :p, :port,    'Port number to listen (default: 16705)',                 argument: :optional, as: :integer, default: 16705
        on :s, :server,  'Host name or IP address to listen (default: localhost)', argument: :optional, as: :string,  default: :localhost
        on :w, :wait,    'Wait SECONDS between retrievals (default: 360)',         argument: :optional, as: :integer, default: 360
        on :l, :log,     'Log file (default: STDOUT)',                             argument: :optional, as: :string,  default: nil
        on :v, :version, 'Print the version' do
          puts Hackway::VERSION
          exit
        end
      end

      exit if opts.present?(:help)

      logger = Logger.new(opts[:log] || STDOUT, 'daily')
      logger.level = Logger::DEBUG

      opts.to_hash.merge(logger: logger)
    end
  end
end
