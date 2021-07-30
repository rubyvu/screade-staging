module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    
    def connect
      self.current_user = find_verified_user
    end
    
    protected
      def find_verified_user
        # Get User for Web client
        current_user = env['warden'].user(:user) # Get user from warden env for User model(not AdminUser)
        
        # Try to get User for device client if Web is empty
        current_user = Device.find_by(access_token: request.headers['X-Device-Token'])&.owner unless current_user
        
        if current_user
          puts "User #{current_user&.username} was connect:"
          current_user
        else
          reject_unauthorized_connection
        end
      end
      
  end
end
