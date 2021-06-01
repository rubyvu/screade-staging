$( document ).on('turbolinks:load', function() {
  // Create new Chat
  // Fill chat_membership[usernames][] hiden field with Users usernames on Submit button
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
})
