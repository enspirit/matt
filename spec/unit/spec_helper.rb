require 'rspec'
require 'stringio'
require 'matt'

module SpecHelper

  def fixtures_folder
    Path.dir.parent/"fixtures"
  end

  def helloworld_config
    Matt::Configuration.new(fixtures_folder/"helloworld")
  end

  def base_command(set_config = true)
    Matt::Command.new{|c|
      c.configuration = helloworld_config if set_config
      c.stdout = StringIO.new
      c.stderr = StringIO.new
    }
  end

end

RSpec.configure do |c|
  c.include SpecHelper
end
