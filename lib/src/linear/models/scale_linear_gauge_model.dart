import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/linear/models/linear_needle_model.dart';

class GxLinearFillArea {
  GxLinearFillArea({
    required this.startValue,
    required this.endValue,
    required this.color,
    this.thickness = 5.0,
    this.position = GxElementPosition.cross,
    this.shaderCallback,
    this.borderColor,
    this.borderWidth = 5.0,
    this.offset = 0.0,
  });
  final double startValue;
  final double endValue;
  final Color color;
  final double thickness;
  final GxElementPosition position;
  Shader Function(Rect)? shaderCallback;
  final Color? borderColor;
  final double borderWidth;
  final double offset;
}

class GxLinearAxisStyle {
  const GxLinearAxisStyle({
    this.thickness = 5.0,
    this.color = Colors.grey,
    this.strokeCap = StrokeCap.butt,
    this.paintingStyle = PaintingStyle.stroke,
  });
  final double thickness;
  final Color color;
  final StrokeCap strokeCap;
  final PaintingStyle paintingStyle;
}

// class LinearGaugeRange {
//   final double startValue;
//   final double endValue;
//   final Color color;
//   final String? label;
//   LinearGaugeRange({
//     required this.startValue,
//     required this.endValue,
//     required this.color,
//     this.label,
//   });
// }

class GxLinearMarkerPointer {
  GxLinearMarkerPointer({required this.value, this.marker, this.needle});
  final double value;
  final Widget? marker;
  final GxLinearNeedle? needle;
}

/// The [GxLinearTickStyle] class holds the style properties of the ticks in the linear gauge.
///
/// The [GxLinearTickStyle] class requires the following properties:
///
/// - [length]: A double value that holds the length of the tick.
///
/// - [thickness]: A double value that holds the thickness of the tick.
///
/// - [color]: A Color value that holds the color of the tick.
///
/// Example:
///
/// ```dart
/// GxLinearTickStyle(
///  length: 8.0,
///  thickness: 1.0,
///  color: Colors.black,
/// )
/// ```
///
class GxLinearTickStyle {
  const GxLinearTickStyle({
    this.length = 8.0,
    this.thickness = 1.0,
    this.color = Colors.grey,
  });

  /// Specifies the length (size) of the tick in the linear gauge.
  ///
  /// The default value is 8.0.
  ///

  final double length;

  /// Specifies the thickness of the tick in the linear gauge.
  ///
  /// The default value is 1.0.
  ///
  final double thickness;

  /// Specifies the color of the tick in the linear gauge.
  ///
  /// The default value is Colors.black.
  ///

  final Color color;

  // CopyWith method
  GxLinearTickStyle copyWith({
    double? length,
    double? thickness,
    Color? color,
  }) {
    return GxLinearTickStyle(
      length: length ?? this.length,
      thickness: thickness ?? this.thickness,
      color: color ?? this.color,
    );
  }
}
