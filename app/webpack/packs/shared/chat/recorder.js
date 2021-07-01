import Recorder from 'recorderjs';

$(document).on('ajax:success', 'a[id^=chat-element-]', function() {
  URL = window.URL || window.webkitURL;
  
  var gumStream;             //stream from getUserMedia()
  var rec;                   //Recorder.js object
  var input;                 //MediaStreamAudioSourceNode we'll be recording
  
  // Shim for AudioContext when it's not avb.
  var AudioContext = window.AudioContext || window.webkitAudioContext;
  var audioContext     //audio context to help us record
  
  // Text/Audio forms
  var textMessageForm = $('#text-message-form')
  var audioRecordForm = $('#audio-record-form')
  var audioRecordPendingForm = $('#audio-record-pending-form')
  
  var recordButton = document.getElementById("chat-start-record-button");
  var stopButton = document.getElementById("chat-stop-record-button");
  var clearButton = document.getElementById("chat-clear-record-button");
  
  //add events to those 2 buttons
  recordButton.addEventListener("click", startRecording);
  stopButton.addEventListener("click", stopRecording);
  clearButton.addEventListener("click", cancelRecording);
  
  function startRecording() {
    if (textMessageForm && audioRecordForm && textMessageForm.hasClass('active')) {
      textMessageForm.removeClass('active')
      audioRecordForm.addClass('active')
      
      startTimer()
    }
    
    var constraints = { audio: true, video:false }
    navigator.mediaDevices.getUserMedia(constraints).then(function(stream) {
      //console.log("getUserMedia() success, stream created, initializing Recorder.js ...");
      
      audioContext = new AudioContext();
      // Assign to gumStream for later use
      gumStream = stream;
      
      // Use the stream
      input = audioContext.createMediaStreamSource(stream);
      
      /*
        Create the Recorder object and configure to record mono sound (1 channel)
        Recording 2 channels  will double the file size
      */
      rec = new Recorder(input,{numChannels:1})
      
      // Start the recording process
      rec.record()
      
    }).catch(function(err) {
        console.log(err);
    });
  }
  
  function cancelRecording(){
    if (rec.recording) {
      rec.stop();
      rec.clear();
    }
    
    if (textMessageForm && audioRecordForm && audioRecordForm.hasClass('active')) {
      audioRecordForm.removeClass('active')
      textMessageForm.addClass('active')
      
      stopTimer()
    }
  }
  
  function stopRecording() {
    if (audioRecordForm && audioRecordPendingForm && audioRecordForm.hasClass('active')) {
      audioRecordForm.removeClass('active')
      audioRecordPendingForm.addClass('active')
      stopTimer()
    }
    
    // Tell the recorder to stop the recording
    rec.stop();
    
    // Stop microphone access
    gumStream.getAudioTracks()[0].stop();
    
    // Create the wav blob and pass it on to createDownloadLink
    rec.exportWAV(createDownloadLink);
  }
  
  function createDownloadLink(blob) {
    // Name of .wav file to use during upload and download (without extendion)
    var filename = new Date().toISOString();
    var formData = new FormData();
    formData.append('chat_message[audio_record]', blob, filename);
    formData.append('chat_message[message_type]', 'audio')
    
    let chatAccessToken = $('#chat-board').data('chat-token')
    $.ajax({
      url: '/chats/' + chatAccessToken + '/chat_messages',
      data: formData,
      cache: false,
      contentType: false,
      processData: false,
      type: 'POST',
      dataType: 'jsonp',
      success: function() {
        if (textMessageForm && audioRecordPendingForm && audioRecordPendingForm.hasClass('active')) {
          audioRecordPendingForm.removeClass('active')
          textMessageForm.addClass('active')
        }
      }
    })
  }
  
  // Timer
  function startTimer() {
    const minutes = document.querySelector("#minutes")
    const seconds = document.querySelector("#seconds")
    let count = 0;
  
    const renderTimer = () => {
      count += 1;
      minutes.innerHTML = Math.floor(count / 60).toString().padStart(2, "0");
      seconds.innerHTML = (count % 60).toString().padStart(2, "0");
    }
  
    window.timer = setInterval(renderTimer, 1000)
  }
  
  function stopTimer() {
    let minutesLabel = document.getElementById("minutes");
    let secondsLabel = document.getElementById("seconds");
    clearInterval(window.timer);
    secondsLabel.innerHTML = '00';
    minutesLabel.innerHTML = '00';
  }
})
