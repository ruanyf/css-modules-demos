# CSS Modules Demos

A collection of simple demos of [CSS Modules](https://github.com/css-modules/css-modules).

If you don't know, CSS Modules implements local scope and module dependencies in CSS.

## Usage

## Demo01 local scope

The query parameter `modules` of [`css-loader`](https://github.com/webpack/css-loader#css-modules) enables the CSS Modules spec (`css-loader?modules`).

CSS Modules use local scoped CSS by default.

We have a `App.css` which is quite normal.

```css
.title {
  color: red;
}
```

Put `App.css` into our component `App.js`.

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

When run the demo, you should see the `h1` title in red.

```bash
$ npm run demo01
```

Open Chrome's developer tool, you could find the `style.title` compiled into a hash string.

```html
<h1 class="_3zyde4l1yATCOkgn-DBWEL">
  Hello World
</h1>
```

CSS selector is also compiled into hash string.

```css
._3zyde4l1yATCOkgn-DBWEL {
    color: red;
}
```

## demo02: Global Scope

The syntax `:global(.className)` can be used to declare an explicit global selector. CSS Modules will not compile this class into hash string.

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

You will see the `h1` title in green.

In addition, `:local(.className)` is equivalent to `.className` in CSS Modules. The above `App.css` may be written in another form.

```css
:local(.title) {
  color: red;
}

:global(.title) {
  color: green;
}
```

## demo03 Customized Hash class name

In the above demos, `.title` was hashed into `._3zyde4l1yATCOkgn-DBWEL`. The default hash algorithm is `[hash:base64]`.

We may customize it by Webpack's plugin [`css-loader`](https://github.com/webpack/css-loader) in `webpack.config.js`.

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

In above codes, the customized hashed className is `[path][name]---[local]---[hash:base64:5]`.

Run the demo.

```bash
$ npm run demo03
```

You will find `.title` hashed into `demo03-components-App---title---GpMto`.

## Demo04: Composing CSS classes

A CSS module may inherit another CSS module, which is called ["composition"](https://github.com/css-modules/css-modules#composition).

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

Our `App.js` doesn't change.

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

In fact, the CSS classes of `h1` is converted into `<h1 class="_2DHwuiHWMnKTOYG45T0x34 _10B-buq6_BEOTOl9urIjf8">`, and `App.css` is converted into the following codes.

```css
._2DHwuiHWMnKTOYG45T0x34 {
  color: red;
}

._10B-buq6_BEOTOl9urIjf8 {
  background-color: blue;
}
```

## Demo05 import another module

You also could import another module into the current module.

There is a `another.css`.

```css
.className {
  background-color: blue;
}
```

Now import `className` from `another.css` into `App.css`.

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

## Demo06 exporting values variables

You can export values with CSS Modules similar to using variables in less or sass.

PostCSS and the [postcss-modules-values](https://github.com/css-modules/postcss-modules-values) plugin are needed.

```bash
$ npm install --save postcss-loader postcss-modules-values
```

First, add `postcss-loader` into `webpack.config.js`.

```javascript

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

## License

MIT
