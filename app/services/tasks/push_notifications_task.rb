module Tasks
  class PushNotificationsTask
    
    def self.send_default_push_notification(registration_ids, message)
      fcm_client = FCM.new(ENV['FCM_PUSH_NOTIFICATION_KEY'])
      options = {
        priority: 'high',
        data: {
          message: message
        },
        notification: {
          body: 'message',
          sound: 'default'
        }
      }
      
      fcm_client.send(registration_ids, options)
    end
  end
end
