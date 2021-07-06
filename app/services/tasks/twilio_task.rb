module Tasks
  class TwilioTask
    
    def self.generate_access_token_for_user(username)
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
      grant.room = 'Test Chat'
      token.add_grant(grant)

      # Generate the token
      token.to_jwt
    end
    
    def self.create_new_room(unique_name)
      # Find your Account SID and Auth Token at twilio.com/console
      # and set the environment variables. See http://twil.io/secure
      account_sid = ENV['TWILIO_ACCOUNT_API_KEY_SID']
      auth_token = ENV['TWILIO_ACCOUNT_API_KEY_TOKEN']
      @client = Twilio::REST::Client.new(account_sid, auth_token)
      
      begin
        room = @client.video.rooms.create(
           record_participants_on_connect: true,
           status_callback: 'http://example.org',
           type: 'group',
           unique_name: unique_name
         )
         
        room.sid
      rescue
        nil
      end
    end
    
    def self.complete_room(room_sid)
      # Find your Account SID and Auth Token at twilio.com/console
      # and set the environment variables. See http://twil.io/secure
      account_sid = ENV['TWILIO_ACCOUNT_API_KEY_SID']
      auth_token = ENV['TWILIO_ACCOUNT_API_KEY_TOKEN']
      @client = Twilio::REST::Client.new(account_sid, auth_token)
      
      room = @client.video.rooms(room_sid).update(status: 'completed')
                          
      puts room.unique_name
    end
  end
end
