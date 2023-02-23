import 'package:kitawi/src/basic.dart';

/// NOTE: This is a work in progress.
///
///
/// The [Scaffold] class provides a basic layout structure for a page.
/// It consists of a [navbar], [body], [sidebar], [footer], [drawer] and
/// [floatingActionButton].
/// The [Scaffold] class is a [Widget] class.
class Scaffold extends StatelessWidget {
  final Widget body;
  final Widget? navbar;
  final Widget? sidebar;
  final Widget? footer;
  final Widget? drawer;
  final Widget? floatingActionButton;

  Scaffold(
      {required this.body,
      this.navbar,
      this.sidebar,
      this.footer,
      this.drawer,
      this.floatingActionButton});

  @override
  Widget build() {
    return Container(
        width: Size().width,
        constraints: BoxConstraints(
          minHeight: Size().height,
        ),
        decoration: Decoration(
          color: Theme().mode == ThemeMode.light ? Colors.white : Colors.grey24,
        ),
        child: Row(
          children: [
            sidebar ?? Container(height: 0, width: 0),
            Expanded(
              child: Column(
                children: [
                  navbar ?? Container(),
                  body,
                  footer ?? Container(),
                ],
              ),
            ),
          ],
        ));
  }
}
