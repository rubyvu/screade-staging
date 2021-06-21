class SendNotificationEmailJob < ApplicationJob
  
  def run(notification_id)
    NotificationMailer.notify_user(notification_id).deliver_now
  end
end
