import ChatVideoRoom from './chat_video_room'

$( document ).on('turbolinks:load', function() {
  if ($('#chat-video-room').length > 0 ) {
    var chatVideoRoom = new ChatVideoRoom();
    if (chatVideoRoom.name.length === 0) { return }
    chatVideoRoom.connectToTheRoom()
    chatVideoRoom.showLocalMedia()
    
    $('#disconect-from-video-chat').on('click', function() {
      console.log('--> disconect');
      chatVideoRoom.disconectFromTheRoom()
    })
    
    $('#mute-audio').on('click', function() {
      console.log('-- mute audio');
      chatVideoRoom.audioMuteControl()
    })
    
    $('#mute-video').on('click', function() {
      console.log('-- mute video');
      chatVideoRoom.videoMuteControl()
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
