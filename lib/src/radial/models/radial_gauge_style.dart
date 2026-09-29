// lib/src/radial/models/radial_gauge_style.dart

import 'package:flutter/material.dart';
import 'package:girix_code_gauge/src/common/models/models.dart';

class NeedleCircle {
  const NeedleCircle({
    this.color,
    this.radius = 5,
    this.strokeWidth = 1.0,
    this.paintingStyle = PaintingStyle.fill,
    this.innerColor,
  });
  // [Temporary Fix for Needle Overlapping by adding innerColor]
  final Color? color;
  final double radius;
  final double strokeWidth;
  final PaintingStyle paintingStyle;

  /// The inner color of the needle circle. When the [paintingStyle] is set to PaintingStyle.stroke, the [innerColor] is used to fill the circle.
  /// The default value is null.
  ///
  final Color? innerColor;
}

// Radial

class RadialBarRange {
  const RadialBarRange({
    required this.startValue,
    required this.endValue,
    required this.label,
    this.color,
    this.height = 10,
    this.offset = 0,
  });
  final double startValue;
  final double endValue;
  final GaugeLabel label;
  final Color? color;
  final double height;
  final double offset;
}

/// [RadialGaugeStyle] is a class that holds the style properties for the RadialGauge widget.
///
/// It contains the following properties:
///
/// - [size]: The size of the RadialGauge widget. It is a required property.
///
/// - [backgroundColor]: The background color of the RadialGauge widget. It is set to Colors.grey by default.
///
/// - [foregroundColor]: The foreground color of the RadialGauge widget. It is set to Colors.blue by default.
///
/// - [thickness]: The stroke width of the RadialGauge widget. It is set to 10.0 by default.
///
class RadialGaugeStyle {
  const RadialGaugeStyle({
    this.backgroundColor,
    this.color = Colors.blue,
    this.thickness = 10.0,
    this.strokeCap = StrokeCap.round,
    this.paintingStyle = PaintingStyle.stroke,
    this.gradient,
    this.backgroundGradient,
  });

  /// Specifies the background color of the RadialGauge widget. The default value is the opacity of the [color] property.
  ///

  final Color? backgroundColor;

  /// Specifies the color of the RadialGauge widget. The default value is Colors.blue.
  final Color color;

  /// [thickness] is the stroke width of the GxProgressLinearGauge widget. It is set to 10.0 by default.
  ///
  /// The thickness determines the width of the line.
  ///
  final double thickness;

  /// [strokeCap] is the stroke cap of the GxProgressLinearGauge widget. It is set to StrokeCap.butt by default.
  ///
  /// The stroke cap determines the shape of the ends of the line.
  final StrokeCap strokeCap;

  /// [paintingStyle] is the painting style of the GxProgressLinearGauge widget. It is set to PaintingStyle.fill by default.
  ///
  /// The painting style determines how the GxProgressLinearGauge widget is painted.
  final PaintingStyle paintingStyle;

  final Gradient? gradient;

  final Gradient? backgroundGradient;
}

// Radial Gauge Needle
class RadialNeedle {
  const RadialNeedle({
    this.color = Colors.red,
    this.topOffest,
    this.bottomOffset,
    this.alignment = RadialElementAlignment.center,
    this.circle = const NeedleCircle(),
    this.thickness = 10.0,
    this.shape = RadialNeedleShape.tapperedLine,
    this.strokeCap = StrokeCap.round,
    this.gradient,
  });
  final Color color;
  final double? bottomOffset;
  final double? topOffest;
  final RadialElementAlignment alignment;
  final NeedleCircle circle;
  final double thickness;
  final RadialNeedleShape shape;
  final StrokeCap strokeCap;
  final Gradient? gradient;
}

class RadialPointer {
  const RadialPointer({
    required this.value,
    this.style = const RadialPointerStyle(),
    this.needle,
    this.alignment = RadialElementAlignment.center,
    this.shape = RadialPointerShape.circle,
    this.showNeedle = true,
    this.showPointer = true,
  });
  final double value;
  final RadialNeedle? needle;
  final RadialElementAlignment alignment;
  final RadialPointerShape shape;
  final RadialPointerStyle style;
  final bool showNeedle;
  final bool showPointer;
}

/// radial Pointers
///
class RadialPointerStyle {
  const RadialPointerStyle({
    this.color = Colors.red,
    this.thickness = 10.0,
    this.paintingStyle = PaintingStyle.fill,
    this.size = 10.0,
  });
  final Color color;
  final double thickness;
  final PaintingStyle paintingStyle;
  final double size;
}

class RadialTickLabelStyle {
  const RadialTickLabelStyle({
    this.style = const TextStyle(fontSize: 12, color: Colors.black),
    this.position = RadialElementPosition.inside,
    this.padding = 20,
    this.offset = 0,
  });
  final TextStyle style;
  final RadialElementPosition position;
  final double padding;
  final double offset;
}

class RadialTickStyle {
  const RadialTickStyle({
    this.length = 8.0,
    this.thickness = 1.0,
    this.color = Colors.grey,
    this.alignment = RadialElementAlignment.center,
    this.position = RadialElementPosition.inside,
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

  /// Specifies the alignment of the tick on the axis.
  ///
  /// The default value is RadialElementAlignment.inside.
  final RadialElementAlignment alignment;

  /// Specifies the position of the tick on the axis.
  ///
  /// The default value is RadialElementPosition.center.
  ///
  final RadialElementPosition position;

  // CopyWith method
  RadialTickStyle copyWith({
    double? length,
    double? thickness,
    Color? color,
  }) {
    return RadialTickStyle(
      length: length ?? this.length,
      thickness: thickness ?? this.thickness,
      color: color ?? this.color,
    );
  }
}
