import 'package:kitawi/src/basic.dart';
import 'package:web/web.dart';

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

class Meta extends View {
  final String? charset;
  final String? content;
  final String? httpEquiv;
  final String? name;
  final String? scheme;
  Meta({
    this.charset,
    this.content,
    this.httpEquiv,
    this.name,
    this.scheme,
    super.tag = 'meta',
  });

  @override
  Element render() {
    final element = super.render() as HTMLMetaElement;
    if (charset != null) {
      element.setAttribute("charset", charset!);
    }

    if (content != null) {
      element.content = content!;
    }

    if (httpEquiv != null) {
      element.httpEquiv = httpEquiv!;
    }

    if (name != null) {
      element.name = name!;
    }

    if (scheme != null) {
      element.scheme = scheme!;
    }

    return element;
  }
}
