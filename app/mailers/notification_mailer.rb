class NotificationMailer < ApplicationMailer
  helper NotificationHelper
  
  def notify_user(notification_id)
    @notification = Notification.find_by(id: notification_id)
    return unless @notification
    
    mail to: @notification.recipient.email, subject: 'New notification in Screade'
  end
end
