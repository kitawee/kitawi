import 'package:view/view.dart';
import 'package:web/web.dart';

class Reactive extends View {
  final View Function(View) builder;

  Reactive({
    required this.builder,
    required super.id,
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

class Snapshot<T> {
  final T data;
  final bool hasError;
  final String? error;
  Snapshot({
    required this.data,
    this.hasError = false,
    this.error,
  });
}

class Promise<T> extends View {
  final View Function(Snapshot<T>) builder;
  final Future<T> Function() future;
  final View? loading;
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

class Live<T> extends View {
  final View Function(Snapshot<T>) builder;
  final Stream<T> Function() stream;
  final View? loading;
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
