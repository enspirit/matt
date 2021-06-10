module Matt
  module Measure
    include Support::Participant

    def dimensions
      {}
    end

    def exporters
      []
    end

    def metrics
      raise NotImplementedError, "#{self} must implement `metrics`"
    end

    def ds
      configuration.datasources
    end

  end # module Measure
end # module Matt
