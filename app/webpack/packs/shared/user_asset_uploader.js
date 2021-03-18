$( document ).on('turbolinks:load', function() {
  // Upload UserImage UserVideo on file select
  $("#user_image_uploader_image, #user_video_uploader_image").change(function(e) {
    let file = this.files[0]
    // Check that file size is less than 50MB
    if (file.size >= 52428800) {
      alert(this.files[0].size);
      return
    }
    
    this.form.submit();
  });
})
