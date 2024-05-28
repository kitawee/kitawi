import 'package:atomix/views.dart';

class Event {
  final String? value;
  final View? target;
  Event({this.value, this.target});
}

class MouseEnter extends Event {
  MouseEnter({super.value, super.target});
}
