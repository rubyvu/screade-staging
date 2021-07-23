module Tasks
  class NotificationTask
    
    def self.new_breaking_news(id)
      breaking_news = BreakingNews.find_by(id: id)
      return if breaking_news.blank?
      
      User.joins(:setting).where(settings: { is_notification: true }).find_each do |recipient|
        notificatiom_params = {
          source_id: breaking_news.id,
          source_type: 'BreakingNews',
          recipient_id: recipient.id,
          message: "Breaking News is changed"
        }
        
        create_notification(notificatiom_params)
      end
    end
    
    def self.new_chat_message(id)
      chat_message = ChatMessage.find_by(id: id)
      return if chat_message.blank?
      
      # Send Notification to Users that NOT connected to the Chat
      chat_connections = Redis.new.pubsub("channels", "chat_#{chat_message.chat.access_token}_*_channel")
      usernames_list = chat_connections.map { |connection| connection.remove("chat_#{chat_message.chat.access_token}_").remove('_channel') }
      
      ChatMembership.joins(:user).where(chat: chat_message.chat, is_mute: false).where.not(user: { username: usernames_list}).each do |chat_membership|
        # Check if User already get Notification from this Chat and it's unviewed
        next if ChatMessage.joins(:notifications).where(notifications: { source_type: 'ChatMessage', is_viewed: false, recipient: chat_membership.user }, chat_messages: { chat: chat_message.chat}).present?
        
        notificatiom_params = {
          source_id: chat_message.id,
          source_type: 'ChatMessage',
          sender_id: chat_message.user.id,
          recipient_id: chat_membership.user.id,
          message: "New message in #{chat_message.chat.name} chat"
        }
        
        create_notification(notificatiom_params) if notificatiom_params[:message].present?
      end
    end
    
    def self.new_audio_room(id)
      chat_audio_room = ChatAudioRoom.find_by(id: id)
      return if chat_audio_room.blank? || chat_audio_room.status == 'completed'
      
      chat_connections = Redis.new.pubsub("channels", "chat_#{chat_audio_room.chat.access_token}_*_channel")
      usernames_list = chat_connections.map { |connection| connection.remove("chat_#{chat_audio_room.chat.access_token}_").remove('_channel') }
      
      ChatMembership.joins(:user).where(chat: chat_audio_room.chat).where.not(user: { username: usernames_list}).each do |chat_membership|
        # Check if User already get Notification from this Chat and it's unviewed
        next if ChatAudioRoom.joins(:notifications).where(notifications: { source_type: 'ChatAudioRoom', is_viewed: false, recipient: chat_membership.user }, chat_audio_rooms: { chat: chat_audio_room.chat }).present?
        
        notificatiom_params = {
          source_id: chat_audio_room.id,
          source_type: 'ChatAudioRoom',
          recipient_id: chat_membership.user.id,
          message: "New Audio Call in #{chat_audio_room.chat.name} chat"
        }
        
        create_notification(notificatiom_params) if notificatiom_params[:message].present?
      end
    end
    
    def self.new_video_room(id)
      chat_video_room = ChatVideoRoom.find_by(id: id)
      return if chat_video_room.blank? || chat_video_room.status == 'completed'
      
      chat_connections = Redis.new.pubsub("channels", "chat_#{chat_video_room.chat.access_token}_*_channel")
      usernames_list = chat_connections.map { |connection| connection.remove("chat_#{chat_message.chat.access_token}_").remove('_channel') }
      
      ChatMembership.joins(:user).where(chat: chat_video_room.chat).where.not(user: { username: usernames_list}).each do |chat_membership|
        # Check if User already get Notification from this Chat and it's unviewed
        next if ChatVideoRoom.joins(:notifications).where(notifications: { source_type: 'ChatVideoRoom', is_viewed: false, recipient: chat_membership.user }, chat_video_rooms: { chat: chat_video_room.chat }).present?
        
        notificatiom_params = {
          source_id: chat_video_room.id,
          source_type: 'ChatVideoRoom',
          recipient_id: chat_membership.user.id,
          message: "New Video Call in #{chat_video_room.chat.name} chat"
        }
        
        create_notification(notificatiom_params) if notificatiom_params[:message].present?
      end
    end
    
    def self.new_comment(id)
      comment = Comment.find_by(id: id)
      return if comment.blank?
      
      notificatiom_params = { source_id: comment.id, source_type: 'Comment' }
      if comment.comment_id.present? # Replied Comment
        notificatiom_params[:recipient_id] = comment.comment.user.id
        notificatiom_params[:sender_id] = comment.user.id
        notificatiom_params[:message] = "#{comment.user.full_name} has replied to your comment"
      elsif comment.source_type == 'Post' # Comment for Post
        notificatiom_params[:recipient_id] = comment.source.user.id
        notificatiom_params[:sender_id] = comment.user.id
        notificatiom_params[:message] = "#{comment.user.full_name} commented on your Post"
      end
      
      create_notification(notificatiom_params) if notificatiom_params[:message].present?
    end
    
    def self.new_event(id)
      event = Event.find_by(id: id)
      return if event.blank?
      
      notificatiom_params = {
        source_id: event.id,
        source_type: 'Event',
        recipient_id: event.user.id,
        message: "#{event.title} starts very soon"
      }
      
      create_notification(notificatiom_params)
    end
    
    def self.new_post(id)
      post = Post.find_by(id: id)
      return if post.blank?
      
      sender = post.user
      recipients_ids = (sender.squad_requests_as_receiver.where.not(accepted_at: nil).pluck(:requestor_id) + sender.squad_requests_as_requestor.where.not(accepted_at: nil).pluck(:receiver_id)).uniq
      
      recipients_ids.each do |recipient_id|
        recipient = User.find_by(id: recipient_id)
        next unless recipient.setting.is_posts
        
        notificatiom_params = {
          source_id: post.id,
          source_type: 'Post',
          sender_id: sender.id,
          recipient_id: recipient.id,
          message: "#{sender.full_name} has new post"
        }
        
        create_notification(notificatiom_params)
      end
    end
    
    def self.new_user_image(id)
      user_image = UserImage.find_by(id: id)
      return if user_image.blank?
      
      sender = user_image.user
      recipients_ids = (sender.squad_requests_as_receiver.where.not(accepted_at: nil).pluck(:requestor_id) + sender.squad_requests_as_requestor.where.not(accepted_at: nil).pluck(:receiver_id)).uniq
      
      recipients_ids.each do |recipient_id|
        recipient = User.find_by(id: recipient_id)
        next unless recipient.setting.is_images
        
        notificatiom_params = {
          source_id: user_image.id,
          source_type: 'UserImage',
          sender_id: sender.id,
          recipient_id: recipient.id,
          message: "#{sender.full_name} has uploaded new Image"
        }
        
        create_notification(notificatiom_params)
      end
    end
    
    def self.new_user_video(id)
      user_video = UserVideo.find_by(id: id)
      return if user_video.blank?
      
      sender = user_video.user
      recipients_ids = (sender.squad_requests_as_receiver.where.not(accepted_at: nil).pluck(:requestor_id) + sender.squad_requests_as_requestor.where.not(accepted_at: nil).pluck(:receiver_id)).uniq
      
      recipients_ids.each do |recipient_id|
        recipient = User.find_by(id: recipient_id)
        next unless recipient.setting.is_videos
        
        notificatiom_params = {
          source_id: user_video.id,
          source_type: 'UserVideo',
          sender_id: sender.id,
          recipient_id: recipient.id,
          message: "#{sender.full_name} has uploaded new Video"
        }
        
        create_notification(notificatiom_params)
      end
    end
    
    def self.new_squad_request(id)
      squad_request = SquadRequest.find_by(id: id)
      return if squad_request.blank?
      
      notificatiom_params = {
        source_id: squad_request.id,
        source_type: 'SquadRequest',
        sender_id: squad_request.requestor.id,
        recipient_id: squad_request.receiver.id,
        message: "#{squad_request.requestor.full_name} want to join to your Squad"
      }
      
      create_notification(notificatiom_params)
    end
    
    private
      def self.create_notification(notificatiom_params)
        notification = Notification.create!(notificatiom_params)
        NotificationChannel.broadcast_to(notification.recipient, bage_counter: notification.recipient.received_notifications.count)
      end
  end
end
