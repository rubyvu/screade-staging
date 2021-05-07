$( document ).on('turbolinks:load', function() {
  
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
})
