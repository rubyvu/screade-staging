// Import libs from node modules
import 'bootstrap';
import jQuery from 'jquery';
import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import "select2";
import Marquee3k from 'marquee3000';
import 'bootstrap-datepicker';
import 'timepicker/jquery.timepicker.js';
import 'jquery-ui/ui/widgets/tabs';
import videojs from 'video.js';

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

// Import entry stylesheets for pack - IMPORTANT!
import 'stylesheets/application';
import "select2/dist/css/select2.min.css"

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
  
  // Hide modal after redirect and go back
  // $('a[data-type="modal-link"]').on('click', function() {
  //   $('a[data-type="modal-link"]').first().closest('[id^=modal]').modal('hide')
  //   $('body').removeClass('modal-open');
  //   $('.modal-backdrop').remove();
  // })
})
