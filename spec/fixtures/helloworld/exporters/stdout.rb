class Stdout
  include Matt::Exporter

  def export(measure, data)
    puts data.to_json
  end

end
Stdout.new
