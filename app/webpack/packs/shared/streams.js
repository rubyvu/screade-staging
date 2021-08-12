$( document ).on('turbolinks:load', function() {
  $('#stream-switcher').click(function() {
    updateParamsBySwitcher($(this))
  });
  
  $('#all-streams-switcher, #my-streams-switcher').click(function() {
    let allStreams = $('#all-streams-switcher')
    let myStreams = $('#my-streams-switcher')
    
    if (myStreams.is(this)) {
      $('#stream-switcher').prop('checked', true);
      $(this).addClass('active')
      allStreams.removeClass('active')
    } else if (allStreams.is(this)) {
      $('#stream-switcher').prop('checked', false);
      $(this).addClass('active')
      myStreams.removeClass('active')
    } else {
      return
    }
    
    updateParamsBySwitcher($('#stream-switcher'))
  })
  
  function updateParamsBySwitcher(switcher) {
    var queryParams = new URLSearchParams(window.location.search);
    if( switcher.is(':checked') ) {
      queryParams.set("is_private", "true");
    } else {
      queryParams.set("is_private", "false");
    }
    
    queryParams.set("page", "1");
    history.replaceState(null, null, "?"+queryParams.toString());
    window.location.href = document.URL
  }
})
