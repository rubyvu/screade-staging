// Import libs from node modules
import 'bootstrap';
import jQuery from 'jquery';
import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import "select2";

// Import internal scripts
import './shared/modals';

// Import entry stylesheets for pack - IMPORTANT!
import 'stylesheets/application';
import "select2/dist/css/select2.min.css"

Rails.start()
Turbolinks.start()
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
    
  });
}
