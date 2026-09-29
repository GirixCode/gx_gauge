import 'package:flutter/foundation.dart';
import 'package:gx_gauge/src/common/models/gauge_label.dart';

/// One step of a `GxLinearStepperGauge`. Steps are evenly spaced.
///
/// ```dart
/// const GxStepperStep(label: GxGaugeLabel(label: 'Shipped'))
/// ```
@immutable
class GxStepperStep with Diagnosticable {
  /// Creates a step.
  const GxStepperStep({required this.label, this.marker});

  /// Text shown inside the step's marker, e.g. '✓'. Null shows the step's
  /// 1-based position.
  final String? marker;

  /// The text shown under the step.
  final GxGaugeLabel label;

  /// Returns a copy with the given fields replaced.
  GxStepperStep copyWith({GxGaugeLabel? label, String? marker}) {
    return GxStepperStep(
      label: label ?? this.label,
      marker: marker ?? this.marker,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxStepperStep && other.marker == marker && other.label == label;

  @override
  int get hashCode => Object.hash(marker, label);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('marker', marker, defaultValue: null))
      ..add(DiagnosticsProperty<GxGaugeLabel>('label', label));
  }
}
