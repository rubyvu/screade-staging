$( document ).on('turbolinks:load', function() {
  
  // Full screen image on click
  $('img[data-enlargeable]').addClass('img-enlargeable').parent().click(function(e){
    // Prevent Video play if clicked on delete icon
    if($(e.target).closest(".destroy-asset").length > 0 || $(e.target).closest(".update-asset").length > 0) { return }
    
    let src = $(this).find('img').attr('src');
    let modal;
    
    function removeModal(){ modal.remove(); $('body').off('keyup.modal-close'); }
    modal = $('<div>').css({
      //background: 'rgba(0,0,0,.5) url('+src+') no-repeat center',
      background: 'rgba(0,0,0) url('+src+') no-repeat center',
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
})
