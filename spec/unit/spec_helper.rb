require 'rspec'
require 'stringio'
require 'matt'

module SpecHelper

  def helloworld_config
    Matt::Configuration.new(Path.dir.parent/"fixtures/helloworld")
  end

  def base_command
    Matt::Command.new{|c|
      c.configuration = helloworld_config
      c.stdout = StringIO.new
      c.stderr = StringIO.new
    }
  end

end

RSpec.configure do |c|
  c.include SpecHelper
end
