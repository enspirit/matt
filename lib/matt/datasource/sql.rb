module Matt
  module Datasource
    class Sql
      include Matt::Datasource

      def initialize(config)
        @config = config
        @sequel_db = ::Sequel.connect(config)
      end
      attr_reader :config, :sequel_db

      def ping
        sequel_db.test_connection
        puts "#{self} -- Ok."
      rescue => ex
        puts_err "#{self} -- Ko: #{ex.message}"
      end

      def to_s
        if config.is_a?(Hash)
          "#{config[:host]}:#{config[:port]}/#{config[:database]}"
        else
          config.to_s
        end
      end

      def sequel(*args)
        Bmg.sequel(*args)
      end

    end
  end
end
