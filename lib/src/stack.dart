import 'package:view/src/basic.dart';

class Stack {
  static final List<View> _stack = [];
  static List<View> get stack => _stack;

  static void push(View view) {
    _stack.add(view);
  }

  static View? pop() {
    if (_stack.isEmpty) return null;
    return _stack.removeLast();
  }

  static View peek() {
    return _stack.last;
  }

  static void clear() {
    _stack.clear();
  }

  static View get(View view) {
    return _stack.firstWhere((element) => element == view);
  }
}
