// Import entry stylesheets for pack - IMPORTANT!
import 'stylesheets/application';

const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

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
