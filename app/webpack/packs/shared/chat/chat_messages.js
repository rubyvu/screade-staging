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
