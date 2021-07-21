const { connect } = require('twilio-video');

export default class ChatAudioRoom {
  constructor() {
    this.chatAccessToken = ''
    this.name = ''
    this.room = null
    this.location_callback = window.origin + '/chats'
    this.isAudioMute = false
    this.init()
  }
  
  init() {
    this.chatAccessToken = $('#chat-audio-room').data('twilio-video-token')
    this.name = $('#chat-audio-room').data('room-name')
    
    if (this.chatAccessToken.length === 0 ) {
      alert('Current Chat cannot be reached at this moment, please try again later.')
      window.location.href = this.location_callback + '?chat_access_token=' + this.name.split('-')[1]
    }
  }
  
  // Send request to get room members
  updateRoomMembersView() {
    let chatAccessToken = $('#chat-audio-room').data('chat-token')
    return $.ajax({
      url: window.origin + '/chats/' + chatAccessToken + '/chat_memberships/audio_room',
      type: 'GET',
      success: function(data) {
        data.audio_room_members.forEach((user) => {
          let userProfile = $('img.profile-image').closest(`[data-username='${user.username}']`)
          if (userProfile.length > 0) {
            // Set image
            if (user.profile_picture && user.profile_picture.length > 0) {
              userProfile.attr("src", user.profile_picture );
            }
            
            // Set full name
            let fullName = user.username
            if (user.first_name.length > 0 && user.last_name.length > 0) {
              fullName = user.first_name + ' ' + user.last_name
            }
            userProfile.data("full-name", fullName)
          }
        });
      }
    });
  }
  
  connectToTheRoom() {
    connect(this.chatAccessToken, { name: this.name, dominantSpeaker: true, audio: true, video: false }).then(room => {
      this.room = room
      console.log(this.room);
      
      // Update participant counter (+1 is localParticipant)
      this.setChatParticipantsCounter(this.room.participants.size+1)
      
      this.room.participants.forEach(participant => {
        console.log(`!!! Participant "${participant.identity}" is connected to the Room`);
        
        this.addParticipantIconDiv(participant)
      });
      
      // On participant connect create new participantVideoDiv
      this.room.on('participantConnected', participant => {
        console.log(`Participant "${participant.identity}" connected`);
        
        this.addParticipantIconDiv(participant)
        this.updateRoomMembersView()
      });
      
      // On participant disconnect remove participantVideoDiv
      this.room.on('participantDisconnected', participant => {
        console.log(`Participant disconnected: ${participant.identity}`);
        console.log(participant);
        
        // Remove icons
        document.getElementById(participant.sid).remove()
        $('#audio-remote-participant').css('display', 'none')
        
        // Update participant counter
        let participantsCount = this.room.participants.size
        if (this.room.localParticipant.sid && this.room.localParticipant.sid.length > 0) { participantsCount += 1 }
        this.setChatParticipantsCounter(participantsCount)
      });
      
      // Dominant speaker event);
      this.room.on('dominantSpeakerChanged', participant => {
        console.log('DS: ', participant);
        console.log('The new dominant speaker in the Room is:', participant);
        // If speaker change clear all styles
        $('.profile-image').removeClass('dominant-speaker')
        let remoteParticipantDiv = $('#audio-remote-participant')
        remoteParticipantDiv.removeClass('dominant-speaker')
        
        if (participant) {
          // Bottom menu
          let dominatnAudioIcon = $(`.profile-image#${participant.sid}`)
          dominatnAudioIcon.addClass('dominant-speaker')
          dominatnAudioIcon.prependTo("#audio-participants-list")
          
          // Main content
          remoteParticipantDiv.css('display', 'flex')
          remoteParticipantDiv.addClass('dominant-speaker')
          remoteParticipantDiv.children('img').attr('src', dominatnAudioIcon.attr('src'))
          remoteParticipantDiv.children('span').text(dominatnAudioIcon.data('full-name'))
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
      url: window.origin + '/chats/' + this.name.split('-')[1] + '/chat_audio_rooms/complete',
      type: 'PUT',
      data: { chat_audio_room_name: this.name },
      success: function(result) {
        console.log(result);
      }
    });
  }
  
  // Send request to update participants counter
  setChatParticipantsCounter(participantsCount) {
    $.ajax({
      url: window.origin + '/chats/' + this.name.split('-')[1] + '/chat_audio_rooms/update_participants_counter',
      type: 'PUT',
      data: { chat_audio_room_name: this.name, participants_count: participantsCount },
      success: function(result) {
        console.log(result);
      }
    });
  }
  
  addParticipantIconDiv(participant) {
    // List of all video chats
    const audioListContainer = document.getElementById('audio-participants-list');
    
    // Current participant audio
    const participantImage = document.createElement('img');
    participantImage.classList.add('profile-image')
    participantImage.id = participant.sid;
    participantImage.src = $('#chat-audio-room').data('default-user-image')
    participantImage.setAttribute("data-username", participant.identity)
    participantImage.setAttribute("data-full-name", '')
    
    // Add Video to DOM
    audioListContainer.append(participantImage)
    
    participant.on('trackSubscribed', (track, participantImage) => {
      track.attach()
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
}
