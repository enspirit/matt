require 'optparse'
module Matt
  class Command

    attr_accessor :stdout
    attr_accessor :stderr
    attr_accessor :configuration
    attr_accessor :output_format

    def initialize
      configuration = Configuration.new(Path.pwd)
      @output_format = :csv
      yield(self) if block_given?
    end

    def call(argv)
      catch :exit do
        opt_parser.parse!(argv)

        if argv.empty?
          puts opt_parser
          throw :exit
        end

        meth = :"do_#{argv.first}"
        if self.respond_to?(meth, true)
          send(meth, argv[1..-1])
        else
          stderr.puts "No such command #{argv.first}"
          throw :exit
        end
      end
    end

  protected

    def do_show(argv)
      argv_count!(argv, 1)
      m = measure_exists!(argv.first)
      case of = output_format
      when :json
        puts JSON.pretty_generate(m.full_data)
      when :csv
        puts m.full_data.to_csv
      else
        stderr.puts "Unknown format #{of}"
      end
    end

  protected

    def opt_parser
      OptionParser.new do |opts|
        opts.banner = "Usage: matt [options] COMMAND [args]"
        opts.on("--json") do
          self.output_format = :json
        end
        opts.on("--csv") do
          self.output_format = :csv
        end
        opts.on('--version', "Show version number") do
          puts "Matt v#{VERSION} - (c) Enspirit SRL"
          throw :exit
        end
        opts.on("-h", "--help", "Prints this help") do
          puts opts
          throw :exit
        end
      end
    end

    def argv_count!(argv, n)
      return if argv.size == n
      stderr.puts "#{n} arguments expected, got #{argv.size}"
      exit
    end

    def measure_exists!(name)
      m = configuration.measures.send(name.to_sym)
      return m if m
      stderr.puts "No such measure #{name}"
      exit
    end

    def puts(*args, &bl)
      stdout.puts(*args, &bl)
    end

  end # class Command
end # module Matt
