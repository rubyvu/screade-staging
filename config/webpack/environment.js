const { environment } = require('@rails/webpacker')
const jquery = require('./plugins/jquery')
const webpack = require('webpack')
const loaders = require('./loaders');

// Require loaders
environment.loaders.append('CSSLoaders', loaders.CSSLoaders);
environment.loaders.append('JSLoaders', loaders.JSLoaders);
environment.loaders.append('ERBLoaders', loaders.ERBLoaders);

environment.plugins.prepend('Provide', new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
    'window.jQuery': 'jquery',
    Popper: ['popper.js', 'default']
  })
);

environment.plugins.prepend('jquery', jquery)
module.exports = environment
