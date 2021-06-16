module ChatHelper
  def last_message_text(message)
    return unless message
    case message.message_type
    when 'text'
      message.text
    when 'audio'
      "#{message.user.username} sent audio message"
    when 'video'
      "#{message.user.username} sent video"
    when 'image'
      "#{message.user.username} sent image"
    end
  end
end
