import 'dart:async';

import 'package:views/utils/device.dart';
import 'package:views/views.dart';
import 'package:web/web.dart';
import 'dart:js_interop' as js;
import 'event.dart' as event;

/// stack contains the order of the elements as they are rendered
class Stack {
  static final List<View> _stack = [];
  static List<View> get stack => _stack;

  static void push(View view) {
    _stack.add(view);
  }

  static View pop() {
    return _stack.removeLast();
  }

  static View peek() {
    return _stack.last;
  }

  static void clear() {
    _stack.clear();
  }
}

class View {
  final String? id;
  final String? tag;
  final StyleProp? style;
  final String? className;
  final void Function([event.Event? event])? beforeRender;
  final void Function([event.Event? event])? afterRender;
  final void Function(event.Event)? onUnmount;
  final void Function(View)? onClick;
  View({
    this.id,
    this.tag,
    this.className,
    this.style,
    this.onClick,
    this.beforeRender,
    this.afterRender,
    this.onUnmount,
  });

  Element? _element;
  Element? get element => _element;

  // call this after the element is rendered
  set id(String? id) => _element?.setAttribute('id', id ?? '');

  set tag(String? tag) => _element = document.createElement(tag ?? 'div');

  Element render() {
    _element ??= document.createElement(tag ?? 'div');

    if (beforeRender != null) {
      final _event = event.Event(target: this);
      beforeRender!(
        _event,
      );
    }

    _element = _element as Element;

    if (id != null) {
      _element!.setAttribute('id', id!);
    }

    if (style != null) {
      _element!.setAttribute('style', style!.create());
    }

    if (className != null) {
      _element!.setAttribute('class', className!);
    }

    if (onClick != null) {
      _element?.onClick.listen((event) {
        onClick!(this);
      });
    }

    if (afterRender != null) {
      final _event = event.Event(target: this);
      afterRender!(_event);
    }

    Stack.push(this);
    return _element!;
  }

  void remove() {
    print(_element?.id);
    _element?.remove();
    if (onUnmount != null) {
      onUnmount!(event.Event(target: this));
      print('onUnmount called');
    }
  }

  @override
  String toString() {
    return render().outerHTML;
  }
}

class Div extends View {
  final List<View> children;
  Div({
    super.id,
    super.tag = 'div',
    super.className,
    super.style,
    super.onClick,
    super.afterRender,
    super.beforeRender,
    required this.children,
  });

  @override
  Element render() {
    final element = super.render();
    for (final child in children) {
      element.append(child.render());
    }
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
}

class Button extends View {
  final View child;
  final Function(View)? onPressed;

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
        onPressed!(this);
      });
    }
    return element;
  }
}

class Diaolog extends View {
  final View child;
  final View? title;
  final View? actions;

  Diaolog({
    required this.child,
    this.title,
    this.actions,
    super.id,
    super.tag = 'dialog',
    super.className,
    super.style,
  });

  @override
  Element render() {
    final element = super.render();
    element.append(child.render());
    if (title != null) {
      element.append(title!.render());
    }
    if (actions != null) {
      element.append(actions!.render());
    }
    return element;
  }
}

enum TextInpuType { text, password, email, number, tel, url }

class TextInput extends View {
  final String? placeholder;
  final String? value;
  final TextInpuType? type;
  final bool? autoFocus;
  final int? maxLength;
  final Function(event.Event)? onChanged;
  final Function(event.Event)? onSubmitted;

  TextInput({
    this.placeholder,
    this.value,
    this.onChanged,
    this.onSubmitted,
    super.id,
    super.tag = 'input',
    super.className,
    super.style,
    this.type = TextInpuType.text,
    this.autoFocus = false,
    this.maxLength,
  });

