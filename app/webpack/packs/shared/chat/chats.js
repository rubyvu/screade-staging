$( document ).on('turbolinks:load', function() {
  // Create new Chat
  // Fill chat_membership[usernames][] hiden field with Users usernames on Submit button
  // On Chat create
  $('#modal-new-chat').on('submit', 'form#new_chat', function(e) {
    // Stop form execution
    e.preventDefault();
    
    let checkedMembers = $("[id^=checkbox-member-]:checked")
    if (checkedMembers.length > 0) {
      $("#chat_membership_usernames_").remove()
      checkedMembers.each(function() {
        let username = $(this).attr("data-username")
        $(e.target).append(`<input type="hidden" name="chat_membership[usernames][]" id="chat_membership_usernames_" value=${username}>`)
      })
    }
    
    // Resume defaul form execution
    e.currentTarget.submit();
  })
  
  // On NewsArticle share
  $('#modal-share-to-members').on('submit', 'form#share_record', function(event) {
    // Stop form execution
    event.preventDefault()
    
    let checkedMembers = $("[id^=checkbox-member-]:checked")
    if (checkedMembers.length > 0) {
      $("#shared_record_user_ids_").remove()
      
      checkedMembers.each(function() {
        let userID = $(this).attr('data-id')
        $(event.target).append(`<input type='hidden' name='shared_record[user_ids][]' id='shared_record_user_ids_' value=${userID}>`)
      })
    }
    
    // Resume defaul form execution
    event.currentTarget.submit()
  })
  
  // On Chat update(this script duplicated in app/views/chats/show.js.erb for partial reload case)
  $('#modal-add-chat-member').on('submit', '[id^=edit_chat]', function(e) {
    let checkedMembers = $("[id^=checkbox-member-]:checked")
    if (checkedMembers.length > 0) {
      $("#chat_membership_usernames_").remove()
      checkedMembers.each(function() {
        let username = $(this).attr("data-username")
        $(e.target).append(`<input type="hidden" name="chat_membership[usernames][]" id="chat_membership_usernames_" value=${username}>`)
      })
    }
    
    $('#modal-add-chat-member').modal('hide')
  })
  
  // Twilio Video/Audio
  // Return to last Chat
  if ( window.location.pathname === '/chats' ) {
    let currentUrl = new URL(window.location.href);
    let lastChatAccessToken = currentUrl.searchParams.get('chat_access_token');
    let chatElement = $(`#chat-element-${lastChatAccessToken}`)
    window.history.pushState("", "", '/chats');
    if (lastChatAccessToken && chatElement.length > 0) { chatElement[0].click() }
  }
})
