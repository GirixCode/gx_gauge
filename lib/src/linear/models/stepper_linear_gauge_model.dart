import 'package:girix_code_gauge/src/common/models/linear_gauge_common_model.dart';

/// [StepperPointer]: A class that represents a step in the process. The stepper pointer includes the value and label of the step.
///
/// The following properties are required to create a [StepperPointer]:
///  * [value]: The value of the step. The value should be between the minimum and maximum values of the gauge.
/// * [label]: The label of the step. The label is displayed on the gauge.
class StepperPointer {
  /// Specifies the value of the step. The value should be between the minimum and maximum values of the gauge.
  ///
  /// ```dart
  /// StepperPointer(
  ///  value: 20,
  /// ),
  /// ```
  ///
  final double? value;

  /// Specifies the label of the step. The label is displayed on the gauge.
  ///
  /// ```dart
  /// StepperPointer(
  ///  label: GaugeLabel(
  ///    label: 'Ordered',
  ///   style: TextStyle(color: Colors.black),
  /// ),
  /// ```
  ///
  final GaugeLabel label;

  const StepperPointer({
    this.value,
    required this.label,
  });
}
