require 'net/irc'
require 'slop'

module Hackway
  class Server < Net::IRC::Server
    def initialize(opts = nil)
      opts ||= parse_options
      super(opts[:server], opts[:port], Hackway::Session, opts)
    end

    def parse_options
      opts = Slop.parse do |o|
        o.integer '-p', '--port', 'Port number to listen (default: 16706)', default: 16704
        o.string '-h', '--host',  'Host name or IP address to listen (default: 0.0.0.0)', default: '0.0.0.0'
        o.integer '-w', '--wait', 'Wait SECONDS between retrievals (default: 360)', default: 360
        o.string '-l', '--log',   'Log file (default: STDOUT)', default: nil
        o.on '-v', '--version', 'Print the version' do
          puts Hackway::VERSION
          exit
        end
        o.on '--help' do
          puts o
          exit
        end
      end

      logger = Logger.new(opts[:log] || STDOUT, 'daily')
      logger.level = Logger::DEBUG

      opts.to_hash.merge(logger: logger)
    end
  end
end
