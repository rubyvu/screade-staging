class SendDefaultPushNotificationJob < ApplicationJob
  
  def run(registration_ids, message)
    Tasks::PushNotificationsTask.send_default_push_notification(registration_ids, message)
  end
end
