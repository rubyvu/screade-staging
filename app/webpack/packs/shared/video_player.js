$( document ).on('turbolinks:load', function() {
  // VideoPlayer
  $('img[data-video-id]').parent().click(function(e){
    // Prevent Video play if clicked on delete icon
    if($(e.target).closest(".destroy-asset").length > 0 || $(e.target).closest(".update-asset").length > 0) {
      return
    }
    
    let src = $(this).find('img').attr('data-video-url');
    let videoPlayer = $('#user-assets-video-palyer')
    
    videoPlayer.parent().show()
    // Set imageUrl to Videoplayer
    videoPlayer.attr('src', src)
    videoPlayer.append('<source src="'+ src +'" type="video/mp4">')
    videoPlayer[0].play()
    
  })

  $('.video-player-bg').click(function(){
    let videoPlayer = $('#user-assets-video-palyer')
    videoPlayer.parent().hide()
    videoPlayer.attr('src', '')
    videoPlayer.empty()
  })
})
