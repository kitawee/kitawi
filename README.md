# View

View is a Dart web library for building web user interfaces. It is inspired by React and Flutter, and it is designed to be simple, fast, and easy to use.

It's highly customizable and can be used with any Dart package that can run on the web.

The project can be compiled to wasm for Chromium based browsers, others use the dart2js compiler. See Issue [Wasm-GC WebAssembly Garbage Collection Proposal](https://bugs.webkit.org/show_bug.cgi?id=247394)

## Installation

Create a new Dart web project using the following command:

```bash
dart create -t web my_project
```

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  view:
    git:
      url: https://github.com/bryanbill/view.git
      ref: master
```

## Usage

```dart
import 'package:view/view.dart';

void main() => Router.run(
    routes: [
        Route(
          path: '/',
          view: (param) => Text('Hello, world!'),
        ),
    ]
)
```

## Running the project

To run the project, you need to have enabled the `webdev` package.

You can do this by running the following command:

```bash
# Enable webdev
dart pub global activate webdev

# Run the project in Dev mode
webdev serve --auto refresh

# Compile the project for production

# Compile to wasm
dart compile wasm web/main.dart -o site/main.wasm

# Compile to js as a fallback for Safari
dart2js -m -o site/main.js web/ios.fb.js

# Copy your assets and statics to the site folder
cp web/index.html web/styles.css site/ && cp -r web/assets site/
```

Create a file `site/main.dart.js` and add the following code:

```js
(async function () {
    const isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream;
    const isSafari = navigator.vendor && navigator.vendor.indexOf('Apple') > -1;
    if (isIOS || isSafari) {
        runDartJs();
        return;
    }

    let dart2wasm_runtime;
    let moduleInstance;
    try {
        const dartModulePromise = WebAssembly.compileStreaming(fetch('main.wasm'));
        const imports = {};
        dart2wasm_runtime = await import('./main.mjs');
        moduleInstance = await dart2wasm_runtime.instantiate(dartModulePromise, imports);
    } catch (exception) {
        console.error(`Failed to fetch and instantiate wasm module: ${exception}`);
        console.error('See https://dart.dev/web/wasm for more information.');
    }

    if (moduleInstance) {
        try {
            await dart2wasm_runtime.invoke(moduleInstance);
        } catch (exception) {
            console.error(`Exception while invoking test: ${exception}`);
        }
    }
})();

function runDartJs() {
    import('./ios.fb.js').then(module => {
        console.log('Running Dart code in JavaScript on iOS');
    });
}
```

This code will check if the browser is Safari or iOS and run the Dart code in JavaScript.

## Components

View is made to be simple and easy to use. It has a few basic components that you can use to build your web app.
We have provided basic web elements - view, out of the box that you can use to build your web app.

You can also create your own components by extending the `View` class.

```dart
class MyComponent extends View {
  final String text;

    MyComponent({
        this.text,
        super.tag = 'my-component',
    });
  @override
  VNode render() {
    final element = super.render();
    element.text = text;
    return element;
  }
}
```

## Router

view comes with a simple router that you can use to navigate between different view in your web app.

```dart
void main() => Router.run(
    routes: [
        Route(
          path: '/',
          view: (param) => Text('Hello, world!'),
        ),
    ]
)
```

`param` is a map of query parameters that you can use to pass data between view.

Example:
A path like `/user/:id` will have a `param` map with a key of `id`.

`SearchParams` is a helper class that you can use to get query parameters from the URL.

```dart
void main() => Router.run(
    routes: [
        Route(
          path: '/user/:id',
          view: (param) => Text('User ID: ${param['id']} ${SearchParams.get('name')}'),
        ),
    ]
)
```

## Window

view provide a simple wrapper around the `window` object that you can use to access the browser's window object.
Currently, it only provides support for Local Storage.

```dart
LocalStorage.setItem('key', 'value');
LocalStorage.getItem('key');
```

And that's it! You're ready to start building your web app with view.

## Contributing

We welcome contributions to view

## License

view is licensed under the MIT License.
