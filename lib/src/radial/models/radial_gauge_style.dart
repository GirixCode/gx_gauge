// lib/src/radial/models/radial_gauge_style.dart

import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/models.dart';

class GxNeedleCap {
  const GxNeedleCap({
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

class GxRadialRange {
  const GxRadialRange({
    required this.startValue,
    required this.endValue,
    required this.label,
    this.color,
    this.height = 10,
    this.offset = 0,
  });
  final double startValue;
  final double endValue;
  final GxGaugeLabel label;
  final Color? color;
  final double height;
  final double offset;
}

/// [GxRadialGaugeStyle] is a class that holds the style properties for the RadialGauge widget.
///
/// It contains the following properties:
///
/// - [backgroundColor]: The background color of the RadialGauge widget. It is set to Colors.grey by default.
///
/// - [thickness]: The stroke width of the RadialGauge widget. It is set to 10.0 by default.
///
class GxRadialGaugeStyle {
  const GxRadialGaugeStyle({
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

  /// [thickness] is the stroke width of the GxLinearProgressGauge widget. It is set to 10.0 by default.
  ///
  /// The thickness determines the width of the line.
  ///
  final double thickness;

  /// [strokeCap] is the stroke cap of the GxLinearProgressGauge widget. It is set to StrokeCap.butt by default.
  ///
  /// The stroke cap determines the shape of the ends of the line.
  final StrokeCap strokeCap;

  /// [paintingStyle] is the painting style of the GxLinearProgressGauge widget. It is set to PaintingStyle.fill by default.
  ///
  /// The painting style determines how the GxLinearProgressGauge widget is painted.
  final PaintingStyle paintingStyle;

  final Gradient? gradient;

  final Gradient? backgroundGradient;
}

// Radial Gauge Needle
class GxRadialNeedle {
  const GxRadialNeedle({
    this.color = Colors.red,
    this.topOffest,
    this.bottomOffset,
    this.alignment = GxRadialElementAlignment.center,
    this.circle = const GxNeedleCap(),
    this.thickness = 10.0,
    this.shape = GxRadialNeedleShape.taperedLine,
    this.strokeCap = StrokeCap.round,
    this.gradient,
  });
  final Color color;
  final double? bottomOffset;
  final double? topOffest;
  final GxRadialElementAlignment alignment;
  final GxNeedleCap circle;
  final double thickness;
  final GxRadialNeedleShape shape;
  final StrokeCap strokeCap;
  final Gradient? gradient;
}

class GxRadialPointer {
  const GxRadialPointer({
    required this.value,
    this.style = const GxRadialPointerStyle(),
    this.needle,
    this.alignment = GxRadialElementAlignment.center,
    this.shape = GxRadialPointerShape.circle,
    this.showNeedle = true,
    this.showPointer = true,
  });
  final double value;
  final GxRadialNeedle? needle;
  final GxRadialElementAlignment alignment;
  final GxRadialPointerShape shape;
  final GxRadialPointerStyle style;
  final bool showNeedle;
  final bool showPointer;
}

/// radial Pointers
///
class GxRadialPointerStyle {
  const GxRadialPointerStyle({
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

class GxRadialTickLabelStyle {
  const GxRadialTickLabelStyle({
    this.style = const TextStyle(fontSize: 12, color: Colors.black),
    this.position = GxRadialElementPosition.inside,
    this.padding = 20,
    this.offset = 0,
  });
  final TextStyle style;
  final GxRadialElementPosition position;
  final double padding;
  final double offset;
}

class GxRadialTickStyle {
  const GxRadialTickStyle({
    this.length = 8.0,
    this.thickness = 1.0,
    this.color = Colors.grey,
    this.alignment = GxRadialElementAlignment.center,
    this.position = GxRadialElementPosition.inside,
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
  /// The default value is GxRadialElementAlignment.inside.
  final GxRadialElementAlignment alignment;

  /// Specifies the position of the tick on the axis.
  ///
  /// The default value is GxRadialElementPosition.center.
  ///
  final GxRadialElementPosition position;

  // CopyWith method
  GxRadialTickStyle copyWith({
    double? length,
    double? thickness,
    Color? color,
  }) {
    return GxRadialTickStyle(
      length: length ?? this.length,
      thickness: thickness ?? this.thickness,
      color: color ?? this.color,
    );
  }
}
