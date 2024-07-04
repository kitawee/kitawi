import 'package:view/src/stack.dart';
import 'package:view/view.dart' as view;
import 'package:web/web.dart';

class View {
  /// A unique identifier for the element
  final String? id;

  /// The tag name of the element
  final String? tag;

  /// The class name of the element
  final String? className;

  /// The style of the element
  final view.Style? style;

  /// The attributes of the element
  final List<View>? children;

  final void Function(Event)? onClick;
  final void Function(Event)? onDoubleClick;
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

  final void Function()? onBeforeRender;
  final void Function(View)? onAfterRender;

  View({
    this.id,
    this.tag = 'div',
    this.className,
    this.style,
    this.children,
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
    this.onBeforeRender,
    this.onAfterRender,
  });

  set tag(String? tag) {
    this.tag = tag;
  }

  // The current Element
  Element? element;

  Element render() {
    element ??= document.createElement(tag!);

    if (onBeforeRender != null) {
      onBeforeRender!();
    }

    if (id != null) {
      element!.id = id!;
    }

    if (className != null) {
      element!.className = className!;
    }

    if (style != null) {
      element!.setAttribute('style', style!.create());
    }

    if (children != null) {
      for (final child in children!) {
        element!.append(child.render());
      }
    }

    if (onClick != null) {
      element!.onClick.listen(onClick!);
    }

    if (onDoubleClick != null) {
      element!.onDoubleClick.listen(onDoubleClick!);
    }

    if (onContextMenu != null) {
      element!.onContextMenu.listen(onContextMenu!);
    }

    if (onDragStart != null) {
      element!.onDragStart.listen(onDragStart!);
    }

    if (onDrag != null) {
      element!.onDrag.listen(onDrag!);
    }

    if (onDragEnd != null) {
      element!.onDragEnd.listen(onDragEnd!);
    }

    if (onDragEnter != null) {
      element!.onDragEnter.listen(onDragEnter!);
    }

    if (onDragOver != null) {
      element!.onDragOver.listen(onDragOver!);
    }

    if (onDragLeave != null) {
      element!.onDragLeave.listen(onDragLeave!);
    }

    if (onDrop != null) {
      element!.onDrop.listen(onDrop!);
    }

    if (onKeyDown != null) {
      element!.onKeyDown.listen(onKeyDown!);
    }

    if (onKeyPress != null) {
      element!.onKeyPress.listen(onKeyPress!);
    }

    if (onKeyUp != null) {
      element!.onKeyUp.listen(onKeyUp!);
    }

    if (onMouseOver != null) {
      element!.onMouseOver.listen(onMouseOver!);
    }

    if (onMouseOut != null) {
      element!.onMouseOut.listen(onMouseOut!);
    }

    if (onMouseDown != null) {
      element!.onMouseDown.listen(onMouseDown!);
    }

    if (onMouseUp != null) {
      element!.onMouseUp.listen(onMouseUp!);
    }

    if (onMouseMove != null) {
      element!.onMouseMove.listen(onMouseMove!);
    }

    if (onInput != null) {
      element!.onInput.listen(onInput!);
    }

    if (onChange != null) {
      element!.onChange.listen(onChange!);
    }

    if (onSubmit != null) {
      element!.onSubmit.listen(onSubmit!);
    }

    if (onFocus != null) {
      element!.onFocus.listen(onFocus!);
    }

    if (onBlur != null) {
      element!.onBlur.listen(onBlur!);
    }

    if (onScroll != null) {
      element!.onScroll.listen(onScroll!);
    }

    if (onAfterRender != null) {
      onAfterRender!(this);
    }

    Stack.push(this);

    return element!;
  }

  void refresh() {
    final oldElement = element;
    element = null;
    oldElement?.replaceWith(render());
  }

  void remove() {
    element!.remove();
  }

  void append(View view) {
    element!.append(view.render());
  }

  @override
  String toString() {
    return """
  View: $tag 
  Next: $children
""";
  }
}

class Div extends View {
  Div({
    super.id,
    super.tag = 'div',
    super.className,
    super.style,
    super.onClick,
    super.onAfterRender,
    super.onBeforeRender,
    super.children,
  });

  @override
  Element render() {
    final element = super.render();

    return element;
  }
}

class Text extends View {
  final String text;

  Text(
    this.text, {
    super.id,
    super.onClick,
    super.tag = 'span',
    super.className,
    super.style,
  });

  @override
  Element render() {
    final element = super.render();
    element.text = text;
    return element;
  }
}

