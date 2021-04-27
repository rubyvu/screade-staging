module TimeHelper

  def year(time)
    format_time(time, "%Y")
  end
  
  def month_with_date(time)
    if is_twelve_hours_format
      format_time(time, "%m/%d/%Y")
    else
      format_time(time, "%d.%m.%Y")
    end
  end
  
  def hours_seconds(time)
    if is_twelve_hours_format
      format_time(time, "%I:%M %p")
    else
      format_time(time, "%H:%M")
    end
  end
  
  def comment_timestamp(time)
    if is_twelve_hours_format
      format_time(time, "%m/%d/%Y-%I:%M %p")
    else
      format_time(time, "%d.%m.%Y-%H:%M")
    end
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
    
    def is_twelve_hours_format
      current_location = cookies[:current_location]&.upcase
      current_location = 'US' if current_location.blank?
      
      countries_with_twelve_hours_format = ['AU', 'BD', 'CA', 'CO', 'EG', 'SV', 'HN', 'IN', 'IE', 'JO', 'MY', 'MX', 'NZ', 'NI', 'PK', 'PH', 'SA', 'US']
      countries_with_twelve_hours_format.include?(current_location)
    end
end
