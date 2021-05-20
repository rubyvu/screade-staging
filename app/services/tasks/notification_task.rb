module Tasks
  class NotificationTask
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
        message: "Starts in 30 minutes"
      }
      
      create_notification(notificatiom_params)
    end
    
    def self.new_post(id)
      post = Post.find_by(id: id)
      return if post.blank?
      
      sender = post.user
      recipients_ids = sender.squad_requests_as_receiver.where.not(accepted_at: nil).pluck(:requestor_id).or(sender.squad_requests_as_requestor.where.not(accepted_at: nil).pluck(:reciver_id)).uniq
      
      recipients_ids.each do |recipient_id|
        notificatiom_params = {
          source_id: post.id,
          source_type: 'Post',
          sender_id: sender.id,
          recipient_id: recipient_id,
          message: "#{sender.full_name} has new post"
        }
        
        create_notification(notificatiom_params)
      end
    end
    
    def self.new_user_image(id)
      user_image = UserImage.find_by(id: id)
      return if user_image.blank?
      
      sender = user_image.user
      recipients_ids = sender.squad_requests_as_receiver.where.not(accepted_at: nil).pluck(:requestor_id).or(sender.squad_requests_as_requestor.where.not(accepted_at: nil).pluck(:reciver_id)).uniq
      
      recipients_ids.each do |recipient_id|
        notificatiom_params = {
          source_id: user_image.id,
          source_type: 'UserImage',
          sender_id: sender.id,
          recipient_id: recipient_id,
          message: "#{sender.full_name} has uploaded new Image"
        }
        
        create_notification(notificatiom_params)
      end
    end
    
    def self.new_user_video(id)
      user_video = UserVideo.find_by(id: id)
      return if user_video.blank?
      
      sender = user_video.user
      recipients_ids = sender.squad_requests_as_receiver.where.not(accepted_at: nil).pluck(:requestor_id).or(sender.squad_requests_as_requestor.where.not(accepted_at: nil).pluck(:reciver_id)).uniq
      
      recipients_ids.each do |recipient_id|
        notificatiom_params = {
          source_id: user_video.id,
          source_type: 'UserVideo',
          sender_id: sender.id,
          recipient_id: recipient_id,
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
        message: "#{squad_request.requestor.full_name} whant to join to your Squad"
      }
      
      create_notification(notificatiom_params)
    end
    
    private
      def self.create_notification(notificatiom_params)
        puts notificatiom_params
        n = Notification.create(notificatiom_params)
        puts n.errors.full_messages
      end
  end
end
