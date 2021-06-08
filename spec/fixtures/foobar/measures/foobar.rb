class Foobar
  include Matt::Measure

  def cron
    %Q{ 0 8 * * * }
  end

  def exporters
    %w{ debug }
  end

  def full_data
    Bmg::Relation.new [
      {
        :at => Date.parse("2021-01-01"),
        :foo => "bar",
        :count => 20
      }
    ]
  end

end
Foobar.new
