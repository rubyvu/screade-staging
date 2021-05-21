module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    
    def connect
      self.current_user = find_verified_user
    end
    
    protected
      def find_verified_user
        current_user = env['warden'].user(:user) # Get user from warden env for User model(not AdminUser)
        if current_user
          current_user
        else
          reject_unauthorized_connection
        end
      end
      
  end
end
