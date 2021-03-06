module Matt
  class Configuration

    DEBUG_SILENT = 0
    DEBUG_INFO = 1
    DEBUG_VERBOSE = 2

    def initialize(folder)
      @folder = folder
      @stdout = $stdout
      @stderr = $stderr
      @csv_options = {
        :write_headers => true
      }
      @at_predicate = Matt.yesterday_predicate
      @debug_level = DEBUG_INFO
      yield(self) if block_given?
    end
    attr_accessor :folder
    attr_accessor :stdout, :stderr
    attr_accessor :csv_options
    attr_accessor :at_predicate
    attr_accessor :debug_level

    def datasources_folder
      folder/"datasources"
    end

    def datasources
      @datasources ||= load_dynamic_objects(datasources_folder, Matt::Datasource)
    end
    alias :ds :datasources

    def measures_folder
      folder/"measures"
    end

    def measures
      @measures ||= load_dynamic_objects(measures_folder, Matt::Measure)
    end
    alias :ms :measures

    def exporters_folder
      folder/"exporters"
    end

    def exporters
      @exporters ||= load_dynamic_objects(exporters_folder, Matt::Exporter)
    end
    alias :es :exporters

  private

    def load_dynamic_objects(folder, expected_type)
      struct = OpenStruct.new
      folder.glob("*.rb").each_with_object(struct) do |file,memo|
        obj = load_dynamic_object(file)
        if obj.nil?
          raise "Wrong file #{file}: eval returned nil"
        elsif !obj.is_a?(expected_type)
          raise "Wrong file #{file}: must include #{expected_type}"
        else
          obj.configuration = self
          obj.name = file.basename.rm_ext.to_s
          memo.send("#{obj.name}=", obj)
        end
      end
    end

    def load_dynamic_object(file)
      self.instance_eval(file.read, file.to_s)
    end

  end # class Configuration
end # module Matt
