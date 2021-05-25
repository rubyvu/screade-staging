$( document ).on('turbolinks:load', function() {
  $('#dropdown-notification').mouseover(function() {
    // Get all not viewed Notifications for User
    $.ajax({
        url: window.location.origin + '/notifications',
        type: 'GET',
        dataType: 'jsonp'
    });
  })
  
  // View notification
  $('[aria-labelledby="dropdown-notification"]').on('click', 'a.dropdown-item.notification', function() {
    $.ajax({
      url: window.location.origin + '/notifications/' + $(this).data('id'),
      type: 'PUT',
      data: { notification: { is_viewed: true } },
      dataType: 'json'
    });
  })
})
