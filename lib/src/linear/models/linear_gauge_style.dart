// lib/src/linear/models/linear_gauge_style.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// [GxLinearProgressStyle] is a class that holds the style properties for the GxLinearProgressGauge widget.
///
/// It contains the following properties:
/// - [backgroundColor]: The background color of the GxLinearProgressGauge widget. It is set to Colors.grey by default.
///
///
/// - [thickness]: The thickness of the GxLinearProgressGauge widget. It is set to 10.0 by default.
///
/// - [dense]: A boolean value that determines if the GxLinearProgressGauge widget is dense. It is set to true by default.
class GxLinearProgressStyle extends Equatable {
  const GxLinearProgressStyle({
    this.color = Colors.grey,
    this.backgroundColor,
    this.thickness = 10.0,
    this.dense = true,
    this.radius = const Radius.circular(10),
    this.strokeCap = StrokeCap.butt,
    this.paintingStyle = PaintingStyle.fill,
  });

  /// Specifies the color of the GxLinearProgressGauge widget. The default value is Colors.grey.
  ///
  final Color? backgroundColor;

  /// Specifies the color of the GxLinearProgressGauge widget. The default value is Colors.grey.
  ///
  /// The color property is used to set the color of the GxLinearProgressGauge widget.
  final Color color;

  /// Specifies the thickness of the GxLinearProgressGauge widget. The default value is 10.0.
  ///
  final double thickness;

  /// [dense] is true then Height will be ignored
  final bool dense;

  /// [radius] is the radius of the GxLinearProgressGauge widget. It is set to 10 by default.
  final Radius? radius;

  /// [strokeCap] is the stroke cap of the GxLinearProgressGauge widget. It is set to StrokeCap.butt by default.
  ///
  /// The stroke cap determines the shape of the ends of the line.
  final StrokeCap strokeCap;

  /// [paintingStyle] is the painting style of the GxLinearProgressGauge widget. It is set to PaintingStyle.fill by default.
  ///
  /// The painting style determines how the GxLinearProgressGauge widget is painted.
  final PaintingStyle paintingStyle;

  @override
  List<Object?> get props => <Object?>[
    color,
    backgroundColor,
    thickness,
    dense,
    radius,
  ];
}
