$( document ).on('turbolinks:load', function() {
  // News Switcher from National to World
  $('#news-switcher').click(function() {
    var queryParams = new URLSearchParams(window.location.search);
    if( $(this).is(':checked') ) {
      queryParams.set("is_national", "false");
    } else {
      queryParams.set("is_national", "true");
    }
    
    queryParams.set("page", "1");
    history.replaceState(null, null, "?"+queryParams.toString());
    window.location.href = document.URL
  });
});
