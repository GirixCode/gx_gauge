import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:gx_gauge/src/common/models/enums.dart';

/// A value bubble drawn above or below a linear bar gauge.
///
/// ```dart
/// const GxGaugeTooltip(label: '{value} km/h', position: GxTooltipPosition.top)
/// ```
@immutable
class GxGaugeTooltip with Diagnosticable {
  /// Creates a tooltip.
  const GxGaugeTooltip({
    this.enabled = true,
    this.label,
    this.textStyle = const TextStyle(),
    this.color,
    this.borderColor,
    this.size = const Size(60, 30),
    this.radius,
    this.type = GxTooltipType.normal,
    this.position = GxTooltipPosition.top,
    this.paintingStyle = PaintingStyle.fill,
    this.thickness = 2.0,
    this.offset = 10.0,
    this.strokeCap = StrokeCap.butt,
    this.showPointer = true,
  });

  /// Whether the tooltip is drawn. Defaults to true.
  final bool enabled;

  /// The text. `{value}` is replaced with the gauge's value. Null shows just
  /// the value.
  final String? label;

  /// Merged onto the default text style: the theme's `onInverseSurface` for a
  /// filled bubble, or [borderColor]/[color] for an outlined one.
  final TextStyle textStyle;

  /// The bubble color. Null uses the theme's `inverseSurface`.
  final Color? color;

  /// The outline and pointer color. Null uses [color].
  final Color? borderColor;

  /// The bubble's size. Defaults to 60×30.
  final Size size;

  /// Corner radius of the bubble. Null draws square corners.
  final Radius? radius;

  /// The tooltip kind. Defaults to [GxTooltipType.normal].
  final GxTooltipType type;

  /// Above or below the gauge. Defaults to [GxTooltipPosition.top].
  final GxTooltipPosition position;

  /// Filled or outlined bubble. Defaults to [PaintingStyle.fill].
  final PaintingStyle paintingStyle;

  /// Stroke width of the outline and pointer line. Defaults to 2.
  final double thickness;

  /// Gap between the gauge and the bubble. Defaults to 10.
  final double offset;

  /// Cap of the pointer line. Defaults to [StrokeCap.butt].
  final StrokeCap strokeCap;

  /// Whether a line connects the bubble to the gauge. Defaults to true.
  final bool showPointer;

  /// Returns a copy with the given fields replaced.
  GxGaugeTooltip copyWith({
    bool? enabled,
    String? label,
    TextStyle? textStyle,
    Color? color,
    Color? borderColor,
    Size? size,
    Radius? radius,
    GxTooltipType? type,
    GxTooltipPosition? position,
    PaintingStyle? paintingStyle,
    double? thickness,
    double? offset,
    StrokeCap? strokeCap,
    bool? showPointer,
  }) {
    return GxGaugeTooltip(
      enabled: enabled ?? this.enabled,
      label: label ?? this.label,
      textStyle: textStyle ?? this.textStyle,
      color: color ?? this.color,
      borderColor: borderColor ?? this.borderColor,
      size: size ?? this.size,
      radius: radius ?? this.radius,
      type: type ?? this.type,
      position: position ?? this.position,
      paintingStyle: paintingStyle ?? this.paintingStyle,
      thickness: thickness ?? this.thickness,
      offset: offset ?? this.offset,
      strokeCap: strokeCap ?? this.strokeCap,
      showPointer: showPointer ?? this.showPointer,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxGaugeTooltip &&
      other.enabled == enabled &&
      other.label == label &&
      other.textStyle == textStyle &&
      other.color == color &&
      other.borderColor == borderColor &&
      other.size == size &&
      other.radius == radius &&
      other.type == type &&
      other.position == position &&
      other.paintingStyle == paintingStyle &&
      other.thickness == thickness &&
      other.offset == offset &&
      other.strokeCap == strokeCap &&
      other.showPointer == showPointer;

  @override
  int get hashCode => Object.hash(
    enabled,
    label,
    textStyle,
    color,
    borderColor,
    size,
    radius,
    type,
    position,
    paintingStyle,
    thickness,
    offset,
    strokeCap,
    showPointer,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'))
      ..add(StringProperty('label', label, defaultValue: null))
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(DiagnosticsProperty<Size>('size', size))
      ..add(EnumProperty<GxTooltipPosition>('position', position));
  }
}
