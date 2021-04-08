// Import libs from node modules
import 'bootstrap';
import jQuery from 'jquery';
import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import LocalTime from "local-time"
import "channels";
import "select2";
import "webticker/jquery.webticker.min.js";
import 'bootstrap-datepicker';
import 'timepicker/jquery.timepicker.js';

// Import internal scripts
import './shared/font_customizer';
import './shared/image_viewer';
import './shared/modals';
import './shared/news_articles';
import './shared/user_asset';
import './shared/video_player';

// Import entry stylesheets for pack - IMPORTANT!
import 'stylesheets/application';
import "select2/dist/css/select2.min.css"

Rails.start()
Turbolinks.start()
ActiveStorage.start()
window.$ = window.jQuery = jQuery;
LocalTime.start()

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
  $('.datepicker').datepicker({
    container: '#modal-new-event',
    format: 'dd-mm-yyyy',
    showWeekDays: false,
    todayHighlight: false,
    autoclose: true,
    orientation: 'top'
  }).on('show', function(e) {
    e.stopPropagation();
  });

  // Timepicker
  $('input.timepicker').timepicker({
      step: 5,
      listWidth: 1,
      timeFormat: 'H:i',
      show2400: true
  })
  
  //Init Ticker for Breaking news on page load
  $('#webticker').webTicker({ height: '36px', duplicate: true, startEmpty: false });
})
