# CSS Modules Demos

This repo is a collection of simple demos of [CSS Modules](https://github.com/css-modules/css-modules).

If you don't know, CSS Modules is a method to add local scope and module dependencies into CSS.

<img src="./css-modules-logo.png" width="300" height="300" />

## Usage

First, clone the repo.

```bash
$ git clone https://github.com/ruanyf/css-modules-demos.git
```

Install the dependencies.

```bash
$ cd css-modules-demos
$ npm install
```

Run the first demo.

```bash
$ npm run demo01
```

Open http://localhost:8080 , see the result.

Then run demo02, demo03...

## Index

1. [Local Scope](#demo01-local-scope)
1. [Global Scope](#demo02-global-scope)
1. [Customized Hash Class Name](#demo03-customized-hash-class-name)
1. [Composing CSS Classes](#demo04-composing-css-classes)
1. [Import Other Modules](#demo05-import-other-modules)
1. [Exporting Values Variables](#demo06-exporting-values-variables)

## Demo01: Local Scope

[demo](http://ruanyf.github.io/css-modules-demos/demo01/) / [sources](https://github.com/ruanyf/css-modules-demos/tree/master/demo01)

CSS rules are global. The only way of making a local-scoped rule is to generate a unique class name, so no other selectors will have collisions with it. That is exactly what CSS Modules do.

The following is a React component [`App.js`](https://github.com/ruanyf/css-modules-demos/blob/master/demo01/components/App.js).

```javascript
import React from 'react';
import style from './App.css';

export default () => {
  return (
    <h1 className={style.title}>
      Hello World
    </h1>
  );
};
```

In above codes, we import a CSS module from [`App.css`](https://github.com/ruanyf/css-modules-demos/blob/master/demo01/components/App.css) into a `style` object, and use `style.title` to represent a class name.

```css
.title {
  color: red;
}
```

The build runner will compile the class name `style.title` into a hash string.

```html
<h1 class="_3zyde4l1yATCOkgn-DBWEL">
  Hello World
</h1>
```

And `App.css` is also compiled.

```css
._3zyde4l1yATCOkgn-DBWEL {
  color: red;
}
```

Now this class name becomes unique and only effective to the `App` component.

CSS Modules provides [plugins](https://github.com/css-modules/css-modules/blob/master/docs/get-started.md) for different build runners. This repo uses [`css-loader`](https://github.com/webpack/css-loader#css-modules) for Webpack, since it support CSS Modules best and is easy to use. By the way, if you don't know Webpack, please read my tutorial [Webpack-Demos](https://github.com/ruanyf/webpack-demos).

The following is our [`webpack.config.js`](https://github.com/ruanyf/css-modules-demos/blob/master/demo01/webpack.config.js).

```javascript
module.exports = {
  entry: __dirname + '/index.js',
  output: {
    publicPath: '/',
    filename: './bundle.js'
  },
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        loader: 'babel',
        query: {
          presets: ['es2015', 'stage-0', 'react']
        }
      },
      {
        test: /\.css$/,
        loader: "style-loader!css-loader?modules"
      },
    ]
  }
};
```

The magic line is `loader: "style-loader!css-loader?modules"`, which appends the query parameter `modules` after `css-loader` enabling the CSS Modules feature.

Now run the demo.

```bash
$ npm run demo01
```

Open http://localhost:8080, you should see the `h1` in red.

## Demo02: Global Scope

[demo](http://ruanyf.github.io/css-modules-demos/demo02/) / [sources](https://github.com/ruanyf/css-modules-demos/tree/master/demo02)

The syntax `:global(.className)` could be used to declare a global selector explicitly. CSS Modules will not compile this class name into hash string.

First, add a global class into [`App.css`](https://github.com/ruanyf/css-modules-demos/blob/master/demo02/components/App.css).

```css
.title {
  color: red;
}

:global(.title) {
  color: green;
}
```

Then use the global CSS class in [`App.js`](https://github.com/ruanyf/css-modules-demos/blob/master/demo02/components/App.css).

```javascript
import React from 'react';
import styles from './App.css';

export default () => {
  return (
    <h1 className="title">
      Hello World
    </h1>
  );
};
```

Run the demo.

```bash
$ npm run demo02
```

Open http://localhost:8080, you should see the `h1` title in green.

CSS Modules also has a explicit local scope syntax `:local(.className)` which is equivalent to `.className`. So the above `App.css` could be written in another form.

```css
:local(.title) {
  color: red;
}

:global(.title) {
  color: green;
}
```

## Demo03: Customized Hash Class Name

[demo](http://ruanyf.github.io/css-modules-demos/demo03/) / [sources](https://github.com/ruanyf/css-modules-demos/tree/master/demo03)

CSS-loader's default hash algorithm is `[hash:base64]`, which compiles`.title` into something like `._3zyde4l1yATCOkgn-DBWEL`.

You could customize it in [`webpack.config.js`](https://github.com/ruanyf/css-modules-demos/blob/master/demo03/webpack.config.js).

```javascript
module: {
  loaders: [
    // ...
    {
      test: /\.css$/,
      loader: "style-loader!css-loader?modules&localIdentName=[path][name]---[local]---[hash:base64:5]"
    },
  ]
}
```

Run the demo.

```bash
$ npm run demo03
```

You will find `.title` hashed into `demo03-components-App---title---GpMto`.

## Demo04: Composing CSS Classes

[demo](http://ruanyf.github.io/css-modules-demos/demo04/) / [sources](https://github.com/ruanyf/css-modules-demos/tree/master/demo04)

In CSS Modules, a selector could inherit another selector's rules, which is called ["composition"](https://github.com/css-modules/css-modules#composition).

We let `.title` inherit `.className` in [`App.css`](https://github.com/ruanyf/css-modules-demos/blob/master/demo04/components/App.css).

```css
.className {
  background-color: blue;
}

.title {
  composes: className;
  color: red;
}
```

[`App.js`](https://github.com/ruanyf/css-modules-demos/blob/master/demo04/components/App.js) is the same.

```javascript
import React from 'react';
import style from './App.css';

export default () => {
  return (
    <h1 className={style.title}>
      Hello World
    </h1>
  );
};
```

Run the demo.

```bash
$ npm run demo04
```

You should see a red `h1` title in a blue background.

After the building process, `App.css` is converted into the following codes.

```css
._2DHwuiHWMnKTOYG45T0x34 {
  color: red;
}

._10B-buq6_BEOTOl9urIjf8 {
  background-color: blue;
}
```

And the HTML element `h1`'s class names should look like `<h1 class="_2DHwuiHWMnKTOYG45T0x34 _10B-buq6_BEOTOl9urIjf8">`,

## Demo05: Import Other Modules

[demo](http://ruanyf.github.io/css-modules-demos/demo05/) / [sources](https://github.com/ruanyf/css-modules-demos/tree/master/demo05)

You also could inherit rules from another CSS file.

[`another.css`](https://github.com/ruanyf/css-modules-demos/blob/master/demo05/components/another.css)

```css
.className {
  background-color: blue;
}
```

[`App.css`](https://github.com/ruanyf/css-modules-demos/blob/master/demo05/components/App.css)

```css
.title {
  composes: className from './another.css';
  color: red;
}
```

Run the demo.

```bash
$ npm run demo05
```

You should see a red `h1` title in a blue background.

## Demo06: Exporting Values Variables

[demo](http://ruanyf.github.io/css-modules-demos/demo06/) / [sources](https://github.com/ruanyf/css-modules-demos/tree/master/demo06)

You could use variables in CSS Modules. This feature is provided by PostCSS and the [postcss-modules-values](https://github.com/css-modules/postcss-modules-values) plugin.

```bash
$ npm install --save postcss-loader postcss-modules-values
```

Add `postcss-loader` into [`webpack.config.js`](https://github.com/ruanyf/css-modules-demos/blob/master/demo06/webpack.config.js).

```javascript
var values = require('postcss-modules-values');

module.exports = {
  entry: __dirname + '/index.js',
  output: {
    publicPath: '/',
    filename: './bundle.js'
  },
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        loader: 'babel',
        query: {
          presets: ['es2015', 'stage-0', 'react']
        }
      },
      {
        test: /\.css$/,
        loader: "style-loader!css-loader?modules!postcss-loader"
      },
    ]
  },
  postcss: [
    values
  ]
};
```

Next, set up your values/variables in [`colors.css`](https://github.com/ruanyf/css-modules-demos/blob/master/demo06/components/colors.css).

```css
@value blue: #0c77f8;
@value red: #ff0000;
@value green: #aaf200;
```

Then import them into [`App.css`](https://github.com/ruanyf/css-modules-demos/tree/master/demo06/components).

```css
@value colors: "./colors.css";
@value blue, red, green from colors;

.title {
  color: red;
  background-color: blue;
}
```

Run the demo.

```bash
$ npm run demo06
```

## License

MIT
