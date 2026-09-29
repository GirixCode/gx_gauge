// lib/src/linear/models/linear_gauge_style.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// [ProgressLinearStyle] is a class that holds the style properties for the GxProgressLinearGauge widget.
///
/// It contains the following properties:
/// - [size]: The size of the GxProgressLinearGauge widget. It is a required property.
///
/// - [backgroundColor]: The background color of the GxProgressLinearGauge widget. It is set to Colors.grey by default.
///
///
/// - [thickness]: The thickness of the GxProgressLinearGauge widget. It is set to 10.0 by default.
///
/// - [dense]: A boolean value that determines if the GxProgressLinearGauge widget is dense. It is set to true by default.
class ProgressLinearStyle extends Equatable {
  /// Specifies the color of the GxProgressLinearGauge widget. The default value is Colors.grey.
  ///
  final Color? backgroundColor;

  /// Specifies the color of the GxProgressLinearGauge widget. The default value is Colors.grey.
  ///
  /// The color property is used to set the color of the GxProgressLinearGauge widget.
  final Color color;

  /// Specifies the thickness of the GxProgressLinearGauge widget. The default value is 10.0.
  ///
  final double thickness;

  /// [dense] is true then Height will be ignored
  final bool dense;

  /// [radius] is the radius of the GxProgressLinearGauge widget. It is set to 10 by default.
  final Radius? radius;

  /// [strokeCap] is the stroke cap of the GxProgressLinearGauge widget. It is set to StrokeCap.butt by default.
  ///
  /// The stroke cap determines the shape of the ends of the line.
  final StrokeCap strokeCap;

  /// [paintingStyle] is the painting style of the GxProgressLinearGauge widget. It is set to PaintingStyle.fill by default.
  ///
  /// The painting style determines how the GxProgressLinearGauge widget is painted.
  final PaintingStyle paintingStyle;

  const ProgressLinearStyle({
    this.color = Colors.grey,
    this.backgroundColor,
    this.thickness = 10.0,
    this.dense = true,
    this.radius = const Radius.circular(10),
    this.strokeCap = StrokeCap.butt,
    this.paintingStyle = PaintingStyle.fill,
  });

  @override
  List<Object?> get props =>
      <Object?>[color, backgroundColor, thickness, dense, radius];
}
