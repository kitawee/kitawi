import "dart:js_interop";

import "package:kitawi/src/utils/ref.dart";
import "package:web/web.dart";

abstract class Component {
  /// The tag name of the element.
  final String tag;

  /// The ref of the element.
  Ref? ref;

  /// The id of the element.
  final String? id;

  /// The attributes of the element.
  final Map<String, String>? attributes;

  /// The style of the element.
  final Map<String, dynamic>? style;

  /// Css class name of the element.
  final String? className;

  /// The children of the element.
  final List<Component>? children;

  /// Callback for the `click` event.
  final void Function(Event)? onClick;

  /// Callback for the `doubleclick` event.
  final void Function(Event)? onDoubleClick;

  /// Callback for the `contextmenu` event.
  final void Function(Event)? onContextMenu;

  final void Function(Event)? onDragStart;
  final void Function(Event)? onDrag;
  final void Function(Event)? onDragEnd;
  final void Function(Event)? onDragEnter;
  final void Function(Event)? onDragOver;
  final void Function(Event)? onDragLeave;
  final void Function(Event)? onDrop;

  final void Function(Event)? onKeyDown;
  final void Function(Event)? onKeyPress;
  final void Function(Event)? onKeyUp;

  final void Function(Event)? onMouseOver;
  final void Function(Event)? onMouseOut;
  final void Function(Event)? onMouseDown;
  final void Function(Event)? onMouseUp;
  final void Function(Event)? onMouseMove;

  final void Function(Event)? onInput;
  final void Function(Event)? onChange;
  final void Function(Event)? onSubmit;

  final void Function(Event)? onFocus;
  final void Function(Event)? onBlur;

  final void Function(Event)? onScroll;
  final void Function(Event)? onWheel;

  /// This is the base building block for all components.
  ///
  /// It inherits the behavior of [Element] and adds additional functionality
  /// such as rendering and updating the component.
  ///
  /// Components are the building blocks of a UI. They can be composed together
  /// to create complex UIs.
  Component({
    this.id,
    this.tag = "div",
    this.ref,
    this.attributes,
    this.children,
    this.className,
    this.style,
    this.onClick,
    this.onDoubleClick,
    this.onContextMenu,
    this.onDragStart,
    this.onDrag,
    this.onDragEnd,
    this.onDragEnter,
    this.onDragOver,
    this.onDragLeave,
    this.onDrop,
    this.onKeyDown,
    this.onKeyPress,
    this.onKeyUp,
    this.onMouseOver,
    this.onMouseOut,
    this.onMouseDown,
    this.onMouseUp,
    this.onMouseMove,
    this.onInput,
    this.onChange,
    this.onSubmit,
    this.onFocus,
    this.onBlur,
    this.onScroll,
    this.onWheel,
  });

  Element? element;

  /// Appends an attribute to the element.
  void _renderAttributes(Element element) {
    if (attributes == null) return;

    for (final entry in attributes!.entries) {
      if (entry.value.isEmpty) continue;
      element.setAttribute(entry.key, entry.value);
    }
  }

  /// Set event listeners for the element.
  void _registerEventListeners(Element element) {
    element.onClick.listen(onClick);
    element.onDoubleClick.listen(onDoubleClick);
    element.onContextMenu.listen(onContextMenu);
    element.onDragStart.listen(onDragStart);
    element.onDrag.listen(onDrag);
    element.onDragEnd.listen(onDragEnd);
    element.onDragEnter.listen(onDragEnter);
    element.onDragOver.listen(onDragOver);
    element.onDragLeave.listen(onDragLeave);
    element.onDrop.listen(onDrop);
    element.onKeyDown.listen(onKeyDown);
    element.onKeyPress.listen(onKeyPress);
    element.onKeyUp.listen(onKeyUp);
    element.onMouseOver.listen(onMouseOver);
    element.onMouseOut.listen(onMouseOut);
    element.onMouseDown.listen(onMouseDown);
    element.onMouseUp.listen(onMouseUp);
    element.onMouseMove.listen(onMouseMove);
    element.onInput.listen(onInput);
    element.onChange.listen(onChange);
    element.onSubmit.listen(onSubmit);
    element.onFocus.listen(onFocus);
    element.onBlur.listen(onBlur);
    element.onScroll.listen(onScroll);
    element.onWheel.listen(onWheel);
  }

  /// Creates an HTML Element represention of [Component].
  Element render() {
    // Create the element with the tag name.
    element ??= document.createElement(tag);

    if (element == null) {
      throw Exception("Could not create element with tag name: $tag");
    }

    if (id != null) {
      element?.id = id!;
    }

    if (className != null) {
      element?.className = className!;
    }

    if (children != null) {
      for (final child in children!) {
        element!.append(child.render());
      }
    }

    if (style != null) {
      final styleString = style!.entries
          .map((entry) => "${entry.key}: ${entry.value};")
          .join(" ");

      element!.setAttribute('style', styleString);
    }

    _renderAttributes(element!);

    _registerEventListeners(element!);

    if (ref != null) {
      ref!.set(element);
    }

    return element!;
  }

  /// Re-renders the component.
  void update() {
    final oldElement = element;
    element = null;
    oldElement?.replaceWith(render());
  }

  void addEventListener(String event, void Function(Event) callback,
      {Map<String, String>? options}) {
    element?.addEventListener(
      event,
      callback as JSFunction,
      options as JSAny,
    );
  }

  void removeEventListener(String event, void Function(Event) callback,
      {Map<String, String>? options}) {
    element?.removeEventListener(
      event,
      callback as JSFunction,
      options as JSAny,
    );
  }

  void append(Component child) {
    element?.append(child.render());
  }

  void remove() {
    element?.remove();
  }
}
