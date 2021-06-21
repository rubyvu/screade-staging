class SendDefaultPushNotificationJob < ApplicationJob
  
  def run(notification_id)
    Tasks::PushNotificationsTask.send_default_push_notification(notification_id)
  end
end
