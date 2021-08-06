import consumer from "./consumer"
import { chat_time, chat_board_date } from "./helpers/date_helper"

// Remove ChatChannel subscription after leave the chat (Notification logic for Chat messages)
$( document ).on('turbolinks:load', function() {
  if (consumer.subscriptions.subscriptions.includes(App.chatMessagesChanel) && $('#chat-board').length === 0) {
    consumer.subscriptions.remove(App.chatMessagesChanel)
  };
})

// Update User ChatChannel subscription when chat is rendered
$(document).on('ajax:success', 'a[id^=chat-element-]', function() {
  let chatAccessToken = this.id.split('chat-element-')[1]
  if (chatAccessToken) {
    
    // Clear all User ChatChannel subscriptions before new subscription
    for ( var i = 0, l = consumer.subscriptions.subscriptions.length; i < l; i++ ) {
      let consumerSubscription = consumer.subscriptions.subscriptions[i]
      if ( consumerSubscription && JSON.parse(consumerSubscription.identifier).channel === 'ChatChannel' ) {
        consumer.subscriptions.remove(consumerSubscription)
      }
    }
    
    // Create new ChatChannel subscription
    App.chatMessagesChanel = consumer.subscriptions.create({
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
        
        // Style Message Owner message
        chatMessagesPlaceholder.append($.parseHTML(data.chat_message_html))
        if ( chatBoardPlaceholder.find('[data-chat-username]').data('chat-username') === username ) {
          chatMessagesPlaceholder.find(`[data-message-id=${messageId}]`).addClass('message-owner')
        }
        
        // Style Audio/Video call message
        if ( chatMessagesPlaceholder.find(`[data-message-id=${messageId}]`).length > 0 && chatMessagesPlaceholder.find(`[data-message-id=${messageId}]`).find('.video-room').length > 0 ) {
          chatMessagesPlaceholder.find(`[data-message-id=${messageId}]`).addClass('message-owner')
        }
        
        // Set ChatMessage time to desired format
        let messageCreatedAt = chat_time(data.chat_message_json.unix_created_at)
        $(`#chat-message-placeholder [data-message-id=${messageId}] .date`).html(messageCreatedAt)
        
        // Set Messages time separator
        let penultMessage = $('.message-box-wrapper:last').prev()
        let lastMessage = $('.message-box-wrapper:last')
        if (penultMessage.length > 0 && lastMessage.length > 0) {
          let penultMessageDate = chat_board_date(penultMessage.data('message-datetime'));
          let lastMessageDate = chat_board_date(lastMessage.data('message-datetime'));
        
          if (penultMessageDate !== lastMessageDate) {
            $('<div class="message-date-box"><span>' + lastMessageDate + '<spna><div>').insertAfter(penultMessage)
          }
        }
        
        // Scroll down for the last message if Client in the bottom position
        let chatMessagePlaceholder = document.getElementById('chat-message-placeholder');
        if (chatMessagePlaceholder && chatMessagePlaceholder.scrollTop >= chatMessagePlaceholder.scrollHeight - 2000) {
          chatMessagePlaceholder.scrollTop = chatMessagePlaceholder.scrollHeight;
        }
      }
    });
  }
});
