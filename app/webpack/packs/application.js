// Import libs from node modules
import 'bootstrap';
import jQuery from 'jquery';
import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import "select2";
import "webticker/jquery.webticker.min.js";

// Import internal scripts
import './shared/modals';

// Import entry stylesheets for pack - IMPORTANT!
import 'stylesheets/application';
import "select2/dist/css/select2.min.css"

Rails.start()
Turbolinks.start()
Turbolinks.visit(window.location)
ActiveStorage.start()
window.$ = window.jQuery = jQuery;

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
    $( document ).on('turbolinks:load', function() {
      // Init Ticker for Breaking news
      $('#webticker').webTicker({ height: '36px', duplicate: true, startEmpty: false });
    })
  });
}
