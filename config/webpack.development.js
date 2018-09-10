const path = require('path');
const postcssPresetEnv = require('postcss-preset-env');

module.exports = () => ({
  entry: [
    'webpack-dev-server/client?http://localhost:8080',
    path.join(__dirname, '../src/index.ts')
  ],

  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          {
            loader: 'elm-hot-webpack-loader'
          },
          {
            loader: 'elm-webpack-loader',
            options: {
              pathToElm: path.join('node_modules', '.bin', 'elm'),
              verbose: true,
              debug: true
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
          {
            loader: 'style-loader'
          },
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

  devServer: {
    historyApiFallback: true,
    contentBase: './src',
    inline: true,
    stats: 'errors-only'
  }
});
