require 'date'
require 'ostruct'
require 'json'
require 'bmg'
require 'path'
module Matt

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

end # module Matt
require_relative 'matt/version'
require_relative 'matt/support'
require_relative 'matt/datasource'
require_relative 'matt/measure'
require_relative 'matt/exporter'
require_relative 'matt/configuration'
require_relative 'matt/command'
