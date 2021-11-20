// Load Active Admin's styles into Webpacker,
// see `active_admin.scss` for customization.
import '../stylesheets/active_admin'

import '@activeadmin/activeadmin'
import 'activeadmin_addons'
import jQuery from 'jquery'
window.$ = window.jQuery = jQuery

window.App = new function () {
  /**
   * Initializer
   * @protected
   */
  $(function() {
    $(document).ready(function() {
      // Topic#new Topic#edit
      $('#topic_parent_id').on('change', function() {
        let type = $("#topic_parent_id option:selected").attr('data-type')
        $('#topic_parent_type').val(type)
      })
      
      // Post selector
      $('#post_source_id, #breaking_news_post_id').select2({ })
      $('#post_source_id').on('change', function() {
        let type = $("#post_source_id option:selected").attr('data-type')
        $('#post_source_type').val(type)
      })
    })
  })
}
