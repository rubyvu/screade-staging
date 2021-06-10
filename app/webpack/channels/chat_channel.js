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
        $('#chat-message-placeholder').append($.parseHTML(data.chat_message))
        // Called when there's incoming data on the websocket for this channel
      }
    });
  }
});
