
extension DimensionExt on num {
  String get px => '${this}px';
  String get percent => '$this%';
  String get vh => '${this}vh';
  String get vw => '${this}vw';
  String get em => '${this}em';
  String get rem => '${this}rem';
  String get ch => '${this}ch';
  String get ex => '${this}ex';
  String get svh => '${this}svh';
  String get svw => '${this}svw';
}

class Style {
  final String? width;
  final String? height;
  final String? color;
  final String? backgroundColor;
  final String? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final double? padding;
  final double? margin;
  final String? display;

  const Style({
    this.width,
    this.height,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.margin,
    this.display,
  });

  String create() {
    final styles = <String>[];
    if (width != null) {
      styles.add('width: $width');
    }
    if (height != null) {
      styles.add('height: $height');
    }
    if (color != null) {
      styles.add('color: $color');
    }
    if (backgroundColor != null) {
      styles.add('background-color: $backgroundColor');
    }
    if (borderColor != null) {
      styles.add('border-color: $borderColor');
    }
    if (borderWidth != null) {
      styles.add('border-width: ${borderWidth}px');
    }
    if (borderRadius != null) {
      styles.add('border-radius: ${borderRadius}px');
    }
    if (padding != null) {
      styles.add('padding: ${padding}px');
    }
    if (margin != null) {
      styles.add('margin: ${margin}px');
    }
    if (display != null) {
      styles.add('display: $display');
    }

    return styles.join(';');
  }
}
  