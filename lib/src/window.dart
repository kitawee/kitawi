/// Wrapper for the window object.
library window;

import 'package:kitawi/models/v_file.dart';
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

class Alert {
  static void show(String message) {
    window.alert(message);
  }

  static void confirm(String message, void Function(bool) callback) {
    final result = window.confirm(message);
    callback(result);
  }

  static void prompt(
      String message, String defaultValue, void Function(String?) callback) {
    final result = window.prompt(message, defaultValue);
    callback(result);
  }
}

class FilePicker {
  static void pickFile(
    void Function(VFile file) callback, {
    bool multiple = false,
  }) {
    final input = window.document.createElement('input') as HTMLInputElement;
    input.type = 'file';
    input.accept = '*/*';
    input.style.display = 'none';
    input.onChange.listen((event) async {
      final file = input.files!.item(0);
      if (file != null) {
        callback(await VFile.fromFile(file));
      }
    });
    window.document.body!.append(input);
    input.click();
  }
}
