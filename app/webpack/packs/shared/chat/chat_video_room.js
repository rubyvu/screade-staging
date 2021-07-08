const { connect, createLocalVideoTrack } = require('twilio-video');

export default class ChatVideoRoom {
  constructor() {
    this.chatAccessToken = ''
    this.name = ''
    this.room = null
    this.location_callback = window.origin + '/chats'
    this.init()
  }
  
  init() {
    this.chatAccessToken = $('#chat-video-room').data('twilio-video-token')
    this.name = $('#chat-video-room').data('room-name')
  }
  
  connectToTheRoom() {
    connect(this.chatAccessToken, { name: this.name }).then(room => {
      this.room = room
      this.room.participants.forEach(participant => {
        console.log(`!!! Participant "${participant.identity}" is connected to the Room`);
        participant.on('trackSubscribed', track => {
          console.log('track:', track);
          document.getElementById('video-chat-remote-media').appendChild(track.attach());
        });
      });
      
      // Cache Participant connection to the room
      this.room.on('participantConnected', participant => {
        console.log(`A remote Participant connected: ${participant}`);
      });
      
      
      // Participant video
      // Attach the Participant's Media to a <div> element.
      this.room.on('participantConnected', participant => {
        console.log(`Participant "${participant.identity}" connected`);
        
        console.log('participant is', participant);
        participant.on('trackSubscribed', track => {
          console.log('track:', track);
          document.getElementById('video-chat-remote-media').appendChild(track.attach());
        });
      });
    }, error => {
      console.error(`Unable to connect to Room: ${error.message}`);
    });
  }
  
  disconectFromTheRoom() {
    console.log(this.room);
    
    // To disconnect from a Room
    this.room.disconnect();
    console.log(this.room);
    
    this.updateRoomStateForServer()
    // Go to the chat
    window.location.href = this.location_callback + '?chat_access_token=' + this.name.split('-')[1]
  }
  
  // Send update request to server to complete Room without participants
  updateRoomStateForServer() {
    $.ajax({
      url: window.origin + '/chats/' + this.name.split('-')[1] + '/chat_video_rooms/complete',
      type: 'PUT',
      data: { chat_video_room_name: this.name },
      success: function(result) {
        console.log(result);
      }
    });
  }
  
  showLocalMedia() {
    createLocalVideoTrack().then(track => {
      const localMediaContainer = document.getElementById('video-chat-local-media');
      localMediaContainer.appendChild(track.attach());
    });
  }
}
