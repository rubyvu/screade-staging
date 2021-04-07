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
import 'jquery-timepicker/jquery.timepicker.js';

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
    $(document).ready(function() {
      //Init Ticker for Breaking news on page reload
      $('#webticker').webTicker({ height: '36px', duplicate: true, startEmpty: false });
      
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
    })
    
    // Timepicker
    $('.timepicker').timepicker({
        timeFormat: 'HH:mm',
        interval: 5,
        defaultTime: '00',
        startTime: '00:00',
        dropdown: true,
        scrollbar: true,
        zindex: 9999999
    })
    
    $( document ).on('turbolinks:load', function() {
      //Init Ticker for Breaking news on page load
      $('#webticker').webTicker({ height: '36px', duplicate: true, startEmpty: false });
    })
  });
}
