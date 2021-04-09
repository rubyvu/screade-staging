module TimeHelper

  def year(time)
    format_time(time, "%Y")
  end
  
  def month_with_date(time)
    format_time(time, "%m.%d.%Y")
  end
  
  def hours_seconds(time)
    format_time(time, "%H:%M")
  end
  
  def comment_timestamp(time)
    format_time(time, "%m/%d/%Y-%H:%M")
  end
  
  private
    def format_time(date_time, time_format)
      begin
        time_zone_cookies = cookies[:time_zone].to_i
        timezone = ActiveSupport::TimeZone[-time_zone_cookies.minutes]
        date_time.in_time_zone(timezone).strftime(time_format)
      rescue
        date_time.strftime(time_format)
      end
    end
end
