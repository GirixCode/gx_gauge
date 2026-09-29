import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/common/models/gauge_label.dart';

/// A colored segment covering the values [start]..[end] of a linear gauge.
///
/// Used by `GxLinearBarGauge` and `GxLinearScaleGauge.bars`.
///
/// ```dart
/// GxLinearBarPointer(start: 0, end: 40, color: Colors.green)
/// ```
@immutable
class GxLinearBarPointer with Diagnosticable {
  /// Creates a bar from [start] to [end] (in gauge values, `start <= end`).
  const GxLinearBarPointer({
    required this.start,
    required this.end,
    this.color,
    this.thickness = 5.0,
    this.position = GxElementPosition.cross,
    this.shaderCallback,
    this.radius,
    this.offset = 0.0,
    this.paintingStyle = PaintingStyle.fill,
    this.strokeCap = StrokeCap.butt,
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

  /// Outline width when [paintingStyle] is [PaintingStyle.stroke]. Defaults
  /// to 5. (Cross-axis sizing arrives in docs/PLAN.md Phase 3.)
  final double thickness;

  /// Not applied yet (docs/PLAN.md Phase 3).
  final GxElementPosition position;

  /// Not applied yet (docs/PLAN.md Phase 3).
  final ShaderCallback? shaderCallback;

  /// Corner radius. Null draws square corners.
  final Radius? radius;

  /// Not applied yet (docs/PLAN.md Phase 3).
  final double offset;

  /// Filled or outlined bar. Defaults to [PaintingStyle.fill].
  final PaintingStyle paintingStyle;

  /// Stroke cap of an outlined bar. Defaults to [StrokeCap.butt].
  final StrokeCap strokeCap;

  /// Text drawn inside the bar.
  final GxGaugeLabel? label;

  /// Returns a copy with the given fields replaced.
  GxLinearBarPointer copyWith({
    double? start,
    double? end,
    Color? color,
    double? thickness,
    GxElementPosition? position,
    ShaderCallback? shaderCallback,
    Radius? radius,
    double? offset,
    PaintingStyle? paintingStyle,
    StrokeCap? strokeCap,
    GxGaugeLabel? label,
  }) {
    return GxLinearBarPointer(
      start: start ?? this.start,
      end: end ?? this.end,
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
      position: position ?? this.position,
      shaderCallback: shaderCallback ?? this.shaderCallback,
      radius: radius ?? this.radius,
      offset: offset ?? this.offset,
      paintingStyle: paintingStyle ?? this.paintingStyle,
      strokeCap: strokeCap ?? this.strokeCap,
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
      other.shaderCallback == shaderCallback &&
      other.radius == radius &&
      other.offset == offset &&
      other.paintingStyle == paintingStyle &&
      other.strokeCap == strokeCap &&
      other.label == label;

  @override
  int get hashCode => Object.hash(
    start,
    end,
    color,
    thickness,
    position,
    shaderCallback,
    radius,
    offset,
    paintingStyle,
    strokeCap,
    label,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('start', start))
      ..add(DoubleProperty('end', end))
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(
        DiagnosticsProperty<GxGaugeLabel>('label', label, defaultValue: null),
      );
  }
}
