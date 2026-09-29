import 'package:flutter/foundation.dart';
import 'package:gx_gauge/src/common/models/gauge_label.dart';

/// One step of a `GxLinearStepperGauge`.
///
/// ```dart
/// const GxStepperStep(label: GxGaugeLabel(label: 'Shipped'))
/// ```
@immutable
class GxStepperStep with Diagnosticable {
  /// Creates a step.
  const GxStepperStep({this.value, required this.label});

  /// The number shown inside the step's marker. Null shows the step's
  /// 1-based position. (Steps are always evenly spaced.)
  final double? value;

  /// The text shown under the step.
  final GxGaugeLabel label;

  /// Returns a copy with the given fields replaced.
  GxStepperStep copyWith({double? value, GxGaugeLabel? label}) {
    return GxStepperStep(
      value: value ?? this.value,
      label: label ?? this.label,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxStepperStep && other.value == value && other.label == label;

  @override
  int get hashCode => Object.hash(value, label);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('value', value, defaultValue: null))
      ..add(DiagnosticsProperty<GxGaugeLabel>('label', label));
  }
}
