$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'matt/version'
require 'date'

Gem::Specification.new do |s|
  s.name        = 'matt'
  s.version     = Matt::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Matt help monitoring data points for better business decision."
  s.description = ""
  s.authors     = ["Bernard Lambeau"]
  s.email       = 'blambeau@gmail.com'
  s.files       = Dir['LICENSE.md', 'Gemfile','Rakefile', '{bin,lib}/**/*', 'README.md']
  s.homepage    = 'http://github.com/enspirit/matt'
  s.license     = 'MIT'
  s.executables = (Dir["bin/*"]).collect{|f| File.basename(f)}

  s.add_dependency "path", ">= 2.0", "< 3.0"
  s.add_dependency "bmg", ">= 0.18.5", "< 0.19"

  s.add_development_dependency "rake", ">= 13.0", "< 14.0"
  s.add_development_dependency "rspec", ">= 3.10", "< 4.0"
end
