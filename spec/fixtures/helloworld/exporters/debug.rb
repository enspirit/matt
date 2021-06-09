class Debug
  include Matt::Exporter

  def export(measure, data)
    puts data.debug
  end

end
Debug.new
