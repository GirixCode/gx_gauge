import 'dart:ui';

import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/linear/models/linear_needle.dart';

/// Formats a scale value as label text.
///
/// [value] is the value at the tick, and [index] is the tick's position,
/// starting at 0.
///
/// ```dart
/// labelFormatter: (double value, int index) => '${value.toInt()}%',
/// ```
typedef GxValueLabelFormatter = String Function(double value, int index);

/// Returns the label style of type [T] for the tick at [value] and [index].
///
/// Linear gauges use `GxValueLabelStyler<TextStyle>`, and radial gauges use
/// `GxValueLabelStyler<GxRadialTickLabelStyle>`.
///
/// ```dart
/// labelStyler: (double value, int index) =>
///     TextStyle(color: value > 80 ? Colors.red : Colors.black),
/// ```
typedef GxValueLabelStyler<T> = T Function(double value, int index);

/// Returns the major tick style of type [T] for the tick at [value] and
/// [index].
///
/// Linear gauges use `GxValueTickStyler<GxLinearTickStyle>`, and radial
/// gauges use `GxValueTickStyler<GxRadialTickStyle>`.
///
/// ```dart
/// majorTickStyler: (double value, int index) => GxLinearTickStyle(
///   length: value % 50 == 0 ? 16 : 8,
/// ),
/// ```
typedef GxValueTickStyler<T> = T Function(double value, int index);

/// Draws a custom needle.
///
/// [anchor] is the needle's position on the gauge, and [needle] carries the
/// configured style (color, size, painting style), so the drawing can match
/// the rest of the gauge. Used when the needle's shape is
/// [GxNeedleShape.custom].
///
/// ```dart
/// needlePainter: (Canvas canvas, Offset anchor, GxLinearNeedle needle) {
///   canvas.drawCircle(anchor, needle.size.width / 2, Paint()..color = needle.color);
/// },
/// ```
typedef GxNeedlePainter = void Function(
  Canvas canvas,
  Offset anchor,
  GxLinearNeedle needle,
);
