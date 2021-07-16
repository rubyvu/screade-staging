const { connect, createLocalVideoTrack } = require('twilio-video');

export default class ChatVideoRoom {
  constructor() {
    this.chatAccessToken = ''
    this.name = ''
    this.room = null
    this.location_callback = window.origin + '/chats'
    this.isAudioMute = false
    this.isVideoMute = false
    this.init()
  }
  
  init() {
    this.chatAccessToken = $('#chat-video-room').data('twilio-video-token')
    this.name = $('#chat-video-room').data('room-name')
    
    if (this.chatAccessToken.length === 0 ) {
      alert('Current Chat cannot be reached at this moment, please try again later.')
      window.location.href = this.location_callback + '?chat_access_token=' + this.name.split('-')[1]
    }
  }
  
  connectToTheRoom() {
    connect(this.chatAccessToken, { name: this.name }).then(room => {
      this.room = room
      
      // Update participant counter (+1 is localParticipant)
      this.setChatParticipantsCounter(this.room.participants.size+1)
      
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
        
        // Update participant counter
        let participantsCount = this.room.participants.size
        if (this.room.localParticipant.sid && this.room.localParticipant.sid.length > 0) { participantsCount += 1 }
        this.setChatParticipantsCounter(participantsCount)
      });
    }, error => {
      console.error(`Unable to connect to Room: ${error.message}`);
    });
  }
  
  disconectFromTheRoom() {
    if (this.room) {
      // To disconnect from the Room
      this.room.disconnect();
    }
    
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
  
  // Send request to update participants counter
  setChatParticipantsCounter(participantsCount) {
    $.ajax({
      url: window.origin + '/chats/' + this.name.split('-')[1] + '/chat_video_rooms/update_participants_counter',
      type: 'PUT',
      data: { chat_video_room_name: this.name, participants_count: participantsCount },
      success: function(result) {
        console.log(result);
      }
    });
  }
  
  addParticipantVideoDiv(participant) {
    const localMediaContainer = document.getElementById('video-chat-content');
    const participantVideoDiv = document.createElement('div');
    participantVideoDiv.classList.add('video-chat-sceen')
    participantVideoDiv.id = participant.sid;
    localMediaContainer.append(participantVideoDiv)
    
    participant.on('trackSubscribed', (track, participantVideoDiv) => {
      console.log('track:', track);
      document.getElementById(participant.sid).appendChild(track.attach());
    });
  }
  
  showLocalMedia() {
    createLocalVideoTrack().then(track => {
      const localMediaContainer = document.getElementById('video-chat-content');
      
      const participantVideoDiv = document.createElement('div');
      participantVideoDiv.classList.add('video-chat-sceen')
      localMediaContainer.appendChild(participantVideoDiv);
      participantVideoDiv.appendChild(track.attach());
    });
  }
  
  audioMuteControl() {
    this.room.localParticipant.audioTracks.forEach(publication => {
      if (this.isAudioMute) {
        publication.track.enable();
      } else {
        publication.track.disable();
      }
      
      this.isAudioMute = !this.isAudioMute
    });
  }
  
  videoMuteControl() {
    this.room.localParticipant.videoTracks.forEach(publication => {
      if (this.isVideoMute) {
        publication.track.enable();
      } else {
        publication.track.disable();
      }
      
      this.isVideoMute = !this.isVideoMute
    });
  }
}
