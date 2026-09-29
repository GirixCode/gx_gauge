import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';

/// A gauge's current [value] and the `[min, max]` range it is drawn on.
///
/// ```dart
/// const GxGaugeValue(value: 72, min: 0, max: 120)
/// ```
@immutable
class GxGaugeValue with Diagnosticable {
  /// Creates a value. [min] must be less than [max], and [value] must lie
  /// within them.
  const GxGaugeValue({required this.value, this.min = 0, this.max = 100})
    : assert(min < max, 'min ($min) must be less than max ($max)'),
      assert(
        value >= min && value <= max,
        'value ($value) must be between min ($min) and max ($max)',
      );

  /// The value the gauge shows.
  final double value;

  /// The start of the scale. Defaults to 0.
  final double min;

  /// The end of the scale. Defaults to 100.
  final double max;

  /// [value]'s position on the scale, from 0 (at [min]) to 1 (at [max]).
  double get fraction => (value - min) / (max - min);

  /// Returns a copy with the given fields replaced.
  GxGaugeValue copyWith({double? value, double? min, double? max}) {
    return GxGaugeValue(
      value: value ?? this.value,
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }

  /// Linearly interpolates between [a] and [b]. The result's value is clamped
  /// to its interpolated range.
  static GxGaugeValue lerp(GxGaugeValue a, GxGaugeValue b, double t) {
    final double min = lerpDouble(a.min, b.min, t)!;
    final double max = lerpDouble(a.max, b.max, t)!;
    final double value = lerpDouble(a.value, b.value, t)!.clamp(min, max);
    return GxGaugeValue(value: value, min: min, max: max);
  }

  @override
  bool operator ==(Object other) =>
      other is GxGaugeValue &&
      other.value == value &&
      other.min == min &&
      other.max == max;

  @override
  int get hashCode => Object.hash(value, min, max);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('value', value))
      ..add(DoubleProperty('min', min, defaultValue: 0.0))
      ..add(DoubleProperty('max', max, defaultValue: 100.0));
  }
}
