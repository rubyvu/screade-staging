class CreateNewNotificationsJob < ApplicationJob
  
  def run(source_id, source_type)
    
    case source_type
    when 'Comment'
      Tasks::NotificationTask.new_comment(source_id)
    when 'Event'
      # TODO: Add it job on Event creation
      Tasks::NotificationTask.new_event(source_id)
    when 'Post'
      # TODO: each User in sender squad
      Tasks::NotificationTask.new_post(source_id)
    when 'UserImage'
      # TODO: each User in sender squad
      Tasks::NotificationTask.new_user_image(source_id)
    when 'UserVideo'
      # TODO: each User in sender squad
      Tasks::NotificationTask.new_user_video(source_id)
    when 'SquadRequest'
      Tasks::NotificationTask.new_squad_request(source_id)
    end
  end
end
