module Matt
  module Datasource
    include Support::Participant

    def ping
      raise NotImplementedError, "#{self} should implement `ping`"
    end

  end # module Datasource
end # module Matt
require_relative 'datasource/sql'