class Image extends View {
  final String src;
  final String? alt;

  Image({
    required this.src,
    this.alt,
    super.id,
    super.tag = 'img',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render();
    element.setAttribute('src', src);
    element.setAttribute('alt', alt ?? '');
    return element;
  }
}

enum LinkTarget { blank, self, parent, top }

class Link extends View {
  final String to;
  final LinkTarget? target;
  final View child;

  Link({
    required this.to,
    required this.child,
    this.target,
    super.id,
    super.tag = 'a',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render();
    element.setAttribute('href', to);
    if (target != null) {
      element.setAttribute('target', target.toString().split('.').last);
    }
    element.append(child.render());
    return element;
  }

  static open(String url, {LinkTarget? target = LinkTarget.self}) {
    window.open(url, target!.name);
  }
}

class Button extends View {
  final View child;
  final Function(Event)? onPressed;

  Button({
    required this.child,
    this.onPressed,
    super.id,
    super.tag = 'button',
    super.className,
    super.style,
  });

  @override
  Element render() {
    final element = super.render();
    element.append(child.render());
    if (onPressed != null) {
      element.onClick.listen((event) {
        onPressed?.call(event);
      });
    }
    return element;
  }
}

enum TextInpuType { text, password, email, number, tel, url, date }

class TextInput extends View {
  final String? placeholder;
  final String? value;
  final TextInpuType? type;
  final bool? autoFocus;
  final int? maxLength;
  final bool? disabled;
  final String? name;
  final void Function(
    String,
  )? onChanged;
  final void Function(Event)? onSubmitted;

  TextInput({
    this.name,
    this.placeholder,
    this.value,
    this.onChanged,
    this.onSubmitted,
    super.id,
    super.tag = 'input',
    super.className,
    super.style,
    this.disabled = false,
    this.type = TextInpuType.text,
    this.autoFocus = false,
    this.maxLength,
  });

  @override
  Element render() {
    final element = super.render() as HTMLInputElement;
    if (name != null) element.setAttribute('name', name!);
    element.setAttribute('placeholder', placeholder ?? '');
    element.setAttribute('value', value ?? '');
    element.setAttribute('type', type.toString().split('.').last);
    element.disabled = disabled!;
    element.autofocus = autoFocus!;
    if (maxLength != null) {
      element.setAttribute('maxlength', maxLength.toString());
    }

    // if tag is textarea and value is not null, set the value as textContent
    if (tag == 'textarea' && value != null) {
      element.text = value!;
    }

    element.onInput.listen((inputEvent) {
      if (maxLength != null && element.value.length > maxLength!) {
        element.value = element.value.substring(0, maxLength!);
      }

      final changeEvent = element.value;

      onChanged?.call(changeEvent);
      focus();
    });

    element.onKeyDown.listen((keyDownEvent) {
      if (keyDownEvent.key == 'Enter') {
        onSubmitted!(keyDownEvent);
      }
    });
    return element;
  }

  void focus() {
    if (super.id != null) {
      final element = document.getElementById(super.id!);
      if (element != null) {
        if (type == TextInpuType.number) {
          element.setAttribute('type', 'text');
        }
        (element as HTMLInputElement).setSelectionRange(
          element.value.length,
          element.value.length,
        );
        element.focus();
        if (type == TextInpuType.number) {
          element.setAttribute('type', 'number');
        }
      }
      return;
    }

    final selector = _constructSelector(element!);
    final matchedElement = document.querySelector(selector);
    if (matchedElement != null) {
      if (type == TextInpuType.number) {
        matchedElement.setAttribute('type', 'text');
      }

      (matchedElement as HTMLInputElement).setSelectionRange(
        matchedElement.value.length,
        matchedElement.value.length,
      );

      matchedElement.focus();

      if (type == TextInpuType.number) {
        matchedElement.setAttribute('type', 'number');
      }
    }
  }

  String _constructSelector(Element element) {
    final buffer = StringBuffer(element.tagName.toLowerCase());

    for (var i = 0; i < element.attributes.length; i++) {
      final name = element.attributes.item(i)?.name;
      final value = element.attributes.item(i)?.value;
      if (name != 'value') {
        buffer.write('[$name="$value"]');
      }
    }

    return buffer.toString();
  }
}

class DropdownItem {
  final String value;
  final View child;

  DropdownItem({required this.value, required this.child});

  Element render() {
    final element = document.createElement('option');
    element.setAttribute('value', value);
    element.append(child.render());
    return element;
  }
}

class Dropdown extends View {
  final List<DropdownItem> items;
  final String? initialValue;
  final Function(String)? onChanged;

