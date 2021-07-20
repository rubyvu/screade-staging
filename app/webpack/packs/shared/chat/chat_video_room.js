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
  
  // Send request to get room members
  updateRoomMembersView() {
    let chatAccessToken = $('#chat-video-room').data('chat-token')
    return $.ajax({
      url: window.origin + '/chats/' + chatAccessToken + '/chat_memberships/video_room',
      type: 'GET',
      success: function(data) {
        data.video_room_members.forEach((user) => {
          let currentUser = $(`.name span#${user.username}`)
          if (currentUser.length > 0 ) {
            let fullName = user.username
            if (user.first_name.length > 0 && user.last_name.length > 0) {
              fullName = user.first_name + ' ' + user.last_name
            }
            
            currentUser.text(fullName)
          }
        });
      }
    });
  }
  
  connectToTheRoom() {
    connect(this.chatAccessToken, { name: this.name, dominantSpeaker: true }).then(room => {
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
        this.updateRoomMembersView()
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
      
      // Dominant speaker event);
      this.room.on('dominantSpeakerChanged', participant => {
        console.log('DS: ', participant);
        console.log('The new dominant speaker in the Room is:', participant);
        if (participant) {
          let dominatnVideoScreen = $(`#${participant.sid}`)
          dominatnVideoScreen.addClass('dominant-speaker')
          dominatnVideoScreen.insertAfter(".video-chat-sceen#local-participant")
        } else {
          $('.video-chat-sceen').removeClass('dominant-speaker')
        }
      });
      
      this.updateRoomMembersView()
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
        // console.log(result);
      }
    });
  }
  
  addParticipantVideoDiv(participant) {
    // List of all video chats
    const localMediaContainer = document.getElementById('video-chat-content');
    
    // Current participant video
    const participantVideoDiv = document.createElement('div');
    participantVideoDiv.classList.add('video-chat-sceen')
    participantVideoDiv.id = participant.sid;
    
    // Current participant name
    const participantNameDiv = document.createElement('div');
    participantNameDiv.classList.add('name')
    participantNameDiv.innerHTML = '<span id="' + participant.identity + '">' + participant.identity + '</span>';
    participantVideoDiv.append(participantNameDiv)
    
    // Add Video to DOM
    localMediaContainer.append(participantVideoDiv)
    
    participant.on('trackSubscribed', (track, participantVideoDiv) => {
      document.getElementById(participant.sid).appendChild(track.attach());
    });
  }
  
  showLocalMedia() {
    createLocalVideoTrack().then(track => {
      const localMediaContainer = document.getElementById('video-chat-content');
      
      const participantVideoDiv = document.createElement('div');
      participantVideoDiv.classList.add('video-chat-sceen')
      participantVideoDiv.id = 'local-participant'
      
      // Current participant name
      const participantNameDiv = document.createElement('div');
      participantNameDiv.innerHTML = '<span>' + 'You' + '</span>';
      participantNameDiv.classList.add('name')
      participantVideoDiv.append(participantNameDiv)
      
      localMediaContainer.appendChild(participantVideoDiv);
      participantVideoDiv.appendChild(track.attach());
    });
  }
  
  audioMuteControl() {
    this.room.localParticipant.audioTracks.forEach(publication => {
      let microphoneButton = $('.call-control-panel .button#mute-audio')
      if (microphoneButton.length === 0) { return }
      
      if (this.isAudioMute) {
        publication.track.enable();
        microphoneButton.removeClass('inactive')
        microphoneButton.find('i').removeClass('off').addClass('on')
      } else {
        publication.track.disable();
        microphoneButton.addClass('inactive')
        microphoneButton.find('i').removeClass('on').addClass('off')
      }
      
      this.isAudioMute = !this.isAudioMute
    });
  }
  
  videoMuteControl() {
    let cameraButton = $('.call-control-panel .button#mute-video')
    if (cameraButton.length === 0) { return }
    
    this.room.localParticipant.videoTracks.forEach(publication => {
      if (this.isVideoMute) {
        publication.track.enable();
        cameraButton.removeClass('inactive')
        cameraButton.find('i').removeClass('off').addClass('on')
      } else {
        publication.track.disable();
        cameraButton.addClass('inactive')
        cameraButton.find('i').removeClass('on').addClass('off')
      }
      
      this.isVideoMute = !this.isVideoMute
    });
  }
}
