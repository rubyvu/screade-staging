import ChatVideoRoom from './chat_video_room'

$( document ).on('turbolinks:load', function() {
  if ($('#chat-video-room').length > 0 ) {
    var chatVideoRoom = new ChatVideoRoom();
    chatVideoRoom.connectToTheRoom()
    chatVideoRoom.showLocalMedia()
    
    $('#disconect-from-video-chat').on('click', function(){
      console.log('--> disconect');
      chatVideoRoom.disconectFromTheRoom()
    })
    
    // Get History back event
    if ( window.history && window.history.pushState) {
      $(window).on('popstate', function() {
        console.log('--> disconect');
        chatVideoRoom.disconectFromTheRoom()
      });
    }
  }
})
