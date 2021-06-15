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

    def data_at(at_predicate)
      full_data.restrict(at_predicate)
    end

    def full_data
      raise NotImplementedError, "#{self} must implement `full_data`"
    end

  end # module Measure
end # module Matt
