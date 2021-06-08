require 'optparse'
module Matt
  class Command

    attr_accessor :stdout
    attr_accessor :stderr
    attr_accessor :output_format

    def initialize
      @stdout = $stdout
      @stderr = $stderr
      @output_format = :csv
      yield(self) if block_given?
    end

    def configuration
      @configuration ||= Configuration.new(Path.pwd)
    end
    attr_writer :configuration

    def has_configuration?
      !!@configuration
    end

    def parse_argv(argv)
      opt_parser.parse!(argv)
    end

    def call(argv)
      catch :abort do
        argv = parse_argv(argv)

        if argv.empty?
          puts_out opt_parser
          abort
        end

        meth = :"do_#{argv.first}"
        if self.respond_to?(meth, true)
          send(meth, argv[1..-1])
        else
          puts_err "No such command #{argv.first}"
          abort
        end
      end
    end

  protected

    def do_show(argv)
      argv_count!(argv, 1)
      m = measure_exists!(argv.first)
      case of = output_format
      when :json
        puts_out JSON.pretty_generate(m.full_data)
      when :csv
        puts_out m.full_data.to_csv(configuration.csv_options)
      else
        puts_err "Unknown format #{of}"
      end
    end

  protected

    def opt_parser
      OptionParser.new do |opts|
        opts.banner = "Usage: matt [options] COMMAND [args]"
        opts.on("-f FOLDER") do |folder|
          p = Path(folder)
          if has_configuration?
            puts_err "-f must be used before other configuration options"
            abort
          elsif p.exists? && p.directory?
            self.configuration = Configuration.new(p)
          else
            puts_err "No such folder: #{folder}"
            abort
          end
        end
        opts.on("--json") do
          self.output_format = :json
        end
        opts.on("--csv") do
          self.output_format = :csv
        end
        opts.on('--version', "Show version number") do
          puts_out "Matt v#{VERSION} - (c) Enspirit SRL"
          abort
        end
        opts.on("-h", "--help", "Prints this help") do
          puts_out opts
          abort
        end
      end
    end

    def argv_count!(argv, n)
      return if argv.size == n
      puts_err "#{n} arguments expected, got #{argv.size}"
      abort
    end

    def measure_exists!(name)
      m = configuration.measures.send(name.to_sym)
      return m if m
      puts_err "No such measure #{name}"
      abort
    end

    def abort
      throw :abort
    end

    def puts_out(*args, &bl)
      stdout.send(:puts, *args, &bl)
    end

    def puts_err(*args, &bl)
      stderr.send(:puts, *args, &bl)
    end

  end # class Command
end # module Matt
