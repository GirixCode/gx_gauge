import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/models.dart';
import 'package:gx_gauge/src/linear/models/linear_gauge_style.dart';
import 'package:gx_gauge/src/linear/models/stepper_linear_gauge_model.dart';
import 'package:gx_gauge/src/linear/painters/stepper_linear_painter.dart';

/// [GxLinearStepperGauge]: A linear gauge that displays the progress of a process in a linear manner with step-by-step progress indicators.
class GxLinearStepperGauge extends StatelessWidget {
  const GxLinearStepperGauge({
    super.key,
    required this.value,
    this.style = const GxLinearProgressStyle(color: Colors.blue, thickness: 5),
    required this.steps,
    this.height,
    this.size,
    this.shape = GxStepperShape.circle,
    this.shapeSize = 20,
    this.offset = 10,
    this.activeStyle = const TextStyle(color: Colors.white),
    this.inActiveStyle = const TextStyle(color: Colors.black),
  });

  /// Specifies the value of the gauge.
  /// The value should be between the minimum and maximum values of the gauge.
  /// This value is used to calculate the position of the stepper pointers.
  ///
  /// ```dart
  /// GxLinearStepperGauge(
  ///  value: GxGaugeValue(
  ///   value: 50,
  ///   min: 0,
  ///   max: 100,
  /// ),
  /// ```
  ///
  final GxGaugeValue value;

  /// Specifies the height of the gauge.
  /// If the height is not specified, the height of the gauge is calculated based on the size of the gauge.
  ///
  /// ```dart
  /// GxLinearStepperGauge(
  ///  height: 50,
  /// ),
  /// ```
  ///
  final double? height;

  /// Specifies the style of the gauge.
  /// The style includes the color and thickness of the gauge.
  ///
  /// ```dart
  /// GxLinearStepperGauge(
  ///  style: GxLinearProgressStyle(
  ///    color: Colors.blue,
  ///    thickness: 5,
  ///  ),
  /// ),
  /// ```
  ///
  final GxLinearProgressStyle style;

  /// Specifies the list of stepper pointers.
  /// Each stepper pointer represents a step in the process. The stepper pointer includes the value and label of the step.
  ///
  /// ```dart
  /// GxLinearStepperGauge(
  ///   steps: [
  ///     GxStepperStep(
  ///       value: 20, // Optional
  ///       label: GxGaugeLabel(
  ///         label: 'Ordered',
  ///         style: TextStyle(color: Colors.black),
  ///       ),
  ///     ),
  ///     GxStepperStep(
  ///       value: 40,
  ///       label: GxGaugeLabel(
  ///         label: 'Packed',
  ///         style: TextStyle(color: Colors.black),
  ///       ),
  ///     ),
  ///   ],
  /// ),
  /// ```
  ///
  final List<GxStepperStep> steps;

  /// Specifies the size of the gauge.
  ///
  /// ```dart
  /// GxLinearStepperGauge(
  ///  size: Size(200, 50),
  /// ),
  /// ```
  ///
  final Size? size;

  /// Specifies the shape of the stepper pointers. The shape can be a circle, rectangle, or diamond.
  ///
  /// ```dart
  /// GxLinearStepperGauge(
  ///  shape: GxStepperShape.circle,
  /// ),
  /// ```
  final GxStepperShape shape;

  /// Specifies the size of the stepper pointers.
  ///
  /// ```dart
  /// GxLinearStepperGauge(
  ///   shapeSize: 20,
  /// ),
  /// ```
  ///
  final double shapeSize;

  /// Specifies the style of the active stepper pointers.
  /// The active style includes the color and thickness of the stepper pointers.
  ///
  /// ```dart
  /// GxLinearStepperGauge(
  ///  activeStyle: TextStyle(color: Colors.white),
  /// ),
  /// ```
  ///
  final TextStyle activeStyle;

  /// Specifies the style of the inactive stepper pointers.
  /// The inactive style includes the color and thickness of the stepper pointers.
  ///
  /// ```dart
  /// GxLinearStepperGauge(
  ///  inActiveStyle: TextStyle(color: Colors.black),
  /// ),
  /// ```
  ///
  final TextStyle inActiveStyle;

  /// Specifies the offset between the gauge and the stepper pointers.
  ///
  /// ```dart
  /// GxLinearStepperGauge(
  ///  offset: 10,
  /// ),
  /// ```
  ///
  final double offset;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: height != null
          ? Size.fromHeight(height!)
          : size ?? const Size.fromHeight(50),
      painter: StepperLinearPainter(
        gaugeValue: value,
        steps: steps,
        shapeSize: shapeSize,
        style: style,
        shape: shape,
        offset: offset,
        activeStyle: activeStyle,
        inActiveStyle: inActiveStyle,
      ),
    );
  }
}
