import 'package:web/web.dart';

/// Handle query parameters
///
/// ```dart
/// import 'package:view/view.dart';
///
/// ...
/// Query.get('key');
/// Query.set('key', 'value');
/// Query.all;
/// ...
/// ```

class Query {
  /// Get all query parameters
  static Map<String, String> get all {
    final query = window.location.hash.split('?').last;
    final Map<String, String> params = {};

    if (query.isNotEmpty) {
      query.split('&').forEach((element) {
        final split = element.split('=');
        params[split[0]] = split[1];
      });
    }

    return params;
  }

  /// Get a query parameter
  static String get(String key) {
    return all[key] ?? '';
  }

  /// Set a query parameter
  static void set(String key, String value) {
    final params = all;
    params[key] = value;

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    window.history.pushState({} as dynamic, '', '?$query');
  }
}
