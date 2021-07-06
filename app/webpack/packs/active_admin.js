// Load Active Admin's styles into Webpacker,
// see `active_admin.scss` for customization.
import "../stylesheets/active_admin";

import "@activeadmin/activeadmin";
import jQuery from 'jquery';
window.$ = window.jQuery = jQuery;

import "select2";
import "select2/dist/css/select2.min.css"

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
      
      // Post selector
      $('#post_source_id').select2({})
      $('#post_source_id').on('change', function() {
        let type = $("#post_source_id option:selected").attr('data-type');
        $('#post_source_type').val(type)
      });
    })
  })
}
