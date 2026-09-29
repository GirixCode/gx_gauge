// lib/src/linear/widgets/linear_gauge.dart

import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/linear_gauge_common_model.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/linear/models/linear_gauge_style.dart';
import 'package:gx_gauge/src/linear/models/linear_needle_model.dart';
import 'package:gx_gauge/src/linear/painters/progress_linear_painter.dart';

/// The [GxLinearProgressGauge] widget is used to display a linear gauge.
///
/// The [GxLinearProgressGauge] widget requires the following properties:
///
/// - [value]: An instance of the [GxGaugeValue] class that holds the value of the gauge.
///
/// - [style]: An instance of the [GxLinearProgressStyle] class that holds the style properties of the gauge.
///
/// - [needle]: An instance of the [GxLinearNeedle] class that holds the needle properties of the Needle.
///
/// - [needlePainter]: A function that takes a Canvas and Offset as arguments and returns void. This function is used to draw a custom needle.
///
/// - [reverse]: A boolean value that determines if the gauge is reversed.
///
/// - [showLabel]: A boolean value that determines if the label is shown.
///
/// - [height]: A double value that determines the height of the gauge.
class GxLinearProgressGauge extends StatelessWidget {
  const GxLinearProgressGauge({
    super.key,
    required this.value,
    this.style = const GxLinearProgressStyle(),
    this.label,
    this.needle,
    this.needlePainter,
    this.reverse = false,
    this.showLabel = false,
    this.height,
  });

  /// Specifies the value of the gauge. It is required.
  ///
  /// [value] GxGaugeValue: The value of the gauge.
  ///
  /// ```dart
  /// GxLinearProgressGauge(
  ///  value: GxGaugeValue(value: 50),
  /// )
  /// ```
  ///
  final GxGaugeValue value;

  /// Specifies the style of the gauge. Default is GxLinearProgressStyle().
  ///
  /// [style] GxLinearProgressStyle: The style of the gauge.
  ///
  /// ```dart
  /// GxLinearProgressGauge(
  ///  value: GxGaugeValue(value: 50),
  ///  style: GxLinearProgressStyle(
  ///   color: Colors.blue,
  ///   backgroundColor: Colors.grey,
  ///   thickness: 10.0,
  ///  ),
  /// )
  /// ```
  ///
  final GxLinearProgressStyle style;

  /// Specifies the label of the gauge. Default is null.
  ///
  /// [label] GxGaugeLabel: The label of the gauge. If label contains {value} then it will be replaced with the value.
  ///
  /// ```dart
  /// GxLinearProgressGauge(
  ///  value: GxGaugeValue(value: 50),
  ///  label: GxGaugeLabel(
  ///   label: 'Label {value}',
  ///   style: TextStyle(color: Colors.black),
  ///  ),
  /// )
  /// ```
  ///

  final GxGaugeLabel? label;

  /// Specifies the needle of the gauge. Default is null.
  ///
  /// [needle] GxLinearNeedle: The needle of the gauge.
  ///
  /// ```dart
  /// GxLinearProgressGauge(
  ///  value: GxGaugeValue(value: 50),
  ///  needle: GxLinearNeedle(
  ///   position: GxNeedlePosition.center,
  ///   size: Size(20, 20),
  ///   color: Colors.blueGrey[800]!,
  ///  )
  /// )
  /// ```
  ///
  final GxLinearNeedle? needle;

  /// Specifies the needlePainter of the gauge. Default is null.
  ///
  /// [needlePainter] [GxNeedlePainter]: draws the needle when its shape is `GxNeedleShape.custom`.
  ///
  /// ```dart
  /// GxLinearProgressGauge(
  ///  value: GxGaugeValue(value: 50),
  ///  needlePainter: (Canvas canvas, Offset position) {
  ///    final Paint paint = Paint()
  ///    ..color = Colors.blue
  ///    ..strokeWidth = 2;
  ///    canvas.drawLine(position, Offset(position.dx, position.dy + 20), paint);
  ///  },
  /// )
  /// ```
  ///
  final GxNeedlePainter? needlePainter;

  /// Specifies the reverse of the gauge. Default is false.
  ///
  /// [reverse] bool: The reverse of the gauge.
  ///
  /// ```dart
  /// GxLinearProgressGauge(
  ///  value: GxGaugeValue(value: 50),
  ///  reverse: true,
  /// )
  /// ```
  ///
  final bool reverse;

  /// Specifies the showLabel of the gauge. Default is false.
  ///
  /// [showLabel] bool: The showLabel of the gauge.
  ///
  /// ```dart
  /// GxLinearProgressGauge(
  ///  value: GxGaugeValue(value: 50),
  ///  showLabel: true,
  /// )
  /// ```
  ///
  final bool showLabel;

  /// Specifies the height of the gauge. Default is null.
  ///
  /// [height] double: The height of the gauge.
  ///
  /// ```dart
  /// GxLinearProgressGauge(
  ///  value: GxGaugeValue(value: 50),
  ///  height: 40,
  /// )
  /// ```
  ///
  final double? height;

  @override
  Widget build(BuildContext context) {
    final Size size = Size.fromHeight(height ?? style.thickness);

    return CustomPaint(
      size: size,
      painter: ProgressLinearPainter(
        label: label,
        style: style,
        gaugeValue: value,
        needle: needle,
        needlePainter: needlePainter,
        reverse: reverse,
        showLabel: showLabel,
        height: height,
      ),
    );
  }
}
