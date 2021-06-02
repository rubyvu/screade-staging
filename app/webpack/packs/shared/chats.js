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
})
