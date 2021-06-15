require 'date'
require 'ostruct'
require 'json'
require 'sequel'
require 'bmg'
require 'path'
require 'bmg/sequel'
module Matt

  class Error < StandardError; end
  class UnexpectedError < Error; end

  def env(which, default = nil)
    val = ENV.has_key?(which) ? ENV[which] : default
    val = val.strip if val.is_a?(String)
    val
  end
  module_function :env

  def env!(which)
    raise Matt::Error, "Missing env var `#{which}`" unless ENV.has_key?(which)
    env(which)
  end
  module_function :env!

  def alltime_predicate
    Predicate.tautology
  end
  module_function :alltime_predicate

  def yesterday_predicate
    Predicate.gte(:at, Date.today - 1) & Predicate.lt(:at, Date.today)
  end
  module_function :yesterday_predicate

  def today_predicate
    Predicate.gte(:at, Date.today) & Predicate.lt(:at, Date.today + 1)
  end
  module_function :today_predicate

  def last_predicate(arg)
    raise Error, "Invalid predicate `#{arg}`" unless arg.strip =~ /^(\d+)days$/
    Predicate.gte(:at, Date.today - $1.to_i) & Predicate.lt(:at, Date.today + 1)
  end
  module_function :last_predicate

  def since_predicate(arg)
    raise Error, "Invalid predicate `#{arg}`" unless since = Date.parse(arg)
    Predicate.gte(:at, since) & Predicate.lt(:at, Date.today + 1)
  end
  module_function :since_predicate

end # module Matt
require_relative 'matt/version'
require_relative 'matt/support'
require_relative 'matt/datasource'
require_relative 'matt/measure'
require_relative 'matt/exporter'
require_relative 'matt/configuration'
require_relative 'matt/command'
