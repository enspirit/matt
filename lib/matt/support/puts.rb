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

    end # module Puts
  end # module Support
end # module Matt
