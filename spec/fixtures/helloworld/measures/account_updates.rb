class AccountUpdates
  include Matt::Measure

  def cron
    %Q{ 0 8 * * * }
  end

  def exporters
    %w{ stdout }
  end

  def dimensions
    { :country => String }
  end

  def metrics
    { :count => Integer }
  end

  def full_data
    ds.main.account_updates
  end

end
AccountUpdates.new
