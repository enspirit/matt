module Matt
  module Measure
    attr_accessor :name
    attr_accessor :configuration

    def ds
      configuration.datasources
    end

  end # module Measure
end # module Matt
