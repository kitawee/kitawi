import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:kitawi/components/error_view.dart';
import 'package:kitawi/view.dart' as vw;

import 'package:web/web.dart';

import 'apis.dart';

class MatchRoute {
  final vw.Route route;
  final Map<String, String> params;
  MatchRoute(this.route, {this.params = const {}});
}

class Route {
  final String path;
  final vw.View Function(Map<String, dynamic>) view;
  final Function(Map<String, dynamic> params)? beforeRender;
  final Function(Map<String, dynamic> params, [vw.View? view])? afterRender;

  Route({
    required this.path,
    required this.view,
    this.beforeRender,
    this.afterRender,
  });

  MatchRoute? match(String path) {
    if (this.path == path) return MatchRoute(this);

    if (path.contains('?')) {
      path = path.split('?').first;
    }

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

      return MatchRoute(this, params: params);
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

      if (matchRoute.route.beforeRender != null) {
        matchRoute.route.beforeRender!(matchRoute.params);
      }

      if (pathSettings.replace) {
        element
            .replaceChildren(matchRoute.route.view(matchRoute.params).render());
        return;
      }

      final view = matchRoute.route.view(matchRoute.params);
      final routeElement = view.render();

      element.append(routeElement);

      // get ast of the routeElement
      final ast = parseAST(routeElement);

      // attach it to window object
      window.setProperty('view' as JSAny, jsonEncode(ast) as JSAny);

      if (matchRoute.route.afterRender != null) {
        matchRoute.route.afterRender!(
          matchRoute.params,
          view,
        );
      }
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

// Debug Utils

// Error View
void showErrorView(String errorString, {StackTrace? stackTrace}) {
  if (!DEBUG) return;
  document.getElementsByTagName('body').item(0)?.append(
        errorView(errorString, stackTrace).render(),
      );
}

// AST
Map<String, dynamic> parseAST(Element element) {
  // create the ast from element
  Map<String, dynamic> ast = {};

  // get the tag name
  ast['tag'] = element.tagName.toLowerCase();
  ast['attributes'] = {};

  // get the attributes
  for (var index = 0; index < element.attributes.length; index++) {
    ast['attributes'][element.attributes.item(index)?.name] =
        element.attributes.item(index)?.value;
  }

  // remove null attributes
  (ast['attributes'] as Map)
      .removeWhere((key, value) => value == null || key == null);

  // get the children
  ast['children'] = [];

  for (var index = 0; index < element.children.length; index++) {
    ast['children'].add(parseAST(element.children.item(index)!));
  }

  ast['innerHTML'] = element.innerHTML;

  ast['computedStyle'] = window.getComputedStyle(element).cssText;

  return ast;
}
