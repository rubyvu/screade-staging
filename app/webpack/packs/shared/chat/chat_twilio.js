import ChatVideoRoom from './chat_video_room'

$( document ).on('turbolinks:load', function() {
  console.log('===========');
  
  let chatAccessToken = '66761374c4206fbdfbab4038d836d4a9'
  
  var chatVideoRoom = new ChatVideoRoom(chatAccessToken);
  
  console.log('class ->', chatVideoRoom);
  
  if ($('#chat-video-room').length > 0 ) {
    
    // console.log('connect:', connect);
    // connect('$TOKEN', { name:'my-new-room' }).then(room => {
    //   console.log(`Successfully joined a Room: ${room}`);
    //   room.on('participantConnected', participant => {
    //     console.log(`A remote Participant connected: ${participant}`);
    //   });
    // }, error => {
    //   console.error(`Unable to connect to Room: ${error.message}`);
    // });
  }
  
  // Join to Room
  $('#connect-to-video-chat').on('click', function() {
    // let chatAccessToken = '8187e5938b42819eff4de18cdddebdfc'
    let chatAccessToken = '66761374c4206fbdfbab4038d836d4a9'
    $.ajax({
      type: "GET",
      url: window.location.origin + '/chats/' + chatAccessToken + '/chat_video_rooms/participant_token'
    }).done(function(data){
      console.log('----------', data);
      let userToken = data.user_token
      let roomName = data.room_name
      
      const { connect } = require('twilio-video');
      
      connect(userToken, { name:roomName }).then(room => {
        
        room.participants.forEach(participant => {
          console.log(`!!! Participant "${participant.identity}" is connected to the Room`);
          participant.on('trackSubscribed', track => {
            console.log('track:', track);
            document.getElementById('video-chat-remote-media').appendChild(track.attach());
          });
        });
        
        room.on('participantConnected', participant => {
          console.log(`A remote Participant connected: ${participant}`);
        });
        
        
        // Participant video
        // Attach the Participant's Media to a <div> element.
        
        room.on('participantConnected', participant => {
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
      
      // Local video preview
      const { createLocalVideoTrack } = require('twilio-video');
      
      createLocalVideoTrack().then(track => {
        const localMediaContainer = document.getElementById('video-chat-local-media');
        localMediaContainer.appendChild(track.attach());
      });
      
    })
  })
})
