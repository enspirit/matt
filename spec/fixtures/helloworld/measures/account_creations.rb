class AccountCreations
  include Matt::Measure

  def cron
    %Q{ 0 8 * * * }
  end

  def exporters
    %w{ debug }
  end

  def dimensions
    { :country => String }
  end

  def metrics
    { :count => Integer }
  end

  def full_data
    ds.main.account_creations
  end

end
AccountCreations.new
