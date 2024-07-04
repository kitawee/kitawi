import 'package:view/view.dart';
import 'package:web/web.dart';

/// This class renders a view passing the [Reactive] instance to the builder function
///
/// This is useful for creating reactive elements that can be updated
///
/// Example:
/// ```dart
/// int counter = 0;
/// Reactive(
///   builder: (view) {
///     return Div(
///           children: [
///             Text("Counter: $counter"),
///             Button(
///               onPressed: (e) {
///                 counter++;
///                 view.refresh();
///               },
///               child: Text("Increment"),
///             ),
///           ],
///      );
///     },
/// );
/// ```
class Reactive extends View {
  final View Function(View) builder;

  Reactive({
    required this.builder,
    super.id,
    super.tag = 'div',
    super.className,
    super.style,
    super.onClick,
    super.onAfterRender,
    super.onBeforeRender,
  });

  @override
  Element render() {
    final element = super.render();

    element.append(builder(this).render());
    return element;
  }
}

/// This class renders a view passing the [Snapshot] instance to the builder functionx
///
/// This is useful for creating views that depend on a future or stream
class Snapshot<T> {
  /// The data of type [T] from the future or stream
  final T data;

  /// Whether the future or stream has an error
  final bool hasError;

  /// The error message if the future or stream has an error
  final String? error;
  Snapshot({
    required this.data,
    this.hasError = false,
    this.error,
  });
}

/// This class renders a view after a future has resolved
///
/// Example:
/// ```dart
/// Promise(
///  future: () => Future.delayed(Duration(seconds: 2), () => 42),
/// builder: (snapshot) {
///  if (snapshot.hasError) {
///   return Text("Error: ${snapshot.error}");
/// }
/// return Text("Data: ${snapshot.data}");
/// },
/// loading: Text("Loading..."),
/// error: (err, stackTrace) {
/// return Text("Error: $err");
/// },
/// );
/// ```
class Promise<T> extends View {
  /// The view to render after the future has resolved
  ///
  /// NOTE: do not call `view.refresh()` in the builder function unless
  /// an interaction has been initiated by the user
  ///
  final View Function(Snapshot<T>) builder;

  /// The future to resolve
  final Future<T> Function() future;

  /// The view to render while the future is loading
  final View? loading;

  /// The view to render if the future has an error
  final View Function(Object err, [StackTrace? stackTracce])? error;

  Promise({
    required this.builder,
    required this.future,
    this.loading,
    this.error,
    super.id,
    super.tag = 'div',
    super.className,
    super.style,
    super.onClick,
    super.onBeforeRender,
    super.onAfterRender,
  });

  @override
  Element render() {
    final element = super.render();

    if (loading != null) {
      element.append(loading!.render());
    }

    future().then((data) {
      final snapshot = Snapshot(data: data);

      loading?.remove();

      element.append(builder(snapshot).render());
    }).catchError((err, StackTrace stackTrace) {
      loading?.remove();

      if (error == null) {
        showErrorView(err.toString(), stackTrace: stackTrace);
        return;
      }

      if (error != null) {
        element.append(error!(err, stackTrace).render());
        return;
      }

      final snapshot =
          Snapshot(data: null, hasError: true, error: err) as Snapshot<T>;
      element.append(builder(snapshot).render());
    });
    return element;
  }
}

/// This class renders a view after a stream has resolved
///
/// Also see:
/// - [Promise]
/// - [Snapshot]
class Live<T> extends View {
  /// The view to render after the stream has resolved
  ///
  /// NOTE: do not call `view.refresh()` in the builder function unless
  /// an interaction has been initiated by the user
  ///
  final View Function(Snapshot<T>) builder;

  /// The stream to resolve
  ///
  /// Prefer using broadcast streams
  final Stream<T> Function() stream;

  /// The view to render while the stream is loading
  final View? loading;

  /// The view to render if the stream has an error
  final View Function(Object err, [StackTrace? stackTracce])? error;

  Live({
    required this.builder,
    required this.stream,
    this.loading,
    this.error,
    super.id,
    super.tag = 'div',
    super.className,
    super.style,
    super.onClick,
    super.onBeforeRender,
    super.onAfterRender,
  });

  @override
  Element render() {
    final element = super.render();

    if (loading != null) {
      element.append(loading!.render());
    }

    stream().listen((data) {
      final snapshot = Snapshot(data: data);

      loading?.remove();

      element.append(builder(snapshot).render());
    }).onError((err, StackTrace stackTrace) {
      loading?.remove();

      if (error != null) {
        element.append(error!(err, stackTrace).render());
        return;
      }

      final snapshot =
          Snapshot(data: null, hasError: true, error: err) as Snapshot<T>;
      element.append(builder(snapshot).render());
    });
    return element;
  }
}
