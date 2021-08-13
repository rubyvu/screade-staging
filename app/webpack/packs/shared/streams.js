$( document ).on('turbolinks:load', function() {
  
  // Switch between All Streams/ My Streams
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
  
  // Lit/Unlit Post
  $('.stream-info-panel .info-panel-value-wrapper a[id^="stream-lit-"]').on('ajax:success', function() {
    let element = $(this).first()
    
    if (element.attr('data-method') === 'post') {
      // Change icon class
      element.children().addClass('active')
      
      // Update link method
      element.attr('data-method', 'delete')
      
      let pageRegexp = new RegExp('\/streams\/[a-zA-Z0-9]+');
      if (!window.location.pathname.match(pageRegexp)) {
        // Increase counter on index page
        let counter = element.parent().find('.info-panel-value')
        counter.text(+(counter.text()) + 1)
      }
      
    } else if (element.attr('data-method') === 'delete') {
      // Change icon class
      element.children().removeClass('active')
      
      // Update link method
      element.attr('data-method', 'post')
      
      let pageRegexp = new RegExp('\/streams\/[a-zA-Z0-9]+');
      if (!window.location.pathname.match(pageRegexp)) {
        // Decrease counter on index page
        let counter = element.parent().find('.info-panel-value')
        counter.text(+(counter.text()) - 1)
      }
    }
  })
})
