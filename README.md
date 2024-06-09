# View - A Dart Web Library

![View](https://img.shields.io/badge/View-0.3.1-teal)

View is a Dart web library for building web user interfaces. It is inspired by React and Flutter, and it is designed to be simple, fast, and easy to use.

It's highly customizable and can be used with any Dart package that can run on the web.

The project can be compiled to wasm for Chromium based browsers, others use the dart2js compiler. See Issue [Wasm-GC WebAssembly Garbage Collection Proposal](https://bugs.webkit.org/show_bug.cgi?id=247394)

## Installation

1. Using the View CLI:

```bash
dart pub global activate --source git https://github.com/bryanbill/view.git
```

The run the following command to create a new project:

```bash
vw new my_project
```

Get the dependencies:

```bash
cd my_project
vw get
```

Add dependencies:

```bash
vw get http
```

Run the project:

```bash
vw run
```

Build the project:

```bash
vw build
# or
vw build -o dist
```

2. As a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  view:
    git:
      url: https://github.com/bryanbill/view.git
```

With this method, you have to handle the build process yourself.

## Contributing

We welcome contributions to view

## License

view is licensed under the MIT License.
