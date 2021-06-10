#/
#/ Matt - A monitoring tool for data-driven business decisions
#/ vVERSION - (c) Enspirit SRL, 2021 and beyond
#/
#/ Usage: matt [-f folder] command [options...] [args...]
#/
#/ show measure           Show the datapoints of a given measure
#/ export measure*        Export all (or specific) measure(s) to
#/ ping datasource*       Ping all (or specific) datasource(s)
#/                        their default exporters
#/
#/ -f FOLDER              Use the folder as entry point (`pwd` by default)
#/     --all-time         Do not restrict measures shown/exported
#/     --today            Only show/export measures for today
#/     --yesterday        Only show/export measures for yesterday's (default)
#/     --to=exporter,...  Override the default exporters
#/     --json             Use json when displaying measures on console
#/     --csv              Use csv when displaying measures on console (default)
#/     --silent           Do not print any info/debug messages
#/     --verbose          Print debug information in addition to info messages
#/ -h, --help             Show this help message
#/     --version          Show matt version
#/
#/ Examples:
#/     matt show --all-time --json account_creations
#/     matt export --today --to=sql,prometheus account_creations
#/
require 'optparse'
module Matt
  class Command
    include Support::Puts

    attr_accessor :exitcode
    attr_accessor :output_format
    attr_accessor :to

    def initialize
      @output_format = :csv
      @to = nil
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
      which_ones = argv_to_xs(argv, :datasources)
      which_ones.each do |d|
        d.ping
      end
    end

    def do_export(argv)
      which_ones = argv_to_xs(argv, :measures)
      which_ones.each do |m|
        data = m.full_data.restrict(configuration.at_predicate)
        (@to || m.exporters).each do |e|
          exporter = exporter_exists!(e)
          exporter.export(m, data)
        end
      end
    end

    def do_help(*args)
      file = __FILE__
      exec "grep ^#/<'#{file}'|cut -c4-|sed s/VERSION/#{Matt::VERSION}/g"
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
        opts.on("--to=EXPORTERS") do |exporters|
          @to = (@to || []) + exporters.split(/\s*,\s*/).map{|e|
            exporter_exists!(e.to_sym).name
          }
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
        opts.on("--silent") do
          self.configuration.debug_level = Configuration::DEBUG_SILENT
        end
        opts.on("--verbose") do
          self.configuration.debug_level = Configuration::DEBUG_VERBOSE
        end
        opts.on("-h", "--help", "Prints this help") do
          do_help
          abort
        end
      end
    end

    def argv_count!(argv, n)
      return if argv.size == n
      puts_err "#{n} arguments expected, got #{argv.size}"
      abort
    end

    def x_exists!(name, xs)
      x = configuration.send(xs).send(name.to_sym)
      return x if x
      puts_err "No such #{xs[0...-1]} #{name}"
      abort
    end

    def measure_exists!(name)
      x_exists!(name, :measures)
    end

    def exporter_exists!(name)
      x_exists!(name, :exporters)
    end

    def datasource_exists!(name)
      x_exists!(name, :datasources)
    end

    def argv_to_xs(argv, xs)
      if argv.empty?
        configuration.send(xs).to_h.values
      else
        argv.map{|arg| x_exists!(arg, xs) }
      end
    end

    def abort
      throw :abort
    end

  end # class Command
end # module Matt
