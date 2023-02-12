// Import libs from node modules
import 'bootstrap'
import jQuery from 'jquery'
import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'
import 'select2'
import 'select2/dist/css/select2.min.css'
import Marquee3k from 'marquee3000'
import 'bootstrap-datepicker'
import 'timepicker/jquery.timepicker.js'
import 'jquery-ui/ui/widgets/tabs'
import videojs from 'video.js'
import Cropper from 'cropperjs'
import 'cropperjs/dist/cropper.css'

// Import internal scripts
import './shared/chat/chats';
import './shared/chat/chat_messages';
import './shared/chat/chat_twilio';
import './shared/chat/recorder';
import './shared/events';
import './shared/font_customizer';
import './shared/global-search';
import './shared/groups';
import './shared/image_viewer';
import './shared/local_date';
import './shared/maps';
import './shared/modals';
import './shared/multilevel_dropdown';
import './shared/news_articles';
import './shared/notifications';
import './shared/posts';
import './shared/streams';
import './shared/user_asset';
import './shared/video_player';
import  { isTwelveHoursFormat } from './shared/location';

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

  //Init Ticker for Breaking news on page load
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

  // Cropping profile picture
  var cropper

  $('#update_profile_user_profile_picture').on('change', function(e) {
    const result = document.querySelector('.crop-result')
    const save = document.querySelector('#save-crop-result')

    if (e.target.files.length) {
      // start file reader
      const reader = new FileReader();
      reader.onload = (e)=> {
        if (e.target.result) {
          // create new image
          let img = document.createElement('img')
          img.id = 'image'
          img.src = e.target.result

          // clean result before
          result.innerHTML = ''

          // append new image
          result.appendChild(img)

          // show save btn and options
          save.classList.remove('hide');

          // init cropper
          cropper = new Cropper(img, {
            aspectRatio: 1 / 1,
            crop(event) {}
          })
        }
      }
      reader.readAsDataURL(e.target.files[0])
    }
  })

  $('#save-crop-result').on('click', function(event) {
    event.preventDefault()

    if (!cropper) { return }

    let imgBase64 = cropper.getCroppedCanvas({
      width: 600
    }).toDataURL('image/jpeg')

    $('#profile-image').attr('src', imgBase64)
    $('#update_profile_user_profile_picture_base64').val(imgBase64)
  })
})
