// lib/src/linear/widgets/linear_gauge.dart

import 'package:flutter/material.dart';
import 'package:girix_code_gauge/src/common/models/linear_gauge_common_model.dart';
import 'package:girix_code_gauge/src/linear/models/linear_gauge_style.dart';
import 'package:girix_code_gauge/src/linear/models/linear_needle_model.dart';
import 'package:girix_code_gauge/src/linear/painters/progress_linear_painter.dart';

/// The [GxProgressLinearGauge] widget is used to display a linear gauge.
///
/// The [GxProgressLinearGauge] widget requires the following properties:
///
/// - [value]: An instance of the [GaugeValue] class that holds the value of the gauge.
///
/// - [style]: An instance of the [ProgressLinearStyle] class that holds the style properties of the gauge.
///
/// - [shape]: An instance of the [LinearGaugeShape] enum that holds the shape of the gauge.
///
/// - [needle]: An instance of the [LinearNeedle] class that holds the needle properties of the Needle.
///
/// - [customDrawNeedle]: A function that takes a Canvas and Offset as arguments and returns void. This function is used to draw a custom needle.
///
/// - [reverse]: A boolean value that determines if the gauge is reversed.
///
/// - [showLabel]: A boolean value that determines if the label is shown.
///
/// - [height]: A double value that determines the height of the gauge.
class GxProgressLinearGauge extends StatelessWidget {
  /// Specifies the value of the gauge. It is required.
  ///
  /// [value] GaugeValue: The value of the gauge.
  ///
  /// ```dart
  /// GxProgressLinearGauge(
  ///  value: GaugeValue(value: 50),
  /// )
  /// ```
  ///
  final GaugeValue value;

  /// Specifies the style of the gauge. Default is ProgressLinearStyle().
  ///
  /// [style] ProgressLinearStyle: The style of the gauge.
  ///
  /// ```dart
  /// GxProgressLinearGauge(
  ///  value: GaugeValue(value: 50),
  ///  style: ProgressLinearStyle(
  ///   color: Colors.blue,
  ///   backgroundColor: Colors.grey,
  ///   thickness: 10.0,
  ///  ),
  /// )
  /// ```
  ///
  final ProgressLinearStyle style;

  /// Specifies the label of the gauge. Default is null.
  ///
  /// [label] GaugeLabel: The label of the gauge. If label contains {value} then it will be replaced with the value.
  ///
  /// ```dart
  /// GxProgressLinearGauge(
  ///  value: GaugeValue(value: 50),
  ///  label: GaugeLabel(
  ///   label: 'Label {value}',
  ///   style: TextStyle(color: Colors.black),
  ///  ),
  /// )
  /// ```
  ///

  final GaugeLabel? label;

  /// Specifies the needle of the gauge. Default is null.
  ///
  /// [needle] LinearNeedle: The needle of the gauge.
  ///
  /// ```dart
  /// GxProgressLinearGauge(
  ///  value: GaugeValue(value: 50),
  ///  needle: LinearNeedle(
  ///   position: LinearGaugeNeedlePosition.center,
  ///   size: Size(20, 20),
  ///   color: Colors.blueGrey[800]!,
  ///  )
  /// )
  /// ```
  ///
  final LinearNeedle? needle;

  /// Specifies the customDrawNeedle of the gauge. Default is null.
  ///
  /// [customDrawNeedle] Function(Canvas canvas, Offset position): The customDrawNeedle of the gauge.
  ///
  /// ```dart
  /// GxProgressLinearGauge(
  ///  value: GaugeValue(value: 50),
  ///  customDrawNeedle: (Canvas canvas, Offset position) {
  ///    final Paint paint = Paint()
  ///    ..color = Colors.blue
  ///    ..strokeWidth = 2;
  ///    canvas.drawLine(position, Offset(position.dx, position.dy + 20), paint);
  ///  },
  /// )
  /// ```
  ///
  final void Function(Canvas canvas, Offset position)? customDrawNeedle;

  /// Specifies the reverse of the gauge. Default is false.
  ///
  /// [reverse] bool: The reverse of the gauge.
  ///
  /// ```dart
  /// GxProgressLinearGauge(
  ///  value: GaugeValue(value: 50),
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
  /// GxProgressLinearGauge(
  ///  value: GaugeValue(value: 50),
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
  /// GxProgressLinearGauge(
  ///  value: GaugeValue(value: 50),
  ///  height: 40,
  /// )
  /// ```
  ///
  final double? height;

  const GxProgressLinearGauge(
      {super.key,
      required this.value,
      this.style = const ProgressLinearStyle(),
      this.label,
      this.needle,
      this.customDrawNeedle,
      this.reverse = false,
      this.showLabel = false,
      this.height});

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
          customDrawNeedle: customDrawNeedle,
          reverse: reverse,
          showLabel: showLabel,
          height: height),
    );
  }
}
