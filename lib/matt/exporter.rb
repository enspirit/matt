module Matt
  module Exporter
    include Support::Participant

    def export(measure, data)
      raise NotImplementedError, "#{self} should implement `export`"
    end

  end # module Exporter
end # module Matt
require_relative 'exporter/sql'
