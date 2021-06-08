module Matt
  module Measure
    include Support::Puts

    attr_accessor :name
    attr_accessor :configuration

    def ds
      configuration.datasources
    end

  end # module Measure
end # module Matt
