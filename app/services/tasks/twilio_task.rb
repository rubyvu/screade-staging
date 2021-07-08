module Tasks
  class TwilioTask
    
    def self.generate_access_token_for_user(username, room_sid)
      # Required for any Twilio Access Token
      account_sid = ENV['TWILIO_ACCOUNT_API_KEY_SID']
      api_key = ENV['TWILIO_CHAT_VIDEO_API_KEY_SID']
      api_secret = ENV['TWILIO_CHAT_VIDEO_API_KEY_SECRET']
      
      # Cheeck User presents
      return unless User.exists?(username: username)
      
      # Create an Access Token
      token = Twilio::JWT::AccessToken.new(account_sid, api_key, api_secret, [], identity: username);
      
      # Create Video grant for our token
      grant = Twilio::JWT::AccessToken::VideoGrant.new
      # grant.room = room_sid
      token.add_grant(grant)

      # Generate the token
      token.to_jwt
    end
    
    def self.create_new_room(unique_name)
      account_sid = ENV['TWILIO_ACCOUNT_API_KEY_SID']
      auth_token = ENV['TWILIO_ACCOUNT_API_KEY_TOKEN']
      @client = Twilio::REST::Client.new(account_sid, auth_token)
      
      begin
        room = @client.video.rooms.create(
           record_participants_on_connect: true,
           status_callback: 'https://www.screade.com' + '/webhooks/twilio/status_callback',
           type: 'group',
           unique_name: unique_name
         )
         
        room.sid
      rescue
        nil
      end
    end
    
    def self.complete_room(room_sid)
      account_sid = ENV['TWILIO_ACCOUNT_API_KEY_SID']
      auth_token = ENV['TWILIO_ACCOUNT_API_KEY_TOKEN']
      @client = Twilio::REST::Client.new(account_sid, auth_token)
      
      begin
        room = @client.video.rooms(room_sid).update(status: 'completed')
        room.unique_name
      rescue
        nil
      end
    end
    
    def self.retrieve_list_of_rooms(unique_name, status)
      account_sid = ENV['TWILIO_ACCOUNT_API_KEY_SID']
      auth_token = ENV['TWILIO_ACCOUNT_API_KEY_TOKEN']
      @client = Twilio::REST::Client.new(account_sid, auth_token)
      
      begin
        rooms = @client.video.rooms.list(
          unique_name: unique_name,
          status: status,
          limit: 20
        )
        
        rooms.map { |record| record.sid }
      rescue
        return []
      end
    end
    
    def self.retrieve_rooms_by_status(status)
      account_sid = ENV['TWILIO_ACCOUNT_API_KEY_SID']
      auth_token = ENV['TWILIO_ACCOUNT_API_KEY_TOKEN']
      @client = Twilio::REST::Client.new(account_sid, auth_token)
      
      rooms = @client.video.rooms.list(status: status, limit: 20)
      rooms.each do |record|
        puts record.sid
      end
    end
    
    def self.retrieve_list_of_connected_participants(sid)
      account_sid = ENV['TWILIO_ACCOUNT_API_KEY_SID']
      auth_token = ENV['TWILIO_ACCOUNT_API_KEY_TOKEN']
      
      @client = Twilio::REST::Client.new(account_sid, auth_token)
      begin
        @client.video.rooms(sid).participants.list(status: 'connected').map { |participant| participant.sid }
      rescue
        return []
      end
    end
  end
end
