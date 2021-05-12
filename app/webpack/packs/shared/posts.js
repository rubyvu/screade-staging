$( document ).on('turbolinks:load', function() {
  
  // Image
  $('#post-form-image-mask').on('click', function() {
    $("#post_image").click();
  })
  
  $("#post_image").change(function() {
    console.log('1');
    readProfileURL(this);
  });
  
  function readProfileURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(e) {
        $('#post-image').attr('src', e.target.result);
        $('#post-image').show();
        $('#icon-add-photo').hide();
      }
      
      reader.readAsDataURL(input.files[0]);
    }
  }
  
  // Posts
  let groupId= $('#post_source_id').val()
  let postDropdown = $('#post_source').select2({
    dropdownParent: $('#post-select-dropdown-position')
  })
  
  // Reload Dropdown for edit
  if ( groupId ) {
    postDropdown.val(groupId);
    $('#post_source').select2({ dropdownParent: $('#post-select-dropdown-position') })
  }
  
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
})
