import 'package:gx_gauge/src/common/models/linear_gauge_common_model.dart';

/// [GxStepperStep]: A class that represents a step in the process. The stepper pointer includes the value and label of the step.
///
/// The following properties are required to create a [GxStepperStep]:
///  * [value]: The value of the step. The value should be between the minimum and maximum values of the gauge.
/// * [label]: The label of the step. The label is displayed on the gauge.
class GxStepperStep {
  const GxStepperStep({this.value, required this.label});

  /// Specifies the value of the step. The value should be between the minimum and maximum values of the gauge.
  ///
  /// ```dart
  /// GxStepperStep(
  ///  value: 20,
  /// ),
  /// ```
  ///
  final double? value;

  /// Specifies the label of the step. The label is displayed on the gauge.
  ///
  /// ```dart
  /// GxStepperStep(
  ///  label: GxGaugeLabel(
  ///    label: 'Ordered',
  ///   style: TextStyle(color: Colors.black),
  /// ),
  /// ```
  ///
  final GxGaugeLabel label;
}
