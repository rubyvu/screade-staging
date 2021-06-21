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
  
  $('#search-button-submit').on('click', function(e) {
    var searchInputField = $('#global-search-form').find('#search_input')[0]
    if ( searchInputField.checkValidity() ) {
      $('#global-search-form').submit()
    } else {
      searchInputField.reportValidity()
    }
  });
  
  // Subscription in search
  $(".search-result-card .search-element-wrapper").on('ajax:complete', function(event) {
    location.reload()
  })
})
