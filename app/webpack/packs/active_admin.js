// Load Active Admin's styles into Webpacker,
// see `active_admin.scss` for customization.
import "../stylesheets/active_admin";

import "@activeadmin/activeadmin";
import jQuery from 'jquery';
window.$ = window.jQuery = jQuery;

window.App = new function () {
  /**
   * Initializer
   * @protected
   */
  $(function() {
    $(document).ready(function() {
      // Topic#new Topic#edit
      $('#topic_parent_id').on('change', function() {
        let type = $("#topic_parent_id option:selected").attr('data-type');
        $('#topic_parent_type').val(type)
      });
    })
  })
}
