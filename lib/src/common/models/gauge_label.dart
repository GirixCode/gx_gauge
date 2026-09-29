import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Text drawn on or next to a gauge element.
///
/// In a progress gauge's label, `{value}` is replaced with the current value:
///
/// ```dart
/// const GxGaugeLabel(label: '{value}%', style: TextStyle(fontSize: 12))
/// ```
@immutable
class GxGaugeLabel with Diagnosticable {
  /// Creates a label.
  const GxGaugeLabel({
    required this.label,
    this.style = const TextStyle(),
    this.textAlign = TextAlign.center,
    this.offset,
    this.spaceExtent = 0.0,
  });

  /// The text. `{value}` is a placeholder where the gauge supports it.
  final String label;

  /// Merged onto the theme's label style, so an empty `TextStyle()` gives the
  /// theme default.
  final TextStyle style;

  /// Horizontal placement within the element. `start` and `end` follow the
  /// ambient text direction. Defaults to [TextAlign.center].
  final TextAlign textAlign;

  /// An extra offset applied after alignment. Null means no offset.
  final Offset? offset;

  /// Padding from the element's edge when [textAlign] is left, right, start
  /// or end. Defaults to 0.
  final double spaceExtent;

  /// Returns a copy with the given fields replaced.
  GxGaugeLabel copyWith({
    String? label,
    TextStyle? style,
    TextAlign? textAlign,
    Offset? offset,
    double? spaceExtent,
  }) {
    return GxGaugeLabel(
      label: label ?? this.label,
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      offset: offset ?? this.offset,
      spaceExtent: spaceExtent ?? this.spaceExtent,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxGaugeLabel &&
      other.label == label &&
      other.style == style &&
      other.textAlign == textAlign &&
      other.offset == offset &&
      other.spaceExtent == spaceExtent;

  @override
  int get hashCode => Object.hash(label, style, textAlign, offset, spaceExtent);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(DiagnosticsProperty<TextStyle>('style', style))
      ..add(
        EnumProperty<TextAlign>(
          'textAlign',
          textAlign,
          defaultValue: TextAlign.center,
        ),
      )
      ..add(DiagnosticsProperty<Offset>('offset', offset, defaultValue: null))
      ..add(DoubleProperty('spaceExtent', spaceExtent, defaultValue: 0.0));
  }
}

/// Resolves [align] to an absolute left/right/center alignment for
/// [direction]. `justify` is treated as center.
TextAlign resolveTextAlign(TextAlign align, TextDirection direction) {
  switch (align) {
    case TextAlign.start:
      return direction == TextDirection.ltr ? TextAlign.left : TextAlign.right;
    case TextAlign.end:
      return direction == TextDirection.ltr ? TextAlign.right : TextAlign.left;
    case TextAlign.justify:
    case TextAlign.center:
      return TextAlign.center;
    case TextAlign.left:
    case TextAlign.right:
      return align;
  }
}
