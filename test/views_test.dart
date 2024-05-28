import 'package:view/view.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' as web;

void main() {
  group('View tests', () {
    test("- view", () {
      final view = View();

      final element = view.render();
      final expected = web.document.createElement("div");

      expect(element.outerHTML, expected.outerHTML);
    });

    test("- div with children", () {
      final view = Div(children: [
        View(),
        View(),
        View(),
      ]);

      final element = view.render();
      expect(element.children.length, 3);
    });

    test("- text", () {
      final view = Text("Hello, World!");

      final element = view.render();
      expect(element.textContent, "Hello, World!");
    });

    test("- div with text", () {
      final view = Div(children: [
        Text("Hello, World!"),
      ]);

      final element = view.render();
      expect(element.children.length, 1);
      expect(element.children.item(0)!.textContent, "Hello, World!");
    });

    test("- image", () {
      final view =
          Image(src: "https://via.placeholder.com/150", alt: "Placeholder");

      final element = view.render();
      expect(element.outerHTML,
          "<img src=\"https://via.placeholder.com/150\" alt=\"Placeholder\">");
    });

    // TODO: Add more tests
  });
}
