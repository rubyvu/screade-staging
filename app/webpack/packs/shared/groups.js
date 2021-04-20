$( document ).on('turbolinks:load', function() {
  
  // Subscription
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
  
  // Hack to make remote nested links in html works
  $('div').find('[data-action="create-topic"]').on('click', function() {
    var link = $(this).data('href');
    
    let groupType = $(this).data('type')
    let groupId = $(this).data('id')
    
    $.ajax({
      type: "GET",
      url: window.location.origin + link,
      data: {type: groupType, id: groupId}
    })
  })
  
  // Show when Tree dropdown is opened/closed
  $('.group-wrapper input').change(function(e) {
    let dropdownLabel = $(this).parent('.group-wrapper').find('.counter-dropdown-wrapper label').first()
    
    if ( $(this).is(":checked") ) {
      dropdownLabel.toggleClass('flip');
    } else {
      dropdownLabel.toggleClass('flip');
    }
  })
})
