const path = require('path');
const webpackMerge = require('webpack-merge');
const Dotenv = require('dotenv-webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const LintPlugin = require('lint-webpack-plugin');
const StyleLintPlugin = require('stylelint-webpack-plugin');

const modeConfig = env => { console.log(`requiring ${env}`); return require(`./config/webpack.${env}`)(env) };

module.exports = ({ mode } = { mode: 'production' }) => {
  console.log(`Building for: ${mode}`);

  return webpackMerge(
    {
      mode,

      resolve: {
        extensions: ['.js', '.ts', '.elm']
      },

      module: {
        noParse: /\.elm$/,

        rules: [
          {
            test: /\.(eot|ttf|woff|woff2|svg)$/,
            use: 'file-loader?publicPath=../../&name=static/css/[hash].[ext]'
          },
          {
            test: /\.ts$/,
            enforce: 'pre',
            exclude: [/dist/, /functions/, /elm-stuff/, /node_modules/],
            use: [
              {
                loader: 'tslint-loader',
                options: {
                  configFile: 'tslint.json',
                  emitErrors: true,
                  formatter: 'stylish',
                  tsConfigFile: 'tsconfig.json',
                  typeCheck: true
                }
              }
            ]
          }
        ]
      },

      plugins: [
        new Dotenv({
          path: '.env',
          safe: true,
          systemvars: true
        }),

        new HtmlWebpackPlugin({
          template: path.join('src', 'static', 'index.html'),
          inject: 'body',
          filename: 'index.html'
        }),

        new StyleLintPlugin({
          configFile: '.stylelintrc',
          files: [path.join('src', 'static', 'styles', '**', '*.s?(a|c)ss')]
        }),

        new LintPlugin(['elm-format --validate src tests'])
      ]
    },
    modeConfig(mode)
  );
};
