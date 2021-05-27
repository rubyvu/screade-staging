module Tasks
  class PushNotificationsTask
    
    def self.send_default_push_notification(notification_id)
      notification = Notification.find_by(id: notification_id)
      return if notification.blank?
      
      # List of devices ids that will get notification
      registration_ids = notification.recipient.devices.where.not(push_token: nil).pluck(:push_token)
      
      fcm_client = FCM.new(ENV['FCM_PUSH_NOTIFICATION_KEY'])
      
      # Push Notification params
      options = {
        priority: 'high',
        data: {
          source_id: notification.source_id,
          source_type: notification.source_type
        },
        notification: {
          title: "New #{notification.source_type}".titleize.humanize,
          body: notification.message,
          badge: notification.recipient.received_notifications.unviewed.count,
          sound: 'default'
        }
      }
      
      fcm_client.send(registration_ids, options)
    end
  end
end
