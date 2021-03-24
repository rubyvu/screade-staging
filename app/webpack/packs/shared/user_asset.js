$( document ).on('turbolinks:load', function() {
  // Upload UserImage UserVideo on file select
  $("#user_image_uploader_image, #user_video_uploader_image").change(function(e) {
    let file = this.files[0]
    // Check that file size is less than 100MB
    if (file.size >= 104857600) {
      alert('Max file size is 100MB');
      return
    }
    
    this.form.submit();
  });
  
  // Check for valid Url
  if ($(".user-profile-assets-wrapper").length > 0) {
    // Run script every 15 seconds
    window.setInterval( function() {
      // Set unload Video urls
      let unloadVideos = $('img[data-video-loaded="false"]')
      if (unloadVideos.length > 0) {
        setUnloadedUrls(unloadVideos, 'video')
      }
      
      // Set unload Image urls
      let unloadImages = $('img[data-image-loaded="false"]')
      if (unloadImages.length > 0) {
        setUnloadedUrls(unloadImages, 'image')
      }
      
    }, 15000);
  }
  
  function setUnloadedUrls(objects, type) {
    let objectIds = []
    objects.each((i, el) => {
      let objectId = $(el).attr('data-'+ type +'-id')
      objectIds.push(objectId)
    });
    
    $.ajax({
      url: window.origin + '/user_' + type + 's/processed_urls',
      type: "get",
      data: { ids: objectIds },
      success: function(response) {
        responseObjects = response.images || response.videos
        
        if (responseObjects.length == 0) {
          return
        }
        
        responseObjects.forEach((item, i) => {
          objToUpdate = $('img[data-' + type + '-loaded="false"][data-' + type + '-id="' + item.id + '"]')
          if (type === 'image') {
            objToUpdate[0].src = item.rectangle_160_160_url
          } else if (type === 'video') {
            objToUpdate[0].src = item.file_thumbnail
            objToUpdate.attr('data-video-url', item.file_url)
          }
        });
      }
    });
  }
})
