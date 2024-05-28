# Views

Views is a Dart web library for building web user interfaces. It is inspired by React and Flutter, and it is designed to be simple, fast, and easy to use.

It's highly customizable and can be used with any Dart package that can run on the web.

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  views:
    git:
      url: https://github.com/bryanbill/Views.git
      ref: master
```

## Usage

```dart
import 'package:views/views.dart';

void main() => Router.run(
    routes: [
        Route(
          path: '/',
          view: (param) => Text('Hello, world!'),
        ),
    ]
)
```

## Components

Views is made to be simple and easy to use. It has a few basic components that you can use to build your web app.
We have provided basic web elements - Views, out of the box that you can use to build your web app.

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

Views comes with a simple router that you can use to navigate between different views in your web app.

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

`param` is a map of query parameters that you can use to pass data between views.

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

Views provide a simple wrapper around the `window` object that you can use to access the browser's window object.
Currently, it only provides support for Local Storage.

```dart
LocalStorage.setItem('key', 'value');
LocalStorage.getItem('key');
```

And that's it! You're ready to start building your web app with Views.

## Contributing

We welcome contributions to Views

## License

Views is licensed under the MIT License.
