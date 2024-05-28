class StyleProp {
  final double? width;
  final double? height;
  final String? color;
  final String? backgroundColor;
  final String? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final double? padding;
  final double? margin;
  final String? display;

  const StyleProp({
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
      styles.add('width: ${width}px');
    }
    if (height != null) {
      styles.add('height: ${height}px');
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
