const path = require('path');

const CSSLoaders = {
  test: /\.css$/,
  exclude: /node_modules/,
  use: [
    {
      loader: 'resolve-url-loader'
    },
    {
      loader: 'style-loader'
    },
    {
      loader: 'css-loader'
    },
    {
      loader: 'postcss-loader'
    }
  ]
};

const JSLoaders = {
  test: /\.js$/,
  exclude: /node_modules/,
  use: {
    loader: 'babel-loader',
    options: {
      presets: [
        ['@babel/preset-env',
          {
            targets: {
              browsers: ['last 3 versions', '> 1%']
            },
            forceAllTransforms: true,
            // Enable polyfill transforms
            useBuiltIns: 'entry',
            corejs: 3,
            // Do not transform modules to CJS
            modules: false,
            exclude: ['transform-typeof-symbol']
          }
        ]
      ],
      plugins: [
        'babel-plugin-macros',
        '@babel/plugin-syntax-dynamic-import',
        '@babel/plugin-transform-destructuring',
        [
          '@babel/plugin-proposal-class-properties',
          {
            loose: true
          }
        ],
        [
          '@babel/plugin-proposal-object-rest-spread',
          {
            useBuiltIns: true
          }
        ],
        [
          '@babel/plugin-transform-runtime',
          {
            helpers: false,
            regenerator: true,
            corejs: false
          }
        ],
        [
          '@babel/plugin-transform-regenerator',
          {
            async: false
          }
        ],
        [
          'babel-plugin-module-resolver',
          {
            root: ['./app'],
            alias: {
              assets: './assets'
            }
          }
        ]
      ]
    }
  }
};

const ERBLoaders = {
  test: /\.erb$/,
  enforce: 'pre',
  exclude: /node_modules/,
  use: [{
    loader: 'rails-erb-loader',
    options: {
      runner: (/^win/.test(process.platform) ? 'ruby ' : '') + 'bin/rails runner'
    }
  }]
};

module.exports = {
  CSSLoaders: CSSLoaders,
  JSLoaders: JSLoaders,
  ERBLoaders: ERBLoaders
};