  @override
  Element render() {
    final element = super.render() as HTMLInputElement;
    element.setAttribute('placeholder', placeholder ?? '');
    element.setAttribute('value', value ?? '');
    element.setAttribute('type', type.toString().split('.').last);
    element.autofocus = autoFocus!;
    if (maxLength != null) {
      element.setAttribute('maxlength', maxLength.toString());
    }

    element.onInput.listen((inputEvent) {
      if (maxLength != null && element.value.length > maxLength!) {
        element.value = element.value.substring(0, maxLength!);
      }

      final changeEvent = event.Event(
        value: element.value,
        target: this,
      );

      onChanged?.call(changeEvent);
      focus();
    });

    element.onKeyDown.listen((keyDownEvent) {
      if (keyDownEvent.key == 'Enter') {
        final submitEvent = event.Event(
          value: element.value,
          target: this,
        );
        onSubmitted!(submitEvent);
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
    for (final item in items) {
      if (item.value == initialValue) {
        element.selectedIndex = items.indexOf(item);
      }

      element.append(item.render());
    }
    element.onChange.listen((event) {
      onChanged!(items[element.selectedIndex].value);
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

class Reactive extends View {
  final View Function(
      View, Function([void Function([event.Event? ev])? onUpdated]))? builder;
  Reactive({
    required this.builder,
    required super.id,
    super.tag = 'div',
    super.className,
    super.style,
    super.onClick,
    super.beforeRender,
    super.afterRender,
  });

  void update([void Function([event.Event? ev])? onUpdated]) {
    final newElement = render();
    final oldElement = document.getElementById(id!);
    if (oldElement != null) {
      if (!isIOS || !isSafari) {
        oldElement.replaceWith(newElement);

        if (onUpdated != null) {
          final updateEvent = event.Event(target: this);
          onUpdated(updateEvent);
        }
        return;
      }

      // This method works for ios platform, dont replace it with innerHTML or replaceChild
      for (var i = 0; i < newElement.children.length; i++) {
        final newChild = newElement.children.item(i);
        // remove old child
        oldElement.children.item(i)?.remove();
        // append new child
        oldElement.children.add(newChild!);
      }

      if (onUpdated != null) {
        final updateEvent = event.Event(target: this);
        onUpdated(updateEvent);
      }

      return;
    }

    print(
        "Element not found, this typically happens when the element is not rendered yet. Call this method in a View body or after the element is rendered.");
  }

  @override
  Element render() {
    final element = super.render();
    element.append(builder!(this, update).render());
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

class Script extends View {
  final String? src;
  final String? type;
  final String? async;
  final String? defer;
  final String? crossOrigin;
  final String? integrity;
  final String? referrerPolicy;
  final String? text;
  Script({
    this.src,
    this.type = 'text/javascript',
    this.async,
    this.defer,
    this.crossOrigin,
    this.integrity,
    this.referrerPolicy,
    this.text,
    super.tag = 'script',
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as HTMLScriptElement;
    if (src != null) {
      element.src = src!;
    }

    if (type != null) {
      element.type = type!;
    }

    if (async != null) {
      element.async = async == 'true';
    }

    if (defer != null) {
      element.defer = defer == 'true';
    }

    if (crossOrigin != null) {
      element.crossOrigin = crossOrigin!;
    }

    if (integrity != null) {
      element.integrity = integrity!;
    }

    if (referrerPolicy != null) {
      element.referrerPolicy = referrerPolicy!;
    }

    if (text != null) {
      element.text = text!;
    }

    return element;
  }
}

class Snapshot<T> {
  final T data;
  final bool hasError;
  final String? error;
  Snapshot({
    required this.data,
    this.hasError = false,
    this.error,
  });
}

class Promise<T> extends View {
  final View Function(Snapshot<T>) builder;
  final Future<T> Function() future;
  final View? loading;
  final View Function(Object err, [StackTrace? stackTracce])? error;

  Promise({
    required this.builder,
    required this.future,
    this.loading,
    this.error,
    super.id,
    super.tag = 'div',
    super.className,
    super.style,
    super.onClick,
    super.beforeRender,
    super.afterRender,
  });

  @override
  Element render() {
    final element = super.render();

    if (loading != null) {
      element.append(loading!.render());
    }

    future().then((data) {
      final snapshot = Snapshot(data: data);

      loading?.remove();

      element.append(builder(snapshot).render());
    }).catchError((err, StackTrace stackTrace) {
      loading?.remove();

      if (error != null) {
        element.append(error!(err, stackTrace).render());
        return;
      }

      final snapshot =
          Snapshot(data: null, hasError: true, error: err) as Snapshot<T>;
      element.append(builder(snapshot).render());
    });
    return element;
  }
}

class Live<T> extends View {
  final View Function(Snapshot<T>) builder;
  final Stream<T> Function() stream;
  final View? loading;
  final View Function(Object err, [StackTrace? stackTracce])? error;

  Live({
    required this.builder,
    required this.stream,
    this.loading,
    this.error,
    super.id,
    super.tag = 'div',
    super.className,
    super.style,
    super.onClick,
    super.beforeRender,
    super.afterRender,
    super.onUnmount,
  });

  @override
  Element render() {
    final element = super.render();

    if (loading != null) {
      element.append(loading!.render());
    }

    stream().listen((data) {
      final snapshot = Snapshot(data: data);

      loading?.remove();

      element.append(builder(snapshot).render());
    }).onError((err, StackTrace stackTrace) {
      loading?.remove();

      if (error != null) {
        element.append(error!(err, stackTrace).render());
        return;
      }

      final snapshot =
          Snapshot(data: null, hasError: true, error: err) as Snapshot<T>;
      element.append(builder(snapshot).render());
    });
    return element;
  }
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
    super.beforeRender,
    super.afterRender,
    this.listStyle = ListStyle.unordered,
    this.type = ListType.disc,
  });

  @override
  Element render() {
    super.tag = listStyle == ListStyle.ordered ? 'ol' : 'ul';
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
    super.beforeRender,
    super.afterRender,
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

class MediaController {
  HTMLMediaElement? _mediaElement;

  set mediaElement(HTMLMediaElement mediaElement) {
    _mediaElement = mediaElement;
  }

  void _init() {
    if (_mediaElement == null) {
      throw Exception('Media element is not set');
    }
  }

  void play() {
    _init();
    _mediaElement!.play();
  }

  void pause() {
    _init();
    _mediaElement!.pause();
  }

  void seek(double time) {
    _init();
    _mediaElement!.currentTime = time;
  }

  void setVolume(double volume) {
    _init();
    _mediaElement!.volume = volume;
  }

  void setMuted(bool muted) {
    _init();
    _mediaElement!.muted = muted;
  }

  void setPlaybackRate(double rate) {
    _init();
    _mediaElement!.playbackRate = rate;
  }

  void setLoop(bool loop) {
    _init();
    _mediaElement!.loop = loop;
  }

  void setAutoplay(bool autoplay) {
    _init();
    _mediaElement!.autoplay = autoplay;
  }

  void setPreload(Preload preload) {
    _init();
    _mediaElement!.preload = preload.toString().split('.').last;
  }

  void addEventListener(String event, Function(dynamic cbEvent) callback) {
    _init();

    // TODO! Implement this
  }
}

enum CrossOrigin { anonymous, useCredentials }

enum Preload { none, metadata, auto }

enum ControlsList {
  nodownload,
  nofullscreen,
  noremoteplayback,
  noshare,
  nozoom,
  noplaybackrate,
}

class Source extends View {
  final String src;
  final String type;

  Source({
    required this.src,
    required this.type,
    super.id,
    super.tag = 'source',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as HTMLSourceElement;
    element
      ..setAttribute('src', src)
      ..setAttribute('type', type);
    return element;
  }
}

class Video extends View {
  final String? src;
  final List<Source>? sources;
  final String? poster;
  final double? width;
  final double? height;
  final bool? controls;
  final List<ControlsList>? controlsList;
  final bool? autoplay;
  final bool? loop;
  final bool? muted;
  final CrossOrigin? crossOrigin;
  final bool? disablePictureInPicture;
  final bool? disableRemotePlayback;
  final bool? playsInline;
  final Preload? preload;
  final MediaController? controller;

  Video({
    this.src,
    this.sources,
    this.poster,
    this.width,
    this.height,
    this.controls,
    this.autoplay = false,
    this.loop,
    this.muted = true,
    this.crossOrigin,
    this.disablePictureInPicture,
    this.disableRemotePlayback,
    this.playsInline,
    this.preload,
    super.id,
    super.tag = 'video',
    super.className,
    super.style,
    super.onClick,
    this.controller,
    this.controlsList,
  }) {
    if (src == null && sources == null) {
      showErrorView(
          "$tag must have either src or valid sources; None currently provided",
          StackTrace.current);
      throw Exception('src or sources must be provided');
    }
  }

  @override
  Element render() {
    final element = super.render() as HTMLVideoElement;
    if (src != null) {
      element.setAttribute('src', src!);
    }

    if (poster != null) {
      element.setAttribute('poster', poster!);
    }

    if (width != null) {
      element.setAttribute('width', width.toString());
    }

    if (height != null) {
      element.setAttribute('height', height.toString());
    }

    if (controls != null) {
      element.controls = controls!;
    }

    if (autoplay != null) {
      element.autoplay = autoplay!;
    }

    if (loop != null) {
      element.loop = loop!;
    }

    if (muted != null) {
      element.muted = muted!;
    }

    if (crossOrigin != null) {
      element.crossOrigin = crossOrigin.toString().split('.').last;
    }

    if (disablePictureInPicture != null) {
      element.setAttribute(
          "disablePictureInPicture", disablePictureInPicture.toString());
    }

    if (disableRemotePlayback != null) {
      element.setAttribute(
          "disableRemotePlayback", disableRemotePlayback.toString());

      element.setAttribute(
          "x-webkit-airplay", disableRemotePlayback.toString());
    }

    if (playsInline != null) {
      element.setAttribute("playsInline", playsInline.toString());
    }

    if (preload != null) {
      element.preload = preload.toString().split('.').last;
    }

    if (controlsList != null) {
      final list = controlsList!.map((e) => e.toString().split('.').last);
      element.setAttribute('controlsList', list.join(' '));
    }

    if (sources != null) {
      for (final source in sources!) {
        element.append(source.render());
      }
    }

    if (controller != null) {
      controller!.mediaElement = element;
    }

    return element;
  }
}

class Audio extends View {
  final String? src;
  final List<Source>? sources;
  final bool? controls;
  final List<ControlsList>? controlsList;
  final CrossOrigin? crossOrigin;
  final bool? autoplay;
  final bool? loop;
  final bool? muted;
  final Preload? preload;
  final bool? disableRemotePlayback;
  final MediaController? controller;

  Audio({
    this.src,
    this.sources,
    this.controls = true,
    this.autoplay = false,
    this.loop,
    this.muted = true,
    this.crossOrigin,
    this.disableRemotePlayback,
    this.preload,
    super.id,
    super.tag = 'audio',
    super.className,
    super.style,
    super.onClick,
    this.controller,
    this.controlsList,
  }) {
    if (src == null && sources == null) {
      showErrorView(
          "$tag must have either src or valid sources; None currently provided",
          StackTrace.current);
      throw Exception('src or sources must be provided');
    }
  }

  @override
  Element render() {
    final element = super.render() as HTMLAudioElement;
    if (src != null) {
      element.setAttribute('src', src!);
    }

    if (controls != null) {
      element.controls = controls!;
    }

    if (autoplay != null) {
      element.autoplay = autoplay!;
    }

    if (loop != null) {
      element.loop = loop!;
    }

    if (muted != null) {
      element.muted = muted!;
    }

    if (crossOrigin != null) {
      element.crossOrigin = crossOrigin.toString().split('.').last;
    }

    if (disableRemotePlayback != null) {
      element.setAttribute(
          "disableRemotePlayback", disableRemotePlayback.toString());

      element.setAttribute(
          "x-webkit-airplay", disableRemotePlayback.toString());
    }

    if (preload != null) {
      element.preload = preload.toString().split('.').last;
    }

    if (controlsList != null) {
      final list = controlsList!.map((e) => e.toString().split('.').last);
      element.setAttribute('controlsList', list.join(' '));
    }

    if (sources != null) {
      for (final source in sources!) {
        element.append(source.render());
      }
    }

    if (controller != null) {
      controller!.mediaElement = element;
    }

    return element;
  }
}

class Canvas extends View {
  final double? width;
  final double? height;
  final void Function(CanvasRenderingContext2D context)? onRender;

  Canvas({
    this.width,
    this.height,
    super.className,
    super.style,
    this.onRender,
    super.id,
    super.tag = 'canvas',
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as HTMLCanvasElement;
    if (width != null) {
      element.width = width!.toInt();
    }

    if (height != null) {
      element.height = height!.toInt();
    }

    final context = element.getContext('2d') as CanvasRenderingContext2D;
    onRender?.call(context);

    return element;
  }
}

enum PreservedAspectRatio { none, xMinYMin, xMidYMin, xMaxYMin }

enum PreserveAspectRatioMode { meet, slice }

/// See https://developer.mozilla.org/en-US/docs/Web/SVG/Element/svg
class Svg extends View {
  final double? width;
  final double? height;
  final List<int> viewBox;
  final List<View> children;
  final String? xmlns;
  final PreservedAspectRatio? preserveAspectRatio;
  final PreserveAspectRatioMode? mode;
  final int? x;
  final int? y;

  Svg({
    this.width,
    this.height,
    required this.viewBox,
    this.xmlns = 'http://www.w3.org/2000/svg',
    this.preserveAspectRatio,
    this.mode,
    this.x,
    this.y,
    required this.children,
    super.id,
    super.tag = 'svg',
    super.className,
    super.style,
    super.onClick,
  }) {
    if (preserveAspectRatio != null && mode == null) {
      showErrorView("mode is required when preserveAspectRatio is set",
          StackTrace.current);
      throw Exception('mode is required when preserveAspectRatio is set');
    }

    if (preserveAspectRatio == null && mode != null) {
      showErrorView("preserveAspectRatio is required when mode is set",
          StackTrace.current);
      throw Exception('preserveAspectRatio is required when mode is set');
    }
  }

  @override
  Element render() {
    final element = super.render() as SVGSVGElement;
    element.setAttribute('xmlns', xmlns!);

    if (preserveAspectRatio != null) {
      element.setAttribute(
        'preserveAspectRatio',
        '${preserveAspectRatio!.toString().split('.').last} ${mode!.toString().split('.').last}',
      );
    }

    if (width != null) {
      element.setAttribute('width', width.toString());
    }

    if (height != null) {
      element.setAttribute('height', height.toString());
    }

    element.setAttribute('viewBox', viewBox.join(' '));

    for (final child in children) {
      element.append(child.render());
    }

    return element;
  }
}

class Rect extends View {
  final double x;
  final double y;
  final double width;
  final double height;
  final String? fill;
  final String? stroke;
  final double? strokeWidth;

  Rect({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.fill,
    this.stroke,
    this.strokeWidth,
    super.id,
    super.tag = 'rect',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGRectElement;
    element.setAttribute('x', x.toString());
    element.setAttribute('y', y.toString());
    element.setAttribute('width', width.toString());
    element.setAttribute('height', height.toString());

    if (fill != null) {
      element.setAttribute('fill', fill!);
    }

    if (stroke != null) {
      element.setAttribute('stroke', stroke!);
    }

    if (strokeWidth != null) {
      element.setAttribute('stroke-width', strokeWidth.toString());
    }

    return element;
  }
}

class Circle extends View {
  final double cx;
  final double cy;
  final double r;
  final String? fill;
  final String? stroke;
  final double? strokeWidth;

  Circle({
    required this.cx,
    required this.cy,
    required this.r,
    this.fill,
    this.stroke,
    this.strokeWidth,
    super.id,
    super.tag = 'circle',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGCircleElement;
    element.setAttribute('cx', cx.toString());
    element.setAttribute('cy', cy.toString());
    element.setAttribute('r', r.toString());

    if (fill != null) {
      element.setAttribute('fill', fill!);
    }

    if (stroke != null) {
      element.setAttribute('stroke', stroke!);
    }

    if (strokeWidth != null) {
      element.setAttribute('stroke-width', strokeWidth.toString());
    }

    return element;
  }
}

class Ellipse extends View {
  final double cx;
  final double cy;
  final double rx;
  final double ry;
  final String? fill;
  final String? stroke;
  final double? strokeWidth;

  Ellipse({
    required this.cx,
    required this.cy,
    required this.rx,
    required this.ry,
    this.fill,
    this.stroke,
    this.strokeWidth,
    super.id,
    super.tag = 'ellipse',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGEllipseElement;
    element.setAttribute('cx', cx.toString());
    element.setAttribute('cy', cy.toString());
    element.setAttribute('rx', rx.toString());
    element.setAttribute('ry', ry.toString());

    if (fill != null) {
      element.setAttribute('fill', fill!);
    }

    if (stroke != null) {
      element.setAttribute('stroke', stroke!);
    }

    if (strokeWidth != null) {
      element.setAttribute('stroke-width', strokeWidth.toString());
    }

    return element;
  }
}

class Line extends View {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final String? stroke;
  final double? strokeWidth;

  Line({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    this.stroke,
    this.strokeWidth,
    super.id,
    super.tag = 'line',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGLineElement;
    element.setAttribute('x1', x1.toString());
    element.setAttribute('y1', y1.toString());
    element.setAttribute('x2', x2.toString());
    element.setAttribute('y2', y2.toString());

    if (stroke != null) {
      element.setAttribute('stroke', stroke!);
    }

    if (strokeWidth != null) {
      element.setAttribute('stroke-width', strokeWidth.toString());
    }

    return element;
  }
}

class Polyline extends View {
  final List<List<double>> points;
  final String? fill;
  final String? stroke;
  final double? strokeWidth;

  Polyline({
    required this.points,
    this.fill,
    this.stroke,
    this.strokeWidth,
    super.id,
    super.tag = 'polyline',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGPolylineElement;
    final pointsString = points.map((e) => e.join(',')).join(' ');
    element.setAttribute('points', pointsString);

    if (fill != null) {
      element.setAttribute('fill', fill!);
    }

    if (stroke != null) {
      element.setAttribute('stroke', stroke!);
    }

    if (strokeWidth != null) {
      element.setAttribute('stroke-width', strokeWidth.toString());
    }

    return element;
  }
}

class Polygon extends View {
  final List<List<double>> points;
  final String? fill;
  final String? stroke;
  final double? strokeWidth;

  Polygon({
    required this.points,
    this.fill,
    this.stroke,
    this.strokeWidth,
    super.id,
    super.tag = 'polygon',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGPolygonElement;
    final pointsString = points.map((e) => e.join(',')).join(' ');
    element.setAttribute('points', pointsString);

    if (fill != null) {
      element.setAttribute('fill', fill!);
    }

    if (stroke != null) {
      element.setAttribute('stroke', stroke!);
    }

    if (strokeWidth != null) {
      element.setAttribute('stroke-width', strokeWidth.toString());
    }

    return element;
  }
}

class Path extends View {
  final String d;
  final String? fill;
  final String? stroke;
  final double? strokeWidth;

  Path({
    required this.d,
    this.fill,
    this.stroke,
    this.strokeWidth,
    super.id,
    super.tag = 'path',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGPathElement;
    element.setAttribute('d', d);

    if (fill != null) {
      element.setAttribute('fill', fill!);
    }

    if (stroke != null) {
      element.setAttribute('stroke', stroke!);
    }

    if (strokeWidth != null) {
      element.setAttribute('stroke-width', strokeWidth.toString());
    }

    return element;
  }
}

class TextSpan extends View {
  final String text;
  final String? fill;
  final String? stroke;
  final double? strokeWidth;
  final double? x;
  final double? y;
  final double? fontSize;
  final String? fontFamily;
  final String? fontWeight;
  final String? fontStyle;
  final String? textDecoration;
  final String? textAnchor;
  final String? dominantBaseline;

  TextSpan({
    required this.text,
    this.fill,
    this.stroke,
    this.strokeWidth,
    this.x,
    this.y,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.fontStyle,
    this.textDecoration,
    this.textAnchor,
    this.dominantBaseline,
    super.id,
    super.tag = 'text',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGTextElement;
    element.text = text;

    if (fill != null) {
      element.setAttribute('fill', fill!);
    }

    if (stroke != null) {
      element.setAttribute('stroke', stroke!);
    }

    if (strokeWidth != null) {
      element.setAttribute('stroke-width', strokeWidth.toString());
    }

    if (x != null) {
      element.setAttribute('x', x.toString());
    }

    if (y != null) {
      element.setAttribute('y', y.toString());
    }

    if (fontSize != null) {
      element.setAttribute('font-size', fontSize.toString());
    }

    if (fontFamily != null) {
      element.setAttribute('font-family', fontFamily!);
    }

    if (fontWeight != null) {
      element.setAttribute('font-weight', fontWeight!);
    }

    if (fontStyle != null) {
      element.setAttribute('font-style', fontStyle!);
    }

    if (textDecoration != null) {
      element.setAttribute('text-decoration', textDecoration!);
    }

    if (textAnchor != null) {
      element.setAttribute('text-anchor', textAnchor!);
    }

    if (dominantBaseline != null) {
      element.setAttribute('dominant-baseline', dominantBaseline!);
    }

    return element;
  }
}

class Defs extends View {
  final List<View> children;

  Defs({
    required this.children,
    super.id,
    super.tag = 'defs',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGDefsElement;
    for (final child in children) {
      element.append(child.render());
    }
    return element;
  }
}

class G extends View {
  final List<View> children;

  G({
    required this.children,
    super.id,
    super.tag = 'g',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGGElement;
    for (final child in children) {
      element.append(child.render());
    }
    return element;
  }
}

class SvgImage extends View {
  final String src;
  final double? x;
  final double? y;
  final double? width;
  final double? height;
  final String? preserveAspectRatio;
  final String? href;
  final String? fill;
  final String? stroke;
  final double? strokeWidth;

  SvgImage({
    required this.src,
    this.x,
    this.y,
    this.width,
    this.height,
    this.preserveAspectRatio,
    this.href,
    this.fill,
    this.stroke,
    this.strokeWidth,
    super.id,
    super.tag = 'image',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGImageElement;
    element.setAttribute('href', src);

    if (x != null) {
      element.setAttribute('x', x.toString());
    }

    if (y != null) {
      element.setAttribute('y', y.toString());
    }

    if (width != null) {
      element.setAttribute('width', width.toString());
    }

    if (height != null) {
      element.setAttribute('height', height.toString());
    }

    if (preserveAspectRatio != null) {
      element.setAttribute('preserveAspectRatio', preserveAspectRatio!);
    }

    if (href != null) {
      element.setAttribute('href', href!);
    }

    if (fill != null) {
      element.setAttribute('fill', fill!);
    }

    if (stroke != null) {
      element.setAttribute('stroke', stroke!);
    }

    if (strokeWidth != null) {
      element.setAttribute('stroke-width', strokeWidth.toString());
    }

    return element;
  }
}

class SvgAnimate extends View {
  final String attributeName;
  final String from;
  final String to;
  final String dur;
  final String? repeatCount;
  final String? fill;
  final String? begin;

  SvgAnimate({
    required this.attributeName,
    required this.from,
    required this.to,
    required this.dur,
    this.repeatCount,
    this.fill,
    this.begin,
    super.id,
    super.tag = 'animate',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGAnimateElement;
    element.setAttribute('attributeName', attributeName);
    element.setAttribute('from', from);
    element.setAttribute('to', to);
    element.setAttribute('dur', dur);

    if (repeatCount != null) {
      element.setAttribute('repeatCount', repeatCount!);
    }

    if (fill != null) {
      element.setAttribute('fill', fill!);
    }

    if (begin != null) {
      element.setAttribute('begin', begin!);
    }

    return element;
  }
}

class SvgAnimateMotion extends View {
  final String path;
  final String dur;
  final String? repeatCount;
  final String? fill;
  final String? begin;

  SvgAnimateMotion({
    required this.path,
    required this.dur,
    this.repeatCount,
    this.fill,
    this.begin,
    super.id,
    super.tag = 'animateMotion',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGAnimateMotionElement;
    element.setAttribute('path', path);
    element.setAttribute('dur', dur);

    if (repeatCount != null) {
      element.setAttribute('repeatCount', repeatCount!);
    }

    if (fill != null) {
      element.setAttribute('fill', fill!);
    }

    if (begin != null) {
      element.setAttribute('begin', begin!);
    }

    return element;
  }
}

class SvgAnimateTransform extends View {
  final String attributeName;
  final String type;
  final String from;
  final String to;
  final String dur;
  final String? repeatCount;
  final String? fill;
  final String? begin;

  SvgAnimateTransform({
    required this.attributeName,
    required this.type,
    required this.from,
    required this.to,
    required this.dur,
    this.repeatCount,
    this.fill,
    this.begin,
    super.id,
    super.tag = 'animateTransform',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGAnimateTransformElement;
    element.setAttribute('attributeName', attributeName);
    element.setAttribute('type', type);
    element.setAttribute('from', from);
    element.setAttribute('to', to);
    element.setAttribute('dur', dur);

    if (repeatCount != null) {
      element.setAttribute('repeatCount', repeatCount!);
    }

    if (fill != null) {
      element.setAttribute('fill', fill!);
    }

    if (begin != null) {
      element.setAttribute('begin', begin!);
    }

    return element;
  }
}

class ClipPath extends View {
  final List<View> children;
  final String? id;

  ClipPath({
    required this.children,
    this.id,
    super.tag = 'clipPath',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGClipPathElement;
    if (id != null) {
      element.setAttribute('id', id!);
    }

    for (final child in children) {
      element.append(child.render());
    }

    return element;
  }
}

class Marker extends View {
  final List<View> children;
  final double? refX;
  final double? refY;
  final double? markerWidth;
  final double? markerHeight;
  final String? orient;
  final String? viewBox;
  final String? preserveAspectRatio;

  Marker({
    required this.children,
    super.id,
    this.refX,
    this.refY,
    this.markerWidth,
    this.markerHeight,
    this.orient,
    this.viewBox,
    this.preserveAspectRatio,
    super.tag = 'marker',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGMarkerElement;
    if (id != null) {
      element.setAttribute('id', id!);
    }

    if (refX != null) {
      element.setAttribute('refX', refX.toString());
    }

    if (refY != null) {
      element.setAttribute('refY', refY.toString());
    }

    if (markerWidth != null) {
      element.setAttribute('markerWidth', markerWidth.toString());
    }

    if (markerHeight != null) {
      element.setAttribute('markerHeight', markerHeight.toString());
    }

    if (orient != null) {
      element.setAttribute('orient', orient!);
    }

    if (viewBox != null) {
      element.setAttribute('viewBox', viewBox!);
    }

    if (preserveAspectRatio != null) {
      element.setAttribute('preserveAspectRatio', preserveAspectRatio!);
    }

    for (final child in children) {
      element.append(child.render());
    }

    return element;
  }
}

class Mask extends View {
  final List<View> children;

  Mask({
    required this.children,
    super.id,
    super.tag = 'mask',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGMaskElement;
    if (id != null) {
      element.setAttribute('id', id!);
    }

    for (final child in children) {
      element.append(child.render());
    }

    return element;
  }
}

class Pattern extends View {
  final List<View> children;
  final String? id;
  final String? x;
  final String? y;
  final String? width;
  final String? height;
  final String? patternUnits;
  final String? patternContentUnits;
  final String? patternTransform;
  final String? viewBox;
  final String? preserveAspectRatio;

  Pattern({
    required this.children,
    this.id,
    this.x,
    this.y,
    this.width,
    this.height,
    this.patternUnits,
    this.patternContentUnits,
    this.patternTransform,
    this.viewBox,
    this.preserveAspectRatio,
    super.tag = 'pattern',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGPatternElement;
    if (id != null) {
      element.setAttribute('id', id!);
    }

    if (x != null) {
      element.setAttribute('x', x!);
    }

    if (y != null) {
      element.setAttribute('y', y!);
    }

    if (width != null) {
      element.setAttribute('width', width!);
    }

    if (height != null) {
      element.setAttribute('height', height!);
    }

    if (patternUnits != null) {
      element.setAttribute('patternUnits', patternUnits!);
    }

    if (patternContentUnits != null) {
      element.setAttribute('patternContentUnits', patternContentUnits!);
    }

    if (patternTransform != null) {
      element.setAttribute('patternTransform', patternTransform!);
    }

    if (viewBox != null) {
      element.setAttribute('viewBox', viewBox!);
    }

    if (preserveAspectRatio != null) {
      element.setAttribute('preserveAspectRatio', preserveAspectRatio!);
    }

    for (final child in children) {
      element.append(child.render());
    }

    return element;
  }
}

class Filter extends View {
  final List<View> children;
  final String? id;
  final String? x;
  final String? y;
  final String? width;
  final String? height;
  final String? filterUnits;
  final String? primitiveUnits;
  final String? filterRes;
  final String? href;

  Filter({
    required this.children,
    this.id,
    this.x,
    this.y,
    this.width,
    this.height,
    this.filterUnits,
    this.primitiveUnits,
    this.filterRes,
    this.href,
    super.tag = 'filter',
    super.className,
    super.style,
    super.onClick,
  });

  @override
  Element render() {
    final element = super.render() as SVGFilterElement;
    if (id != null) {
      element.setAttribute('id', id!);
    }

    if (x != null) {
      element.setAttribute('x', x!);
    }

    if (y != null) {
      element.setAttribute('y', y!);
    }

    if (width != null) {
      element.setAttribute('width', width!);
    }

    if (height != null) {
      element.setAttribute('height', height!);
    }

    if (filterUnits != null) {
      element.setAttribute('filterUnits', filterUnits!);
    }

    if (primitiveUnits != null) {
      element.setAttribute('primitiveUnits', primitiveUnits!);
    }

    if (filterRes != null) {
      element.setAttribute('filterRes', filterRes!);
    }

    if (href != null) {
      element.setAttribute('href', href!);
    }

    for (final child in children) {
      element.append(child.render());
    }

    return element;
  }
}
