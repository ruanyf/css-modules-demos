# CSS Modules Demos

This repo is a collection of simple demos of [CSS Modules](https://github.com/css-modules/css-modules).

If you don't know, CSS Modules brings local scope and module dependencies into CSS.

## Usage

First, clone the repo.

```bash
$ git clone git@github.com:ruanyf/css-modules-demos.git
```

Next, install the dependencies.

```bash
$ cd css-modules-demos
$ npm install
```

Run the first demo.

```bash
$ npm run demo01
```

Open http://localhost:8080 , see the result.

Then run demo02, demo03, ... That's all.

## Index

1. Local Scope
1. Global Scope
1. Customized Hash Class Name
1. Composing CSS Classes
1. Import Other Module
1. Exporting Values Variables

## Demo01: Local Scope

We all know that CSS rules are global. The only way of making a local-scoped rule is to give the CSS selector an absolutely unique class name, so no other selectors will have collisions with it. That is exactly what CSS Modules do.

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

In above codes, we import a CSS object `style` from `App.css`, and use a class names as its properties such as `style.title`.

The following is a very plain `App.css`.

```css
.title {
  color: red;
}
```

The build tool will compile the class name into a hash string.

App.js

```html
<h1 class="_3zyde4l1yATCOkgn-DBWEL">
  Hello World
</h1>
```

App.css

```css
._3zyde4l1yATCOkgn-DBWEL {
  color: red;
}
```

So this rule is only effective to the `App` component.

CSS Modules provide [plugins](https://github.com/css-modules/css-modules/blob/master/docs/get-started.md) for different build tools. Here I use Webpack's [`css-loader`](https://github.com/webpack/css-loader#css-modules), since it support CSS Modules best and is easy to use. If you don't know Webpack, please learn my tutorial [Webpack-Demos](https://github.com/ruanyf/webpack-demos).

The following is our `webpack.config.js`.

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

The syntax `:global(.className)` can be used to declare an global selector explicitly. CSS Modules will not compile this class name into hash string.

First, add a global class into `App.css`.

```css
.title {
  color: red;
}

:global(.title) {
  color: green;
}
```

Then use the global CSS class in `App.js`.

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

CSS Modules also have a explicit local scope syntax `:local(.className)` which is equivalent to `.className`. So the above `App.css` may be written in another form.

```css
:local(.title) {
  color: red;
}

:global(.title) {
  color: green;
}
```

## Demo03 Customized Hash Class Name

In the above demos, `.title` was hashed into `._3zyde4l1yATCOkgn-DBWEL`. CSS-loader's default hash algorithm is `[hash:base64]`.

You could customize it in `webpack.config.js`.

```javascript
// webpack.config.js
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

In CSS Modules, a selector could inherit another selector's rules, which is called ["composition"](https://github.com/css-modules/css-modules#composition).

We let `.title` inherit `.className` in `App.css`.

```css
.className {
  background-color: blue;
}

.title {
  composes: className;
  color: red;
}
```

`App.js` doesn't change.

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

In fact, `App.css` is converted into the following codes.

```css
._2DHwuiHWMnKTOYG45T0x34 {
  color: red;
}

._10B-buq6_BEOTOl9urIjf8 {
  background-color: blue;
}
```

And the HTML element `h1`'s class names look like `<h1 class="_2DHwuiHWMnKTOYG45T0x34 _10B-buq6_BEOTOl9urIjf8">`,

## Demo05 Import Other Module

You also could import another module into the current module.

`another.css`

```css
.className {
  background-color: blue;
}
```

`App.css`

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

You could use variables in CSS Modules. This feature is provided by PostCSS and the [postcss-modules-values](https://github.com/css-modules/postcss-modules-values) plugin.

```bash
$ npm install --save postcss-loader postcss-modules-values
```

First, add `postcss-loader` into `webpack.config.js`.

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

Next, set up your values/variables in `colors.css`.

```css
@value blue: #0c77f8;
@value red: #ff0000;
@value green: #aaf200;
```

Then import them into `App.css`.

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
