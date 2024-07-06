import 'dart:async';
import 'package:web/web.dart';

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
