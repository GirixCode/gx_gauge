import 'package:flutter/material.dart';
import 'package:girix_code_gauge/src/common/models/models.dart';
import 'package:girix_code_gauge/src/linear/models/linear_gauge_style.dart';
import 'package:girix_code_gauge/src/linear/models/stepper_linear_gauge_model.dart';
import 'package:girix_code_gauge/src/linear/painters/stepper_linear_painter.dart';

/// [GxStepperLinearGauge]: A linear gauge that displays the progress of a process in a linear manner with step-by-step progress indicators.
class GxStepperLinearGauge extends StatelessWidget {
  /// Specifies the value of the gauge.
  /// The value should be between the minimum and maximum values of the gauge.
  /// This value is used to calculate the position of the stepper pointers.
  ///
  /// ```dart
  /// GxStepperLinearGauge(
  ///  value: GaugeValue(
  ///   value: 50,
  ///   min: 0,
  ///   max: 100,
  /// ),
  /// ```
  ///
  final GaugeValue value;

  /// Specifies the height of the gauge.
  /// If the height is not specified, the height of the gauge is calculated based on the size of the gauge.
  ///
  /// ```dart
  /// GxStepperLinearGauge(
  ///  height: 50,
  /// ),
  /// ```
  ///
  final double? height;

  /// Specifies the style of the gauge.
  /// The style includes the color and thickness of the gauge.
  ///
  /// ```dart
  /// GxStepperLinearGauge(
  ///  style: ProgressLinearStyle(
  ///    color: Colors.blue,
  ///    thickness: 5,
  ///  ),
  /// ),
  /// ```
  ///
  final ProgressLinearStyle style;

  /// Specifies the list of stepper pointers.
  /// Each stepper pointer represents a step in the process. The stepper pointer includes the value and label of the step.
  ///
  /// ```dart
  /// GxStepperLinearGauge(
  ///   stepperPointers: [
  ///     StepperPointer(
  ///       value: 20, // Optional
  ///       label: GaugeLabel(
  ///         label: 'Ordered',
  ///         style: TextStyle(color: Colors.black),
  ///       ),
  ///     ),
  ///     StepperPointer(
  ///       value: 40,
  ///       label: GaugeLabel(
  ///         label: 'Packed',
  ///         style: TextStyle(color: Colors.black),
  ///       ),
  ///     ),
  ///   ],
  /// ),
  /// ```
  ///
  final List<StepperPointer> stepperPointers;

  /// Specifies the size of the gauge.
  ///
  /// ```dart
  /// GxStepperLinearGauge(
  ///  size: Size(200, 50),
  /// ),
  /// ```
  ///
  final Size? size;

  /// Specifies the shape of the stepper pointers. The shape can be a circle, rectangle, or diamond.
  ///
  /// ```dart
  /// GxStepperLinearGauge(
  ///  shape: StepperShape.circle,
  /// ),
  /// ```
  final StepperShape shape;

  /// Specifies the size of the stepper pointers.
  ///
  /// ```dart
  /// GxStepperLinearGauge(
  ///   shapeSize: 20,
  /// ),
  /// ```
  ///
  final double shapeSize;

  /// Specifies the style of the active stepper pointers.
  /// The active style includes the color and thickness of the stepper pointers.
  ///
  /// ```dart
  /// GxStepperLinearGauge(
  ///  activeStyle: TextStyle(color: Colors.white),
  /// ),
  /// ```
  ///
  final TextStyle activeStyle;

  /// Specifies the style of the inactive stepper pointers.
  /// The inactive style includes the color and thickness of the stepper pointers.
  ///
  /// ```dart
  /// GxStepperLinearGauge(
  ///  inActiveStyle: TextStyle(color: Colors.black),
  /// ),
  /// ```
  ///
  final TextStyle inActiveStyle;

  /// Specifies the offset between the gauge and the stepper pointers.
  ///
  /// ```dart
  /// GxStepperLinearGauge(
  ///  offset: 10,
  /// ),
  /// ```
  ///
  final double offset;

  const GxStepperLinearGauge({
    super.key,
    required this.value,
    this.style = const ProgressLinearStyle(color: Colors.blue, thickness: 5),
    required this.stepperPointers,
    this.height,
    this.size,
    this.shape = StepperShape.circle,
    this.shapeSize = 20,
    this.offset = 10,
    this.activeStyle = const TextStyle(color: Colors.white),
    this.inActiveStyle = const TextStyle(color: Colors.black),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: height != null
          ? Size.fromHeight(height!)
          : size ?? const Size.fromHeight(50),
      painter: StepperLinearPainter(
        gaugeValue: value,
        stepperPointers: stepperPointers,
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
