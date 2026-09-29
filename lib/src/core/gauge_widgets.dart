import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Width used by linear gauges, and diameter used by radial gauges, when the
/// parent gives unbounded constraints (e.g. inside a horizontal `Row` or a
/// scroll view).
const double kGaugeFallbackExtent = 200;

/// Shared implicit-animation state for gauges.
///
/// Tweens the gauge's value from wherever it currently is to [targetValue]
/// whenever the widget's value changes. An interrupted animation therefore
/// continues from the value on screen instead of jumping back. Painters read
/// [valueAnimation] through `CustomPainter(repaint:)`, so frames repaint
/// without rebuilding the widget.
abstract class AnimatedGaugeState<T extends ImplicitlyAnimatedWidget>
    extends ImplicitlyAnimatedWidgetState<T> {
  Tween<double>? _value;
  late Animation<double> _valueAnimation;

  /// The value the gauge should settle on.
  double get targetValue;

  /// The current, possibly overshooting (e.g. elastic curve), value.
  Animation<double> get valueAnimation => _valueAnimation;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _value = visitor(
      _value,
      targetValue,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  @override
  void didUpdateTweens() {
    _valueAnimation = _value!.animate(animation);
  }
}

/// Gives a linear gauge its full available width (or [kGaugeFallbackExtent]
/// when unbounded) and a fixed [height].
class LinearGaugeBox extends StatelessWidget {
  /// Creates a box of [height] around [child].
  const LinearGaugeBox({super.key, required this.height, required this.child});

  /// The gauge's height in logical pixels.
  final double height;

  /// The gauge's paint.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => SizedBox(
        width: constraints.hasBoundedWidth
            ? constraints.maxWidth
            : kGaugeFallbackExtent,
        height: height,
        child: child,
      ),
    );
  }
}

/// Gives a radial gauge a square of [diameter], or of the shortest bounded
/// side of its constraints, or [kGaugeFallbackExtent] when both are
/// unbounded.
class RadialGaugeBox extends StatelessWidget {
  /// Creates a square box around [child].
  const RadialGaugeBox({super.key, this.diameter, required this.child});

  /// The explicit diameter, or null to fill the available space.
  final double? diameter;

  /// The gauge's paint.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double extent = diameter ?? _fit(constraints);
        return SizedBox.square(dimension: extent, child: child);
      },
    );
  }

  static double _fit(BoxConstraints constraints) {
    final bool width = constraints.hasBoundedWidth;
    final bool height = constraints.hasBoundedHeight;
    if (width && height) {
      return math.min(constraints.maxWidth, constraints.maxHeight);
    }
    if (width) {
      return constraints.maxWidth;
    }
    if (height) {
      return constraints.maxHeight;
    }
    return kGaugeFallbackExtent;
  }
}

/// Wraps a gauge's paint in a [RepaintBoundary] and exposes its value to
/// assistive technologies.
Widget gaugeSemantics({
  required String? label,
  required String value,
  required Widget child,
}) {
  return Semantics(
    container: true,
    label: label,
    value: value,
    child: RepaintBoundary(child: child),
  );
}
