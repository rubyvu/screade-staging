import consumer from "./consumer"
import { chat_date, chat_time } from "./helpers/date_helper"

$( document ).on('turbolinks:load', function() {
  let pageRegexp = new RegExp('\/streams\/[a-zA-Z0-9]+');
  if (!window.location.pathname.match(pageRegexp)) { return }
  
  if (!App.newStreamCommentChannel || App.newStreamCommentChannel.consumer.connection.disconnected) {
    let streamAccessToken = window.location.pathname.split('/')[2]
    App.newStreamCommentChannel = consumer.subscriptions.create({
      channel: "NewStreamCommentChannel",
      stream_access_token: streamAccessToken
      }, {
      connected() {
        // Called when the subscription is ready for use on the server
      },
      
      disconnected() {
        // Called when the subscription has been terminated by the server
      },
      
      received(data) {
        // Render StreamComment html
        $('.comments-scroll .comment-wrapper:first').before(data.stream_comment_html)
        let commentDate = chat_date(data.stream_comment_json.created_at)
        let commentTime = chat_time(data.stream_comment_json.unix_created_at)
        
        // Change Date to propriate format
        $('.comment-content-wrapper[value="' + data.stream_comment_json.id + '"] .comment-date').html(commentDate + '-' + commentTime)
      }
    })
  }
});
