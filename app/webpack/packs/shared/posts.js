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
  
  // Groups
  // $('#post_source').select2({
  //   dropdownParent: $('#post-select-dropdown-position')
  // })
  $('#post_source').select2({
    data: [{id: 0, text: ''}]
  });
  // $('#post_source').select2({id: $('#post_source_id').val(), text: $('#post_source_name').val() });
})
