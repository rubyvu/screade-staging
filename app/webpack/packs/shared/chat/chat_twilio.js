import ChatAudioRoom from './chat_audio_room'
import ChatVideoRoom from './chat_video_room'

$( document ).on('turbolinks:load', function() {
  // Init ChatVideoRoom
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
  
  // Init ChatAudioRoom
  if ($('#chat-audio-room').length > 0 ) {
    var chatAudioRoom = new ChatAudioRoom();
    if (chatAudioRoom.name.length === 0) { return }
    chatAudioRoom.connectToTheRoom()
    
    $('#disconect-from-audio-chat').on('click', function() {
      console.log('--> disconect');
      chatAudioRoom.disconectFromTheRoom()
    })
    
    $('#mute-audio').on('click', function() {
      console.log('-- mute audio');
      chatAudioRoom.audioMuteControl()
    })
    
    // Get History back event
    if (window.history && window.history.pushState) {
      $(window).on('popstate', function() {
        console.log('--> disconect');
        chatAudioRoom.disconectFromTheRoom()
      });
    }
  }
})
