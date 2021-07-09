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
        
        this.addParticipantVideoDiv(participant)
      });
      
      // On participant connect create new participantVideoDiv
      this.room.on('participantConnected', participant => {
        console.log(`Participant "${participant.identity}" connected`);
        
        this.addParticipantVideoDiv(participant)
      });
      
      // On participant disconnect remove participantVideoDiv
      this.room.on('participantDisconnected', participant => {
        console.log(`Participant disconnected: ${participant.identity}`);
        console.log(participant);
        document.getElementById(participant.sid).remove()
      });
    }, error => {
      console.error(`Unable to connect to Room: ${error.message}`);
    });
  }
  
  disconectFromTheRoom() {
    // To disconnect from the Room
    this.room.disconnect();
    
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
  
  addParticipantVideoDiv(participant) {
    const participantVideoDiv = document.createElement('div');
    participantVideoDiv.id = participant.sid;
    document.getElementById('video-chat-remote-media').append(participantVideoDiv)
    
    participant.on('trackSubscribed', (track, participantVideoDiv) => {
      console.log('track:', track);
      document.getElementById(participant.sid).appendChild(track.attach());
    });
  }
  
  showLocalMedia() {
    createLocalVideoTrack().then(track => {
      const localMediaContainer = document.getElementById('video-chat-local-media');
      localMediaContainer.appendChild(track.attach());
    });
  }
}
