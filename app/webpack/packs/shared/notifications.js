$( document ).on('turbolinks:load', function() {
  $('#dropdown-notification').mouseover(function() {
    console.log('Notifyyyy');
    // Get all not viewed Notifications for User
    $.ajax({
        url: window.location.origin + '/notifications',
        type: 'GET',
        dataType: 'jsonp'
    });
  })
})
