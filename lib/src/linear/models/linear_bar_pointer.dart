import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/common/models/gauge_label.dart';

/// A colored segment covering the values [start]..[end] of a linear gauge.
///
/// Used by `GxLinearBarGauge.bars` and `GxLinearScaleGauge.bars`.
///
/// ```dart
/// const GxLinearBarPointer(start: 0, end: 40, color: Colors.green)
/// ```
@immutable
class GxLinearBarPointer with Diagnosticable {
  /// Creates a bar from [start] to [end] (in gauge values, `start <= end`).
  const GxLinearBarPointer({
    required this.start,
    required this.end,
    this.color,
    this.thickness,
    this.position,
    this.offset = 0.0,
    this.shaderCallback,
    this.borderColor,
    this.borderWidth = 1.0,
    this.radius,
    this.label,
  }) : assert(
         start <= end,
         'start ($start) must not be greater than end ($end)',
       );

  /// The value where the bar begins.
  final double start;

  /// The value where the bar ends.
  final double end;

  /// The bar color. Null uses the theme's `primary`.
  final Color? color;

  /// The bar's extent across the track. Null uses the gauge's default: the
  /// full height of a `GxLinearBarGauge` (half of it when [position] is
  /// inside or outside), or `barHeight` of a `GxLinearScaleGauge`.
  final double? thickness;

  /// Where the bar sits across the track: centered on it
  /// ([GxElementPosition.cross]), below it ([GxElementPosition.inside]) or
  /// above it ([GxElementPosition.outside]). Null uses the gauge's default
  /// placement.
  final GxElementPosition? position;

  /// Extra distance from the track's center line for inside and outside
  /// bars. Defaults to 0.
  final double offset;

  /// Paints the bar with a shader (e.g. a gradient) instead of [color].
  /// Receives the bar's rectangle.
  final ShaderCallback? shaderCallback;

  /// Outline color. Null draws no outline. For an outlined-only bar, set
  /// [color] to `Colors.transparent`.
  final Color? borderColor;

  /// Outline width when [borderColor] is set. Defaults to 1.
  final double borderWidth;

  /// Corner radius. Null draws square corners.
  final Radius? radius;

  /// Text drawn inside the bar.
  final GxGaugeLabel? label;

  /// Returns a copy with the given fields replaced.
  GxLinearBarPointer copyWith({
    double? start,
    double? end,
    Color? color,
    double? thickness,
    GxElementPosition? position,
    double? offset,
    ShaderCallback? shaderCallback,
    Color? borderColor,
    double? borderWidth,
    Radius? radius,
    GxGaugeLabel? label,
  }) {
    return GxLinearBarPointer(
      start: start ?? this.start,
      end: end ?? this.end,
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
      position: position ?? this.position,
      offset: offset ?? this.offset,
      shaderCallback: shaderCallback ?? this.shaderCallback,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      radius: radius ?? this.radius,
      label: label ?? this.label,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxLinearBarPointer &&
      other.start == start &&
      other.end == end &&
      other.color == color &&
      other.thickness == thickness &&
      other.position == position &&
      other.offset == offset &&
      other.shaderCallback == shaderCallback &&
      other.borderColor == borderColor &&
      other.borderWidth == borderWidth &&
      other.radius == radius &&
      other.label == label;

  @override
  int get hashCode => Object.hash(
    start,
    end,
    color,
    thickness,
    position,
    offset,
    shaderCallback,
    borderColor,
    borderWidth,
    radius,
    label,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('start', start))
      ..add(DoubleProperty('end', end))
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(DoubleProperty('thickness', thickness, defaultValue: null))
      ..add(
        EnumProperty<GxElementPosition>(
          'position',
          position,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty<GxGaugeLabel>('label', label, defaultValue: null),
      );
  }
}
