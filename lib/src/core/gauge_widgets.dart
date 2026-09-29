import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/linear_frame.dart';
import 'package:gx_gauge/src/core/semantics.dart';

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

/// Gives a linear gauge its full available length (or
/// [kGaugeFallbackExtent] when unbounded) and a fixed [thickness] across it.
///
/// Horizontal gauges fill the width; vertical gauges fill the height.
class LinearGaugeBox extends StatelessWidget {
  /// Creates a box around [child].
  const LinearGaugeBox({
    super.key,
    required this.thickness,
    required this.child,
    this.direction = Axis.horizontal,
  });

  /// The gauge's extent across its track: its height when horizontal, its
  /// width when vertical.
  final double thickness;

  /// The track's direction.
  final Axis direction;

  /// The gauge's paint.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (direction == Axis.vertical) {
          return SizedBox(
            width: thickness,
            height: constraints.hasBoundedHeight
                ? constraints.maxHeight
                : kGaugeFallbackExtent,
            child: child,
          );
        }
        return SizedBox(
          width: constraints.hasBoundedWidth
              ? constraints.maxWidth
              : kGaugeFallbackExtent,
          height: thickness,
          child: child,
        );
      },
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
///
/// When [onChanged] is set the node is adjustable, like a `Slider`: screen
/// reader increase/decrease gestures move the value by [step], clamped to
/// [min]..[max].
Widget gaugeSemantics({
  required String? label,
  required String value,
  required Widget child,
  double current = 0,
  double min = 0,
  double max = 0,
  double step = 0,
  ValueChanged<double>? onChanged,
  String Function(double value)? format,
}) {
  final bool adjustable = onChanged != null && step > 0 && format != null;
  final double up = (current + step).clamp(min, max);
  final double down = (current - step).clamp(min, max);
  return Semantics(
    container: true,
    label: label,
    value: value,
    slider: adjustable,
    increasedValue: adjustable ? format(up) : null,
    decreasedValue: adjustable ? format(down) : null,
    onIncrease: adjustable ? () => onChanged(up) : null,
    onDecrease: adjustable ? () => onChanged(down) : null,
    child: RepaintBoundary(child: child),
  );
}

/// Turns taps and drags on a gauge into values.
///
/// Does nothing (and adds no gesture detector) when [onChanged] is null, so
/// gauges are read-only by default. Dragging is restricted to [dragAxis] when
/// given, so a horizontal gauge inside a vertical list doesn't steal the
/// list's scroll gesture.
class GaugeInteraction extends StatefulWidget {
  /// Creates an interaction layer around [child].
  const GaugeInteraction({
    super.key,
    required this.valueAt,
    required this.child,
    this.onChanged,
    this.onChangeEnd,
    this.dragAxis,
  });

  /// Maps a position within the gauge (of the given size) to a value.
  final double Function(Offset localPosition, Size size) valueAt;

  /// Called with the new value on every tap and drag update.
  final ValueChanged<double>? onChanged;

  /// Called with the final value when a tap or drag ends.
  final ValueChanged<double>? onChangeEnd;

  /// The drag direction, or null to accept drags in any direction.
  final Axis? dragAxis;

  /// The gauge.
  final Widget child;

  @override
  State<GaugeInteraction> createState() => _GaugeInteractionState();
}

class _GaugeInteractionState extends State<GaugeInteraction> {
  double? _last;

  void _update(Offset position) {
    final Size? size = context.size;
    if (size == null || size.isEmpty) {
      return;
    }
    final double value = widget.valueAt(position, size);
    _last = value;
    widget.onChanged?.call(value);
  }

  void _end() {
    final double? last = _last;
    if (last != null) {
      widget.onChangeEnd?.call(last);
    }
    _last = null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onChanged == null) {
      return widget.child;
    }
    final Axis? axis = widget.dragAxis;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (TapDownDetails d) => _update(d.localPosition),
        onTapUp: (TapUpDetails _) => _end(),
        onHorizontalDragStart: axis == Axis.horizontal
            ? (DragStartDetails d) => _update(d.localPosition)
            : null,
        onHorizontalDragUpdate: axis == Axis.horizontal
            ? (DragUpdateDetails d) => _update(d.localPosition)
            : null,
        onHorizontalDragEnd: axis == Axis.horizontal
            ? (DragEndDetails _) => _end()
            : null,
        onVerticalDragStart: axis == Axis.vertical
            ? (DragStartDetails d) => _update(d.localPosition)
            : null,
        onVerticalDragUpdate: axis == Axis.vertical
            ? (DragUpdateDetails d) => _update(d.localPosition)
            : null,
        onVerticalDragEnd: axis == Axis.vertical
            ? (DragEndDetails _) => _end()
            : null,
        onPanStart: axis == null
            ? (DragStartDetails d) => _update(d.localPosition)
            : null,
        onPanUpdate: axis == null
            ? (DragUpdateDetails d) => _update(d.localPosition)
            : null,
        onPanEnd: axis == null ? (DragEndDetails _) => _end() : null,
        child: widget.child,
      ),
    );
  }
}

/// The shared outer layers of a linear gauge: sizing, optional interaction,
/// and semantics.
///
/// [trackFor] returns the track (in logical, horizontal coordinates) for a
/// logical size, so taps and drags map back to values exactly as painting
/// maps values to positions.
Widget linearGaugeShell({
  required Axis direction,
  required double thickness,
  required GaugeScale scale,
  required double value,
  required String? semanticLabel,
  required GxSemanticValueFormatter? semanticValueFormatter,
  required LinearTrack Function(Size logicalSize) trackFor,
  required Widget paint,
  ValueChanged<double>? onChanged,
  ValueChanged<double>? onChangeEnd,
}) {
  final bool vertical = direction == Axis.vertical;
  String format(double v) => semanticValue(semanticValueFormatter, v);
  return gaugeSemantics(
    label: semanticLabel,
    value: format(value),
    current: value,
    min: scale.min,
    max: scale.max,
    step: scale.range / 20,
    onChanged: onChanged,
    format: format,
    child: LinearGaugeBox(
      direction: direction,
      thickness: thickness,
      child: GaugeInteraction(
        onChanged: onChanged,
        onChangeEnd: onChangeEnd,
        dragAxis: direction,
        valueAt: (Offset position, Size size) {
          final LinearFrame frame = LinearFrame(size, vertical: vertical);
          final LinearTrack track = trackFor(frame.logicalSize);
          return scale.valueAt(track.fractionAt(frame.toLogical(position).dx));
        },
        child: paint,
      ),
    ),
  );
}

/// Whether a linear gauge runs backwards: mirrored by right-to-left text
/// (horizontal gauges only), and flipped again by `reverse`.
bool linearReversed(BuildContext context, Axis direction, bool reverse) {
  if (direction == Axis.vertical) {
    return reverse;
  }
  final TextDirection text =
      Directionality.maybeOf(context) ?? TextDirection.ltr;
  return (text == TextDirection.rtl) != reverse;
}
