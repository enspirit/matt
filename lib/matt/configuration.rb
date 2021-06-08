module Matt
  class Configuration

    def initialize(folder)
      @folder = folder
    end
    attr_reader :folder

    def datasources_folder
      folder/"datasources"
    end

    def datasources
      @datasources ||= load_dynamic_objects(datasources_folder)
    end

    def measures_folder
      folder/"measures"
    end

    def measures
      @measures ||= load_dynamic_objects(measures_folder)
    end

    def exporters_folder
      folder/"exporters"
    end

    def exporters
      @exporters ||= load_dynamic_objects(exporters_folder)
    end

  private

    def load_dynamic_objects(datasources_folder)
      struct = OpenStruct.new
      datasources_folder.glob("*.rb").each_with_object(struct) do |file,memo|
        obj = load_dynamic_object(file)
        if obj.nil?
          raise "Wrong file #{file}, eval returned nil"
        else
          obj.configuration = self
          memo.send("#{file.basename.rm_ext}=", obj)
        end
      end
    end

    def load_dynamic_object(file)
      Kernel.eval(file.read, nil, file.to_s)
    end

  end # class Configuration
end # module Matt
