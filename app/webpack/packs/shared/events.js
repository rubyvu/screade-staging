$( document ).on('turbolinks:load', function() {
  
  // Render Event edit
  $('.events-wrapper').on('click', '.event-card', function(e) {
    if ($(e.target).parent().hasClass('destroy-event')) { return }
    
    let eventId = $(this).attr('id')
    $.ajax({ type: "GET", url: window.location.origin + '/events/' + eventId + '/edit' });
  })
})
