import consumer from "./consumer"

// Update User ChatChannel subscription when chat is rendered
$(document).on('ajax:success', 'a[id^=chat-element-]', function() {
  let chatAccessToken = this.id.split('chat-element-')[1]
  if (chatAccessToken) {
    
    // Clear all User ChatChannel subscriptions before new subscription
    for ( var i = 0, l = consumer.subscriptions.subscriptions.length; i < l; i++ ) {
      let consumerSubscription = consumer.subscriptions.subscriptions[i]
      if ( JSON.parse(consumerSubscription.identifier).channel === 'ChatChannel' ) {
        consumer.subscriptions.remove(consumerSubscription)
      }
    }
    
    // Create new ChatChannel subscription
    let currentSubscription = consumer.subscriptions.create({
      channel: "ChatChannel",
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
        let username = data.chat_message_json.user.username
        let messageId = data.chat_message_json.id
        let chatMessagesPlaceholder = $('#chat-message-placeholder')
        let chatBoardPlaceholder = $('#chat-board-placeholder')
        
        chatMessagesPlaceholder.append($.parseHTML(data.chat_message_html))
        if ( chatBoardPlaceholder.find('[data-chat-username]').data('chat-username') === username ) {
          chatMessagesPlaceholder.find(`[data-message-id=${messageId}]`).addClass('message-owner')
        }
      }
    });
  }
});
