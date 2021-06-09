class Main
  include Matt::Datasource

  def account_creations
    Bmg::Relation.new([
      {
        :at => Date.parse("2021-01-01"),
        :country => "US",
        :count => 172
      },
      {
        :at => Date.parse("2021-01-01"),
        :country => "BE",
        :count => 10
      },
      {
        :at => Date.parse("2021-01-01"),
        :country => nil,
        :count => 10
      },
      {
        :at => Date.parse("2021-02-01"),
        :country => "US",
        :count => 82
      },
      {
        :at => Date.parse("2021-02-01"),
        :country => "BE",
        :count => 15
      },
      {
        :at => Date.parse("2021-02-01"),
        :country => nil,
        :count => 15
      }
    ])
  end

  def ping
    puts "Ok."
  end

end
Main.new
