module TopicHelper
  def topic_full_title(object)
    if object.class.name == 'NewsCategory'
      object.title.capitalize
    else
      case object.nesting_position
      when 0
        "#{object.parent.title.capitalize} > #{object.title.capitalize}"
      when 1
        "#{object.parent.parent.title.capitalize} > #{object.parent.title.capitalize} > #{object.title.capitalize}"
      when 2
        "#{object.parent.parent.parent.title.capitalize} > #{object.parent.parent.title.capitalize} > #{object.parent.title.capitalize} > #{topic.title.capitalize}"
      end
    end
  end
end
