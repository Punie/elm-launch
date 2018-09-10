const path = require('path');
const glob = require('glob');
const postcssPresetEnv = require('postcss-preset-env');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const PurifyCSSPlugin = require('purifycss-webpack/dist');
const ImageminPlugin = require('imagemin-webpack-plugin').default;
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');

module.exports = () => ({
  entry: {
    main: path.join(__dirname, '../src/index.ts')
  },

  output: {
    filename: 'static/js/[name].[chunkhash].bundle.js'
  },

  optimization: {
    splitChunks: {
      chunks: 'all'
    }
  },

  performance: {
    maxEntrypointSize: 512000,
    maxAssetSize: 512000
  },

  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          {
            loader: 'elm-webpack-loader',
            options: {
              pathToElm: path.join('node_modules', '.bin', 'elm'),
              optimize: true
            }
          }
        ]
      },
      {
        test: /\.ts$/,
        use: 'ts-loader',
        exclude: [/dist/, /functions/, /elm-stuff/, /node_modules/]
      },
      {
        test: /\.(sa|sc|c)ss$/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: 'css-loader',
            options: { importLoaders: 1 }
          },
          {
            loader: 'postcss-loader',
            options: {
              ident: 'postcss',
              plugins: [postcssPresetEnv()]
            }
          },
          {
            loader: 'sass-loader',
            options: {
              includePaths: [path.resolve(__dirname, 'node_modules')]
            }
          }
        ]
      }
    ]
  },

  plugins: [
    new MiniCssExtractPlugin({
      filename: 'static/css/[name].[hash].css',
      chunkFilename: '[id].[hash].css'
    }),

    new PurifyCSSPlugin({
      paths: glob.sync(path.join(__dirname, '../src/**/*.{elm,html}')),
      purifyOptions: {
        rejected: true,
        whitelist: ['*markdown-content*', '*hljs*']
      },
      verbose: false
    }),

    new CopyWebpackPlugin([
      {
        from: path.join('src', 'static', 'assets'),
        to: path.join('static', 'assets')
      },
      {
        from: path.join('src', 'static', 'favicon.ico')
      }
    ]),

    new ImageminPlugin({ test: /\.(jpe?g|png|gif|svg)$/i }),

    new UglifyJsPlugin({
      cache: true,
      parallel: true,
      uglifyOptions: {
        compress: {
          pure_funcs: ['F2','F3','F4','F5','F6','F7','F8','F9','A2','A3','A4','A5','A6','A7','A8','A9'],
          pure_getters: true,
          keep_fargs: false,
          unsafe_comps: true,
          unsafe: true,
          passes: 3
        }
      }
    }),

    new OptimizeCSSAssetsPlugin()
  ]
});
