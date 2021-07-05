//
$( document ).on('turbolinks:load', function() {
  $('#chat-board-placeholder').on('click', '#twilio-video-call', function(){
    console.log('Clicked on video call');
    
    
  })
})
console.log('===========');
const { connect } = require('twilio-video');

console.log('connect:', connect);
// connect('$TOKEN', { name:'my-new-room' }).then(room => {
//   console.log(`Successfully joined a Room: ${room}`);
//   room.on('participantConnected', participant => {
//     console.log(`A remote Participant connected: ${participant}`);
//   });
// }, error => {
//   console.error(`Unable to connect to Room: ${error.message}`);
// });
