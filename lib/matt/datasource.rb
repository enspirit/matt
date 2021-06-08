module Matt
  module Datasource
    include Support::Puts

    attr_accessor :name
    attr_accessor :configuration

    def ping
      raise NotImplementedError, "#{self} should implement `ping`"
    end

  end # module Datasource
end # module Matt
