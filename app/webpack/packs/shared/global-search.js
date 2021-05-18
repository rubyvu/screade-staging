$( document ).on('turbolinks:load', function() {
  
  // Show/hide search form
  $('#navbar-search-inactive').mouseover(function() {
    $(this).fadeOut(0, function() {
      $('#navbar-search-active').fadeIn(500)
    })
    
  })
  
  $('#navbar-search-active').mouseleave(function() {
    $(this).fadeOut(0, function() {
      $('#navbar-search-inactive').fadeIn(500)
    })
    
    // Clear form input on hide
    $(this).find('#search_input').val('')
  })
})
