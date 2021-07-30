$( document ).on('turbolinks:load', function() {
  
  // Load Modal with Images And Videos
  $('#chat-board-placeholder').on('click', '#chat-assset-button', function() {
    let chatAccessToken = $('#chat-board').data('chat-token')
    $.ajax({
      url: window.location.origin + '/chats/' + chatAccessToken + '/chat_messages/images',
      type: 'GET',
      dataType: 'jsonp'
    });
    
    $.ajax({
      url: window.location.origin + '/chats/' + chatAccessToken + '/chat_messages/videos',
      type: 'GET',
      dataType: 'jsonp'
    });
    
    setTimeout(function() {
      $('#modal-chat-assets').modal('show')
      $('#tabs').tabs()
    }, 800)
  })
})

$(document).on('ajax:success', 'a[id^=chat-element-]', function() {
  // Message/Audio switcher
  let submitButton = $('#chat-message-submit')
  let recordButton = $('#chat-start-record-button')
  let messageInput = $('#chat_message_text')
  
  messageInput.on('input', function() {
    if ($(this).val().length > 0) {
      submitButton.addClass('active')
      recordButton.removeClass('active')
    } else {
      submitButton.removeClass('active')
      recordButton.addClass('active')
    }
  });
  
  // Clear message input field after submit
  $('#new_chat_message').on('ajax:success', function() {
    messageInput.val('')
    submitButton.removeClass('active')
    recordButton.addClass('active')
  })
})
