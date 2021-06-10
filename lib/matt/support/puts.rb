module Matt
  module Support
    module Puts

      def stdout
        configuration.stdout
      end

      def stderr
        configuration.stderr
      end

      def puts_out(*args, &bl)
        return $stdout.puts(*args, &bl) unless configuration
        configuration.stdout.puts(*args, &bl)
      end
      alias :puts :puts_out

      def puts_err(*args, &bl)
        return $stderr.puts(*args, &bl) unless configuration
        configuration.stderr.puts(*args, &bl)
      end

      def info(message)
        message = "#{self.to_s.ljust(30)} -- #{message}"
        return $stderr.puts(message) unless configuration
        return unless configuration.debug_level >= Configuration::DEBUG_INFO
        puts_err(message)
      end

      def debug(message)
        message = "#{self.to_s.ljust(30)} -- #{message}"
        return $stderr.puts(message) unless configuration
        return unless configuration.debug_level >= Configuration::DEBUG_VERBOSE
        puts_err(message)
      end

    end # module Puts
  end # module Support
end # module Matt
