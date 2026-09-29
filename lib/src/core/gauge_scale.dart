import 'dart:math' as math;

import 'package:flutter/foundation.dart';

/// Maps gauge values onto the `[min, max]` scale and generates tick values.
///
/// Every painter goes through this class, so value→position math is the same
/// for all gauges: `(value - min) / (max - min)`, clamped to `[0, 1]`.
@immutable
class GaugeScale {
  /// Creates a scale from [min] to [max].
  const GaugeScale(this.min, this.max)
    : assert(min < max, 'min ($min) must be less than max ($max)');

  /// The smallest value on the scale.
  final double min;

  /// The largest value on the scale.
  final double max;

  /// Upper bound on generated ticks, so a tiny interval can't stall painting.
  static const int maxTicks = 1000;

  /// The span of the scale, `max - min`.
  double get range => max - min;

  /// The position of [value] on the scale as a fraction in `[0, 1]`.
  ///
  /// Values outside the scale are clamped, and `NaN` maps to 0.
  double fractionOf(double value) {
    if (value.isNaN) {
      return 0;
    }
    return ((value - min) / range).clamp(0.0, 1.0);
  }

  /// The value at [fraction] along the scale (the inverse of [fractionOf]).
  double valueAt(double fraction) => min + fraction.clamp(0.0, 1.0) * range;

  /// Clamps [value] to `[min, max]`.
  double clamp(double value) => value.isNaN ? min : value.clamp(min, max);

  /// The effective major-tick step for [interval].
  ///
  /// A null, non-finite or non-positive [interval] falls back to a tenth of
  /// the range.
  double stepFor(double? interval) {
    if (interval == null || !interval.isFinite || interval <= 0) {
      return range / 10;
    }
    return interval;
  }

  /// Major tick values from [min] in steps of [interval], up to [max].
  ///
  /// * Values are computed as `min + i * step`, so rounding errors don't
  ///   accumulate, and a small epsilon keeps e.g. `0..0.3` step `0.1` at four
  ///   ticks.
  /// * When the range isn't a multiple of the step, the last tick is the last
  ///   multiple below [max] (0..100 step 30 → 0, 30, 60, 90).
  /// * A step at least as large as the range yields just `[min, max]`.
  List<double> ticks(double? interval) {
    final double step = stepFor(interval);
    if (step >= range) {
      return <double>[min, max];
    }
    final int count = math.min((range / step + 1e-9).floor(), maxTicks - 1);
    return <double>[for (int i = 0; i <= count; i++) min + i * step];
  }

  @override
  bool operator ==(Object other) =>
      other is GaugeScale && other.min == min && other.max == max;

  @override
  int get hashCode => Object.hash(min, max);

  @override
  String toString() => 'GaugeScale($min, $max)';
}

/// A horizontal track on the canvas that fractions of a [GaugeScale] map onto.
@immutable
class LinearTrack {
  /// Creates a track from x = [start] to x = [end].
  ///
  /// When [reversed] is true (right-to-left, or an explicit `reverse`),
  /// fraction 0 maps to [end] and fraction 1 to [start].
  const LinearTrack({
    required this.start,
    required this.end,
    this.reversed = false,
  });

  /// The x coordinate of the track's left edge.
  final double start;

  /// The x coordinate of the track's right edge.
  final double end;

  /// Whether the track runs right to left.
  final bool reversed;

  /// The track's length in logical pixels.
  double get length => end - start;

  /// The x coordinate of [fraction] (0..1) along the track.
  double xOf(double fraction) =>
      reversed ? end - fraction * length : start + fraction * length;

  @override
  bool operator ==(Object other) =>
      other is LinearTrack &&
      other.start == start &&
      other.end == end &&
      other.reversed == reversed;

  @override
  int get hashCode => Object.hash(start, end, reversed);
}

/// Formats a gauge value for display: whole numbers without decimals and
/// other values with at most [fractionDigits] decimals, trailing zeros
/// removed (`40.0` → `40`, `12.50` → `12.5`).
String formatGaugeValue(double value, {int fractionDigits = 1}) {
  if (value.isNaN || value.isInfinite) {
    return value.toString();
  }
  final String fixed = value.toStringAsFixed(fractionDigits);
  if (!fixed.contains('.')) {
    return fixed;
  }
  final String trimmed = fixed.replaceFirst(RegExp(r'\.?0+$'), '');
  return trimmed == '-0' ? '0' : trimmed;
}
