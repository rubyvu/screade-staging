$( document ).on('turbolinks:load', function() {
  
  // Full screen image on click
  $('img[data-enlargeable]').addClass('img-enlargeable').parent().click(function(){
    let src = $(this).find('img').attr('src');
    let modal;
    
    function removeModal(){ modal.remove(); $('body').off('keyup.modal-close'); }
    modal = $('<div>').css({
      background: 'rgba(0,0,0,.5) url('+src+') no-repeat center',
      backgroundSize: 'contain',
      width:'100%', height:'100%',
      position:'fixed',
      zIndex:'10000',
      top:'0', left:'0',
      cursor: 'zoom-out'
    }).click(function(){
      removeModal();
    }).appendTo('body');
    
    //handling ESC
    $('body').on('keyup.modal-close', function(e){
      if (e.key === 'Escape'){ removeModal(); }
    });
  });
  
  // Upload UserImage UserVideo on file select
  $("#user_image_uploader_image, #user_video_uploader_image").change(function() {
    
    // Check that file is less than 10MB
    if (this.files[0].size >= 10485760) {
      alert(this.files[0].size);
      return
    }
    
    this.form.submit();
  });
})
