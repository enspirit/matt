module Matt
  module Exporter
    include Support::Puts

    attr_accessor :name
    attr_accessor :configuration

  end # module Exporter
end # module Matt
require_relative 'exporter/sql'
