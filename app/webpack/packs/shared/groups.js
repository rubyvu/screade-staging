$( document ).on('turbolinks:load', function() {
  
  $('.group-wrapper').on('click', function(e) {
    // Prevent calling click event on all parent ul,li elements
    e.stopPropagation()
    
    // Click on Dropdown button do:
    if( !$(e.target).is('.main-content') ) { return }
    
    // Subscribe elements
    let mainContentEl = $(this).children('.main-content')
    
    // Get Grop type and ID
    let groupType = mainContentEl.attr('data-type')
    let groupId = mainContentEl.attr('id')
    
    let subscriptionsCount = mainContentEl.parents('.root-level').find('span.counter')
    let subscriptionCounter = parseInt(subscriptionsCount.text(), 10)
    
    if (mainContentEl.hasClass('active')) {
      // Send request to unsubscribe
      $.ajax({
        type: "DELETE",
        url: window.location.origin + '/groups/unsubscribe',
        data: { type: groupType, id: groupId }
      }).done(function( data ) {
        if ( data.success ) {
          // Update view
          mainContentEl.removeClass('active')
          subscriptionsCount.text(subscriptionCounter-1)
         }
      });
      
    } else {
      $.ajax({
        type: "POST",
        url: window.location.origin + '/groups/subscribe',
        data: { type: groupType, id: groupId }
      }).done(function( data ) {
        if ( data.success ) {
          mainContentEl.addClass('active')
          subscriptionsCount.text(subscriptionCounter+1)
        }
      });
    }
  })
})
