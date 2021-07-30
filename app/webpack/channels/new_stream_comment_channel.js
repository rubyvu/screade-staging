import consumer from "./consumer"

$( document ).on('turbolinks:load', function() {
  let pageRegexp = new RegExp('\/streams\/[0-9]+');
  if (!window.location.pathname.match(pageRegexp)) { return }

  if (!App.newStreamCommentChannel || App.newStreamCommentChannel.consumer.connection.disconnected) {
    let streamId = window.location.pathname.split('/')[2]
    App.newStreamCommentChannel = consumer.subscriptions.create({
      channel: "NewStreamCommentChannel",
      stream_id: streamId
      }, {
      connected() {
        // Called when the subscription is ready for use on the server
      },
      
      disconnected() {
        // Called when the subscription has been terminated by the server
      },
      
      received(data) {
        $('.comments-scroll .comment-wrapper:first').before(data.stream_comment_html)
      }
    })
  }
});
