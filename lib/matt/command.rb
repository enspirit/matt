require 'optparse'
module Matt
  class Command
    include Support::Puts

    attr_accessor :exitcode
    attr_accessor :output_format

    def initialize
      @output_format = :csv
      yield(self) if block_given?
    end

    def on_configuration(&bl)
      @on_configuration = bl
      self
    end

    def configuration
      return @configuration if @configuration
      self.configuration = Configuration.new(Path.pwd)
    end

    def configuration=(c)
      @on_configuration.call(c) if @on_configuration
      @configuration = c
    end

    def has_configuration?
      !!@configuration
    end

    def parse_argv(argv)
      opt_parser.parse!(argv)
    end

    def call(argv)
      ok = false
      catch :abort do
        parse_argv(argv)
        _call(argv)
        ok = true
      end
      self.exitcode = ok ? 0 : 1
    end

  protected

    def _call(argv)
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

    def do_show(argv)
      argv_count!(argv, 1)
      m = measure_exists!(argv.first)
      data = m.full_data.restrict(configuration.at_predicate)
      case of = output_format
      when :json
        puts_out JSON.pretty_generate(data)
      when :csv
        puts_out data.to_csv(configuration.csv_options)
      else
        puts_err "Unknown format #{of}"
      end
    end

    def do_ping(argv)
      which_ones = if argv.empty?
        configuration.datasources.to_h.values
      else
        argv.map{|arg| datasource_exists!(arg) }
      end
      which_ones.each do |d|
        d.ping
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
        opts.on("--all-time") do
          self.configuration.at_predicate = Matt.alltime_predicate
        end
        opts.on("--yesterday") do
          self.configuration.at_predicate = Matt.yesterday_predicate
        end
        opts.on("--today") do
          self.configuration.at_predicate = Matt.today_predicate
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

    def datasource_exists!(name)
      d = configuration.datasources.send(name.to_sym)
      return d if d
      puts_err "No such datasource #{name}"
      abort
    end

    def abort
      throw :abort
    end

  end # class Command
end # module Matt
