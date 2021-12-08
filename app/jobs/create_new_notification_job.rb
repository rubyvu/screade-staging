class CreateNewNotificationJob < ApplicationJob
  
  def run(source_id, source_type)
    case source_type
    when 'BreakingNews'
      Tasks::NotificationTask.new_breaking_news(source_id)
    when 'Comment'
      Tasks::NotificationTask.new_comment(source_id)
    when 'ChatMembership'
      Tasks::NotificationTask.new_chat_membership(source_id)
    when 'ChatMessage'
      Tasks::NotificationTask.new_chat_message(source_id)
    when 'ChatAudioRoom'
      Tasks::NotificationTask.new_audio_room(source_id)
    when 'ChatVideoRoom'
      Tasks::NotificationTask.new_video_room(source_id)
    when 'Event'
      Tasks::NotificationTask.new_event(source_id)
    when 'Post'
      Tasks::NotificationTask.new_post(source_id)
    when 'SharedRecord'
      Tasks::NotificationTask.new_shared_record(source_id)
    when 'Stream'
      Tasks::NotificationTask.new_stream(source_id)
    when 'UserImage'
      Tasks::NotificationTask.new_user_image(source_id)
    when 'UserVideo'
      Tasks::NotificationTask.new_user_video(source_id)
    when 'SquadRequest'
      Tasks::NotificationTask.new_squad_request(source_id)
    end
  end
end
