module Matt
  class Configuration

    def initialize(folder)
      @folder = folder
      @stdout = $stdout
      @stderr = $stderr
      @csv_options = {
        :write_headers => true
      }
      @at_predicate = Matt.yesterday_predicate
      yield(self) if block_given?
    end
    attr_accessor :folder
    attr_accessor :stdout, :stderr
    attr_accessor :csv_options
    attr_accessor :at_predicate

    def datasources_folder
      folder/"datasources"
    end

    def datasources
      @datasources ||= load_dynamic_objects(datasources_folder)
    end
    alias :ds :datasources

    def measures_folder
      folder/"measures"
    end

    def measures
      @measures ||= load_dynamic_objects(measures_folder)
    end
    alias :ms :measures

    def exporters_folder
      folder/"exporters"
    end

    def exporters
      @exporters ||= load_dynamic_objects(exporters_folder)
    end
    alias :es :exporters

  private

    def load_dynamic_objects(datasources_folder)
      struct = OpenStruct.new
      datasources_folder.glob("*.rb").each_with_object(struct) do |file,memo|
        obj = load_dynamic_object(file)
        if obj.nil?
          raise "Wrong file #{file}, eval returned nil"
        else
          obj.configuration = self
          obj.name = file.basename.rm_ext.to_s
          memo.send("#{obj.name}=", obj)
        end
      end
    end

    def load_dynamic_object(file)
      Kernel.eval(file.read, nil, file.to_s)
    end

  end # class Configuration
end # module Matt
