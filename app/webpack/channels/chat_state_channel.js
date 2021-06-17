import consumer from "./consumer"
import { chat_date } from "./helpers/date_helper"

$( document ).on('turbolinks:load', function() {
  if (window.location.pathname !== "/chats") { return }
  
  consumer.subscriptions.create("ChatStateChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
    },
    
    disconnected() {
      // Called when the subscription has been terminated by the server
    },
    
    received(data) {
      // Called when there's incoming data on the websocket for this channel
      
      // Get Chat element to update
      let chatElement = $(`#chat-element-${data.chat_json.access_token}`)
      chatElement.replaceWith(data.chat_html)
      
      // Set ChatDate to desired format
      let chatUpdatedAt = chat_date(data.chat_json.last_message.created_at)
      $(`#chat-element-${data.chat_json.access_token} .date`).html(chatUpdatedAt)
    }
  });
})
