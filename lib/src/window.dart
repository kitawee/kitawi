/// Wrapper for the window object.
library window;

import 'package:web/web.dart';

class LocalStorage {
  static void setItem(String key, String value) {
    window.localStorage[key] = value;
  }

  static String? getItem(String key) {
    return window.localStorage[key];
  }

  static void removeItem(String key) {
    window.localStorage.removeItem(key);
  }
}
