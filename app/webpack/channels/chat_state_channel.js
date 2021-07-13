import consumer from "./consumer"
import { chat_date } from "./helpers/date_helper"

$( document ).on('turbolinks:load', function() {
  if (window.location.pathname !== "/chats") { return }
  if (!App.chatStateChannel || App.chatStateChannel.consumer.connection.disconnected) {
    App.chatStateChannel = consumer.subscriptions.create("ChatStateChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
      },
      
      disconnected() {
        // Called when the subscription has been terminated by the server
      },
      
      received(data) {
        // Called when there's incoming data on the websocket for this channel
        let chatAccessToken = data.chat_json.access_token
        let currentChatBoard = $('#chat-board')
        let chatBoardPlaceholder = $('#chat-board-placeholder')
        let unreadMessagesWas = $(`#chat-element-${chatAccessToken} .unread-messages-count span`).text()
        
        // Get Chat element to update
        let chatElement = $(`#chat-element-${chatAccessToken}`)
        if ( chatElement.length === 0 ) { return }
        
        chatElement.replaceWith(data.chat_html)
        
        // Set ChatDate to desired format
        let chatUpdatedAt = chat_date(data.chat_json.last_message.created_at)
        $(`#chat-element-${chatAccessToken} .date`).html(chatUpdatedAt)
        
        // Add Messages unviewed counter if User out of Chat
        data.chat_json.chat_memberships.forEach(chatMembership => {
          if ( chatBoardPlaceholder.find('[data-chat-username]').data('chat-username') === chatMembership.user.username ) {
            // // Update UnreadMessages value in DB
            $.ajax({
              url: window.location.origin + '/chats/' + chatAccessToken + '/chat_memberships/unread_messages',
              type: 'PUT',
              dataType: 'json'
            }).done(function(data) {
              if (data.success) {
                $(`#chat-element-${chatAccessToken} .body .message .unread-messages-count`).addClass('no-messages')
              }
            });
          } else {
            if (currentChatBoard && currentChatBoard.data('chat-token') !== chatAccessToken) {
              // Update UnreadMessages view
              let unreadMessagesCounter = parseInt(unreadMessagesWas || 0)+1
              $(`#chat-element-${chatAccessToken} .unread-messages-count span`).text(unreadMessagesCounter)
            } else if (currentChatBoard && currentChatBoard.data('chat-token') === chatAccessToken) {
              $(`#chat-element-${chatAccessToken} .body .message .unread-messages-count`).addClass('no-messages')
            }
          }
        })
      }
    })
  }
});
