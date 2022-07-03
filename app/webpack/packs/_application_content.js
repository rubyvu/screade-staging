import 'select2/dist/css/select2.min.css'

require.context("../images", true)

Rails.start()
Turbolinks.start()
ActiveStorage.start()
window.$ = window.jQuery = jQuery;
window.isTwelveHoursFormat = isTwelveHoursFormat;

const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

/**
 * @class Singleton App.
 * @public
 */
window.App = new function () {
  /**
   * Initializer
   * @protected
   */
  $(function() {
    
  });
}

$(document).on('turbolinks:load', function () {
  // Datepicker
  $('.datepicker-event').datepicker({
    container: '#modal-new-event',
    format: 'dd-mm-yyyy',
    showWeekDays: false,
    todayHighlight: false,
    autoclose: true,
    orientation: 'top'
  }).on('show hide', function(e) {
    e.stopPropagation();
  });
  
  // Timepicker
  let timePickerOptions = {
    step: 5,
    listWidth: 1
  }
  
  if (!isTwelveHoursFormat()) {
    timePickerOptions.timeFormat = 'H:i'
    timePickerOptions.show2400 = true
  }
  $('input.timepicker').timepicker(timePickerOptions)
  
  // Init Ticker for Breaking news on page load
  Marquee3k.init({
    selector: 'marquee3k',
  });
  window.addEventListener('load', (event) => {
     Marquee3k.refreshAll();
  });
  
  // Init Video.js
  let videojsElement = document.querySelector('.video-js')
  if (videojsElement) { videojs(videojsElement) }
  
  // Translate Post
  $('.translate-post').click(function(event) {
    event.preventDefault()
    
    const translateButton = $(this)
    const shouldTranslate = translateButton.text() === 'Translate'
    const postID = translateButton.data('id')
    const postElementID = `post-${postID}`
    
    if (!postID) {
      return
    }
    
    const titleOriginalSelector = `#${postElementID} .post-title .original`
    const descriptionOriginalSelector = `#${postElementID} .post-description .original`
    
    const titleTranslationSelector = `#${postElementID} .post-title .translation`
    const descriptionTranslationSelector = `#${postElementID} .post-description .translation`
    
    if (shouldTranslate) {
      translateButton.text('Translating...')
      
      $.get(`/posts/${postID}/translate`, function(data) {
        translateButton.text('Show original')
        
        // Toggle visibility
        $(titleOriginalSelector).hide()
        $(descriptionOriginalSelector).hide()
        
        $(titleTranslationSelector).show()
        $(descriptionTranslationSelector).show()
        
        // Put translations in
        $(titleTranslationSelector).text(data.post.title)
        $(descriptionTranslationSelector).text(data.post.description)
      })
    } else {
      translateButton.text('Translate')
      
      // Toggle visibility
      $(titleOriginalSelector).show()
      $(descriptionOriginalSelector).show()
      
      $(titleTranslationSelector).hide()
      $(descriptionTranslationSelector).hide()
      
      // Clear translations
      $(titleTranslationSelector).text('')
      $(descriptionTranslationSelector).text('')
    }
  })
  
  // Translate Comment
  $('.translate-comment').click(function(event) {
    event.preventDefault()
    
    const translateButton = $(this)
    const shouldTranslate = translateButton.text() === 'Translate'
    const commentID = translateButton.data('id')
    const commentElementID = `comment-${commentID}`
    
    if (!commentID) {
      return
    }
    
    const messageOriginalSelector = `#${commentElementID} .comment-text .original`
    const messageTranslationSelector = `#${commentElementID} .comment-text .translation`
    
    if (shouldTranslate) {
      translateButton.text('Translating...')
      
      $.get(`/comments/${commentID}/translate`, function(data) {
        translateButton.text('Show original')
        
        // Toggle visibility
        $(messageOriginalSelector).hide()
        $(messageTranslationSelector).show()
        
        // Put translations in
        $(messageTranslationSelector).text(data?.comment?.message)
      })
    } else {
      translateButton.text('Translate')
      
      // Toggle visibility
      $(messageOriginalSelector).show()
      $(messageTranslationSelector).hide()
      
      // Clear translations
      $(messageTranslationSelector).text('')
    }
  })
  
  // Show 'Invite friends' modal if time has come
  if ($('#show-invite-friends').length) {
    $('#modal-invite-friends').modal('show')
    
    // Record on backend that 'Invite friends' modal was shown
    $.post(`/invitations/hide_popup`, function(data) {})
  }
  
  // Show 'Sign Up' modal (with invitation)
  if ($('#show-sign-up-invite').length) {
    $('#modal-sign-up').modal('show')
  }
})
