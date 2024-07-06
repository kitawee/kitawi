import 'package:kitawi/utils/error.dart';

import 'basic.dart';
import 'package:web/web.dart';

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
      error(
        "$tag must have either src or valid sources; None currently provided",
        StackTrace.current,
      );
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
      error(
        "$tag must have either src or valid sources; None currently provided",
        StackTrace.current,
      );
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
      error(
        "mode is required when preserveAspectRatio is set",
        StackTrace.current,
      );
      throw Exception('mode is required when preserveAspectRatio is set');
    }

    if (preserveAspectRatio == null && mode != null) {
      error(
        "preserveAspectRatio is required when mode is set",
        StackTrace.current,
      );
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
