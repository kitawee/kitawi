import 'dart:async';

import 'package:view/components/error_view.dart';
import 'package:view/view.dart' as vw;
import 'package:view/view.dart';
import 'package:web/web.dart';

class SearchParams {
  SearchParams();

  /// The query string part of the URL
  static String? get(String key) {
    final value = window.location.hash.split('?').last.split('&').firstWhere(
          (element) => element.startsWith('$key='),
          orElse: () => '',
        );
    if (value.isNotEmpty) return value.split('=').last;
    return null;
  }

  /// All the query string parameters
  static Map<String, String> get all {
    final params = window.location.hash.split('?').last.split('&');
    final map = <String, String>{};
    for (final param in params) {
      final key = param.split('=').first;
      final value = param.split('=').last;
      map[key] = value;
    }
    return map;
  }

  /// Set a query string parameter
  static void set(String key, String value) {
    final params = window.location.hash.split('?');
    final query = params.length > 1 ? params.last : '';
    final newQuery = query.isEmpty ? '$key=$value' : '$query&$key=$value';
    window.location.hash = '#${params.first}?$newQuery';
  }
}

class MatchRoute {
  final vw.View view;

  MatchRoute(this.view);
}

class Route {
  final String path;
  final vw.View Function(Map<String, dynamic>) view;
  final Function()? beforeEnter;
  final Function()? afterEnter;

  Route({
    required this.path,
    required this.view,
    this.beforeEnter,
    this.afterEnter,
  });

  MatchRoute? match(String path) {
    if (this.path == path) return MatchRoute(view({}));

    if (this.path.contains(':')) {
      final parts = this.path.split('/');
      final pathParts = path.split('/');
      if (parts.length != pathParts.length) return null;

      for (int i = 0; i < parts.length; i++) {
        if (parts[i] != pathParts[i] && !parts[i].startsWith(':')) return null;
      }

      final params = <String, String>{};
      for (int i = 0; i < parts.length; i++) {
        if (parts[i].startsWith(':')) {
          params[parts[i].substring(1)] = pathParts[i];
        }
      }

      return MatchRoute(view(params));
    }

    return null;
  }
}

class Router {
  static void run({
    required List<Route> routes,
    String? initialRoute,
    debugMode = false,
    String? selector = '#app',
  }) {
    DEBUG = debugMode;
    final hash = window.location.hash;
    final path = hash.isEmpty ? (initialRoute ?? '/') : hash.substring(1);

    if (hash.isEmpty) {
      window.location.hash = path;
    }

    _pathStreamController.stream.listen((pathSettings) {
      MatchRoute? matchRoute;

      for (var route in routes) {
        final match = route.match(pathSettings.path);
        if (match != null) {
          matchRoute = match;
          break;
        }
      }

      if (matchRoute == null) {
        final errorString = "Route not found\n${pathSettings.path} not found";
        final StackTrace stackTrace = StackTrace.current;
        showErrorView(errorString, stackTrace: stackTrace);
        return;
      }

      final element = document.querySelector(selector!);
      if (element == null) {
        final errorString = "Your target element `$selector` was not found";
        final StackTrace stackTrace = StackTrace.current;
        showErrorView(errorString, stackTrace: stackTrace);
        return;
      }

      if (pathSettings.replace) {
        element.replaceChildren(matchRoute.view.render());
        return;
      }

      element.append(matchRoute.view.render());
    });

    // listen to popstate event
    window.onPopState.listen((event) {
      final path = window.location.hash.substring(1);

      //check if selector is present
      final element = document.querySelector(selector!);
      if (element == null) {
        document.getElementsByTagName('body').item(0)?.replaceChildren(
              vw.Div(id: selector, children: []).render(),
            );
      }

      _pathStreamController.add((path: path, replace: true));
    });

    String? pathToBeMatched;
    if (path.contains('?')) {
      pathToBeMatched = path.split('?').first;
    } else {
      pathToBeMatched = path;
    }

    _pathStreamController.add((path: pathToBeMatched, replace: false));
  }

  static void push(String path) {
    // clear Stack
    vw.Stack.clear();
    window.location.hash = path;

    if (path.contains('?')) {
      path = path.split('?').first;
    }

    final currentPath = window.location.hash.substring(1).split('?').first;
    if (currentPath == path) return;

    _pathStreamController.add((path: path, replace: true));
  }

  static void replace(String path) {
    // clear Stack
    vw.Stack.clear();
    window.location.replace('#$path');
    _pathStreamController.add((path: path, replace: true));
  }

  static void back() {
    // clear Stack
    vw.Stack.clear();
    window.history.back();
  }

  static void forward() {
    // clear Stack
    vw.Stack.clear();
    window.history.forward();
  }

  static void go(int index) {
    // clear Stack
    vw.Stack.clear();
    window.history.go(index);
  }

  static void clearStack() {
    vw.Stack.clear();
  }

  static void reload() {
    // clear Stack
    vw.Stack.clear();
    window.location.reload();
  }

  static final _pathStreamController =
      StreamController<({String path, bool replace})>.broadcast();
}

Future<void> inject(String path, [String? type = "js"]) async {
  final view = vw.Script(src: path);

  document.head?.append(view.render());
}

void showErrorView(String errorString, {StackTrace? stackTrace}) {
  if (!DEBUG) return;
  document.getElementsByTagName('body').item(0)?.append(
        errorView(errorString, stackTrace).render(),
      );
}
