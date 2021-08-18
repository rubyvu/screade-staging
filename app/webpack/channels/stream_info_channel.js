import consumer from "./consumer"

$( document ).on('turbolinks:load', function() {
  let pageRegexp = new RegExp('\/streams\/[a-zA-Z0-9]+');
  if (!window.location.pathname.match(pageRegexp)) { return }
  
  if (!App.StreamInfoChannel || App.StreamInfoChannel.consumer.connection.disconnected) {
    let streamAccessToken = window.location.pathname.split('/')[2]
    App.StreamInfoChannel = consumer.subscriptions.create({
      channel: "StreamInfoChannel",
      stream_access_token: streamAccessToken
      }, {
      connected() {
        // Called when the subscription is ready for use on the server
      },
      
      disconnected() {
        // Called when the subscription has been terminated by the server
      },
      
      received(data) {
        let litsCount = data.stream_info_json.formated_lits_count
        let viewsCount = data.stream_info_json.formated_views_count
        let streamCommentsCount = data.stream_info_json.formated_stream_comments_count
        
        changeInfoCounter('stream-lits-counter', litsCount)
        changeInfoCounter('stream-views-counter', viewsCount)
        changeInfoCounter('stream-comments-counter', streamCommentsCount)
        
        function changeInfoCounter(id, value) {
          $(`#${id}`).text(value)
        }

      }
    })
  }
});
