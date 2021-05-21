$( document ).on('turbolinks:load', function() {
  $('#dropdown-notification').mouseover(function() {
    // Get all not viewed Notifications for User
    $.ajax({
        url: window.location.origin + '/notifications',
        type: 'GET',
        dataType: 'jsonp'
    });
  })
})
