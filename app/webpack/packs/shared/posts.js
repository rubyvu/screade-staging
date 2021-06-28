$( document ).on('turbolinks:load', function() {
  
  // Image
  $('#post-form-image-mask').on('click', function() {
    $.ajax({
        url: window.location.origin + '/posts/user_images',
        type: 'GET',
        dataType: 'jsonp'
    });
  })
  
  $('#user-images-form-placeholder').on('click', '.image-card', function() {
    let imgUrl = $(this).find('img').data('imageUrl')
    let imgId = $(this).find('img').data('imageId')
    
    readProfileURL(imgUrl, imgId)
    $('#modal-user-images').modal('hide')
  })
  
  function readProfileURL(url, id) {
    $('#post-image').attr('src', url);
    $('#post_image_id').val(id);
    
    $('#post-image').show();
    $('#icon-add-photo').hide();
  }
  
  // Close image modal after link click
  $('#modal-user-images').on('click', 'a', function() {
    $('#modal-user-images').modal('hide')
    $('body').removeClass('modal-open');
    $('.modal-backdrop').remove();
  })
  
  // Groups
  $('#post_virtual_source').on('click', function(){
    $.ajax({
        url: window.location.origin + '/groups/search',
        type: 'GET',
        data: { search_type: 'post' },
        dataType: 'jsonp'
    });
  })
  
  // Lit/Unlit Post
  $('.post-info-panel .info-panel-value-wrapper a[id^="post-lit-"]').on('ajax:success', function() {
    let element = $(this).first()
    
    if (element.attr('data-method') === 'post') {
      // Change icon class
      element.children().addClass('active')
      // Increase counter
      let counter = element.parent().find('.info-panel-value')
      counter.text(+(counter.text()) + 1)
      // Update link method
      element.attr('data-method', 'delete')
    } else if (element.attr('data-method') === 'delete') {
      // Change icon class
      element.children().removeClass('active')
      // Increase counter
      let counter = element.parent().find('.info-panel-value')
      counter.text(+(counter.text()) - 1)
      // Update link method
      element.attr('data-method', 'post')
    }
  })
  
  // Pause Notification switcher
  $('[id^="edit_post_"]').on('change', '[type=checkbox]', function() {
    $(this).closest('form').submit();
  })
  
  // Change lable position when tree dropdown is opened/closed
  $('#modal-select-group-for-post').on('change', '.group-wrapper input', function(e) {
    let dropdownLabel = $(this).parent('.group-wrapper').find('.counter-dropdown-wrapper label').first()
    
    if ( $(this).is(":checked") ) {
      dropdownLabel.toggleClass('flip');
    } else {
      dropdownLabel.toggleClass('flip');
    }
  })
})
