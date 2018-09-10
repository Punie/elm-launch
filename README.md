# Elm Launch :rocket:

An opinionated example for scaffolding an Elm-based single-page application with firebase authentication, typescript interop and webpack.

#### [Demo](https://elm-launch.firebaseapp.com/)

#### Table of contents :scroll:

-   [About](#about)

    -   [What this project is NOT](#what-this-project-is-not-warning)
    -   [What is it then?](#what-is-it-then)
    -   [Features](#features-sparkles)
    -   [Code organization](#code-organization-art)

-   [Usage](#usage)

    -   [Requirements](#requirements)
    -   [Install](#install)
    -   [Develop](#develop-wrench)
    -   [Test](#test-white_check_mark)
    -   [Build for production](#build-for-production-factory)

-   [Maintainers](#maintainers-busts_in_silhouette)
-   [Contributing](#contributing-octocat)
-   [Changelog](#changelog-memo)
-   [Acknowledgements](#acknowledgements-heart)
-   [License](#license-page_facing_up)

## About

### What this project is NOT :warning:

This is _NOT_ yet another _webpack-boilerplate-starter-pack-thingy_.
_**A LOT**_ of stuff in here is 100% unnecessary to most Elm projects. Many solutions to non-problems are over-engineered :books: to the point it's not even funny.

### What is it then?

I needed a place to experiment :microscope: with a few things, including:

-   trying out a new library I'd like to include in a real project
-   experimenting with new versions of Elm
-   ...or new versions of Elm tools
-   improving my lint/test/build/deploy pipeline for future reference
-   and more...

### Features :sparkles:

### Code organization :art:

The project root only contains description files (such as this [README](README.md) or the [contributing guidelines](CONTRIBUTING.md)), dependencies files ([`package.json`](package.json) for node dependencies and [`elm.json`](elm.json) for Elm dependencies) and configuration files for build tools, deployment tools, linters, CI, environment variables...

The application sources reside in the `src` folder and the tests in the `tests` folder:

```
.
┆
├── src/
│   ├── elm/                # root for all *.elm files
│   │   ├── Main/
│   │   │   └── index.d.ts  # type definitions for the elm application interface (flags, ports, etc...)
│   │   ┆
│   │   └── Main.elm        # elm application's entry point
│   ├── lib/                # all *.ts files used by index.ts
│   │   ├── elm.ts          # elm interop helpers
│   │   └── firebase.ts     # firebase helpers
│   ├── static/
│   │   ├── assets/         # static assets (such as images, audio files, etc...)
│   │   ├── styles/         # style sheets
│   │   │   └── main.scss
│   │   ├── favicon.ico
│   │   └── index.html
│   └── index.ts            # application's entry point
├── tests/
│   ├── Tests/              # elm test files (by modules)
│   └── Tests.elm           # all elm tests
┆
```

## Usage

### Requirements

-   [Node](https://nodejs.org/) >= 8.11.4
-   [Yarn](https://yarnpkg.com/)
-   [Elm](http://elm-lang.org/)

### Install

```bash
$ git clone https://github.com/Punie/elm-launch && cd elm-launch
$ yarn
```

### Develop :wrench:

```bash
$ yarn dev
$ yarn dev:dashboard
```

### Test :white_check_mark:

```bash
$ yarn test
$ yarn test:watch
```

### Build for production :factory:

You can create an optimized build for production with the following command.

```bash
$ yarn prod
```

## Maintainers :busts_in_silhouette:

[@Punie](https://github.com/Punie) - _Hugo Saracino_

## Contributing :octocat:

Your help would be very much appreciated, should you want to suggest new features, improve the code quality, optimize the build and deploy configurations or submit bug reports.

Before doing so, however, please read the [contributing guidelines](CONTRIBUTING.md) as I am utterly and unapologetically OCD with the way code should look like.

## Changelog :memo:

If you'd like to take look at the history of the project without having to crawl through the commit log, we do maintain a [changelog](CHANGELOG.md) based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## Acknowledgements :heart:

This repo draws inspiration heavily from a number of community projects:

-   The semi-official [elm-webpack-starter](https://github.com/elm-community/elm-webpack-starter) from Elm Community
-   Romario Lopez's [elm-webpack-4-starter](https://github.com/romariolopezc/elm-webpack-4-starter)
-   Dillon Kearns' [elm-typescript-interop](https://github.com/dillonkearns/elm-typescript-interop)
-   Richard Feldman's [elm-spa-example](https://github.com/rtfeldman/elm-spa-example)

## License :page_facing_up:

[BSD-3-Clause](LICENSE) :copyright: Hugo Saracino
