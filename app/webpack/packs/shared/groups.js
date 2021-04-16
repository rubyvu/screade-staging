$( document ).on('turbolinks:load', function() {
  
  $('.group-wrapper').on('click', function(e) {
    // Prevent calling click event on all parent ul,li elements
    e.stopPropagation()
    
    // Click on Dropdown button do:
    if( !$(e.target).is('.main-content') ) { return }
    
    // Subscribe elements
    let mainContentEl = $(this).children('.main-content')
    
    if (mainContentEl.hasClass('active')) {
      mainContentEl.removeClass('active')
    } else {
      mainContentEl.addClass('active')
    }
  })
  
})
