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
      "#{message.user.username} sent photo"
    when 'video-room'
      if message.chat_room_source.status == 'in-progress'
        "Video call in progress"
      else
        "Video call in ended"
      end
    when 'audio-room'
      if message.chat_room_source.status == 'in-progress'
        "Audio call in progress"
      else
        "Audio call in ended"
      end
    end
  end
end