  Dropdown({
    required this.items,
    this.initialValue,
    this.onChanged,
    super.id,
    super.tag = 'select',
    super.className,
    super.style,
  });

  @override
  Element render() {
    final element = super.render() as HTMLSelectElement;

    if (initialValue != null) {
      element.value = initialValue!;
    }

    for (final item in items) {
      var itemElement = item.render() as HTMLOptionElement;

      if (item.value == initialValue) {
        element.selectedIndex = items.indexOf(item);
        itemElement.selected = true;
      }

      element.append(itemElement);
    }

    element.onChange.listen((event) {
      onChanged?.call(items[element.selectedIndex].value);
    });
    return element;
  }
}

class Checkbox extends View {
  final bool? checked;
  final Function(bool)? onChanged;

  Checkbox({
    this.checked,
    this.onChanged,
    super.id,
    super.tag = 'input',
    super.className,
    super.style,
  });

  @override
  Element render() {
    final element = super.render() as HTMLInputElement;
    element.setAttribute('type', 'checkbox');
    element.checked = checked ?? false;
    element.onChange.listen((event) {
      onChanged!(element.checked);
    });
    return element;
  }
}

class Radio extends View {
  final bool? checked;
  final Function(bool)? onChanged;

  Radio({
    this.checked,
    this.onChanged,
    super.id,
    super.tag = 'input',
    super.className,
    super.style,
  });

  @override
  Element render() {
    final element = super.render() as HTMLInputElement;
    element.setAttribute('type', 'radio');
    element.checked = checked ?? false;
    element.onChange.listen((event) {
      onChanged?.call(element.checked);
    });
    return element;
  }
}

class Hr extends View {
  Hr({
    super.id,
    super.tag = 'hr',
    super.className,
    super.style,
    super.onClick,
  });
}

enum ListStyle { ordered, unordered }

enum ListType {
  disc,
  circle,
  square,
  decimal,
  decimalLeadingZero,
  lowerAlpha,
  lowerRoman,
  upperAlpha,
  upperRoman
}

class ListBuilder<T> extends View {
  final View Function(int) builder;
  final List<T> items;
  final ListStyle? listStyle;
  final ListType? type;

  ListBuilder({
    required this.builder,
    required this.items,
    super.id,
    super.className,
    super.style,
    super.onClick,
    this.listStyle = ListStyle.unordered,
    this.type = ListType.disc,
    super.tag = 'ul',
  });

  @override
  Element render() {
    final element = super.render();

    if (type != null) {
      final existingStyle = element.getAttribute('style');
      element.setAttribute(
        'style',
        existingStyle != null
            ? '$existingStyle; list-style-type: ${type.toString().split('.').last};'
            : 'list-style-type: ${type.toString().split('.').last};',
      );
    }

    for (var i = 0; i < items.length; i++) {
      final item = document.createElement('li');
      item.append(builder(i).render());
      element.append(item);
    }
    return element;
  }
}

class Table extends View {
  final List<View> headers;
  final List<List<View>> rows;
  final String? headerStyle;
  final String? rowStyle;

  Table({
    required this.headers,
    required this.rows,
    super.id,
    super.tag = 'table',
    super.className,
    super.style,
    super.onClick,
    this.headerStyle,
    this.rowStyle,
  });

  @override
  Element render() {
    final element = super.render();

    final thead = document.createElement('thead');

    if (headerStyle != null) {
      thead.setAttribute('style', headerStyle!);
    }

    final tbody = document.createElement('tbody');

    final headerRow = document.createElement('tr');
    for (final header in headers) {
      final th = document.createElement('th');
      th.appendChild(header.render());
      headerRow.append(th);
    }

    thead.append(headerRow);

    for (final row in rows) {
      final tr = document.createElement('tr');

      if (rowStyle != null) {
        tr.setAttribute('style', rowStyle!);
      }

      for (final cell in row) {
        final td = document.createElement('td');
        td.appendChild(cell.render());
        tr.append(td);
      }
      tbody.append(tr);
    }

    element.append(thead);
    element.append(tbody);

    return element;
  }
}

class Icon extends View {
  final String? icons;
  Icon({
    this.icons,
    super.id,
    super.tag = 'i',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render();
    if (icons != null) {
      element.innerHTML = icons!.toString();
    }

    return element;
  }
}

class I extends View {
  I({
    super.id,
    super.tag = 'i',
    super.className,
    super.style,
    super.onClick,
    super.children,
  });
}
