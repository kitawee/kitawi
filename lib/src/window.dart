/// Wrapper for the window object.
library window;

import 'dart:async';
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

class VFile {
  final String name;
  final String type;
  final int size;

  /// Base64 encoding of this file
  final String data;

  VFile(this.name, this.type, this.size, this.data);

  static Future<VFile> fromFile(File file) async {
    final reader = FileReader();
    final completer = Completer<VFile>();
    reader.onLoadEnd.listen((event) {
      final result = reader.result as String;
      if (result.isEmpty || result.split(',').isEmpty) {
        throw Exception("Not a valid file");
      }

      final vfile = VFile(file.name, file.type, file.size, result);
      completer.complete(vfile);
    });
    reader.readAsDataURL(file);
    return completer.future;
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
