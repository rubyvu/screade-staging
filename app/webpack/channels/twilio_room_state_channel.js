import consumer from "./consumer"

$(document).on('ajax:success', 'a[id^=chat-element-]', function() {
  let chatAccessToken = this.id.split('chat-element-')[1]
  
  if (!App.twilioRoomStateChannel || App.twilioRoomStateChannel.consumer.connection.disconnected) {
    App.twilioRoomStateChannel = consumer.subscriptions.create({
      channel: "TwilioRoomStateChannel",
      chat_access_token: chatAccessToken
      }, {
      connected() {
        // Called when the subscription is ready for use on the server
      },
      
      disconnected() {
        // Called when the subscription has been terminated by the server
      },
      
      received(data) {
        // Called when there's incoming data on the websocket for this channel
        let videoMessageId = data.chat_message_json.id
        
        let chatMessage = $(`[data-message-id='${videoMessageId}']`)
        if (!chatMessage) { return }
        
        chatMessage.replaceWith(data.chat_message_html)
      }
    })
  }
});
