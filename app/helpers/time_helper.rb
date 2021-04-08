module TimeHelper
  def format_time(time, format = "yyyy-MM-dd'T'HH:mm:ss.SSSxxx")
    content_tag(
      :span,
      time,
      data: { "time-format": format, "time-value": time.to_json }
    )
  end

  def relative_time(time)
    format_time(time, :relative)
  end

  def year(time)
    format_time(time, "yyyy")
  end
  
  def month_with_date(time)
    format_time(time, "MM.dd.yyyy")
  end
  
  def hours_seconds(time)
    format_time(time, "HH:mm")
  end
  
  def comment_timestamp(time)
    format_time(time, "MM/dd/yyyy-HH:mm")
  end
end
