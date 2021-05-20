class CreateNewNotificationsJob < ApplicationJob
  
  def run(source_id, source_type)
    
    case source_type
    when 'Comment'
      Tasks::NotificationTask.new_comment(source_id)
    when 'Event'
      Tasks::NotificationTask.new_event(source_id)
    when 'Post'
      Tasks::NotificationTask.new_post(source_id)
    when 'UserImage'
      Tasks::NotificationTask.new_user_image(source_id)
    when 'UserVideo'
      Tasks::NotificationTask.new_user_video(source_id)
    when 'SquadRequest'
      Tasks::NotificationTask.new_squad_request(source_id)
    end
  end
end
