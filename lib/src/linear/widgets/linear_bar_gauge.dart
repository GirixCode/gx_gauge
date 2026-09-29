import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/gauge_tooltip.dart';
import 'package:gx_gauge/src/common/models/gauge_value.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/core/gauge_defaults.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/gauge_widgets.dart';
import 'package:gx_gauge/src/core/semantics.dart';
import 'package:gx_gauge/src/linear/models/linear_bar_pointer.dart';
import 'package:gx_gauge/src/linear/models/linear_needle.dart';
import 'package:gx_gauge/src/linear/painters/linear_bar_painter.dart';

/// A horizontal gauge made of colored bars, with an optional needle and
/// tooltip at the current value.
///
/// Takes the full available width.
///
/// ```dart
/// GxLinearBarGauge(
///   value: const GxGaugeValue(value: 72),
///   bars: const <GxLinearBarPointer>[
///     GxLinearBarPointer(start: 0, end: 50, color: Colors.green),
///     GxLinearBarPointer(start: 50, end: 80, color: Colors.orange),
///     GxLinearBarPointer(start: 80, end: 100, color: Colors.red),
///   ],
///   gapBetweenBars: 4,
///   needle: const GxLinearNeedle(position: GxNeedlePosition.top),
/// )
/// ```
class GxLinearBarGauge extends ImplicitlyAnimatedWidget {
  /// Creates a linear bar gauge.
  const GxLinearBarGauge({
    super.key,
    required this.value,
    required this.bars,
    this.height = 20,
    this.gapBetweenBars = 0,
    this.needle,
    this.needlePainter,
    this.tooltip,
    this.reverse = false,
    this.semanticLabel,
    this.semanticValueFormatter,
    super.duration = Duration.zero,
    super.curve = Curves.easeInOut,
    super.onEnd,
  });

  /// The value and its range.
  final GxGaugeValue value;

  /// The bars, each covering `start..end` of the range.
  final List<GxLinearBarPointer> bars;

  /// The bars' height. Defaults to 20.
  final double height;

  /// Space in logical pixels between adjacent bars. Defaults to 0.
  final double gapBetweenBars;

  /// An optional needle at the current value.
  final GxLinearNeedle? needle;

  /// Draws the needle when its shape is `GxNeedleShape.custom`. Pass a
  /// stable (top-level or static) function to avoid needless repaints.
  final GxNeedlePainter? needlePainter;

  /// An optional value bubble above or below the gauge.
  final GxGaugeTooltip? tooltip;

  /// Runs from the end instead of the start. In a right-to-left locale the
  /// gauge already runs from the right, and [reverse] flips it back.
  final bool reverse;

  /// Describes the gauge to screen readers.
  final String? semanticLabel;

  /// Formats the value announced by screen readers.
  final GxSemanticValueFormatter? semanticValueFormatter;

  @override
  AnimatedGaugeState<GxLinearBarGauge> createState() =>
      _GxLinearBarGaugeState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<GxGaugeValue>('value', value))
      ..add(IntProperty('bars', bars.length))
      ..add(DoubleProperty('height', height, defaultValue: 20.0))
      ..add(DoubleProperty('gapBetweenBars', gapBetweenBars, defaultValue: 0.0))
      ..add(FlagProperty('reverse', value: reverse, ifTrue: 'reversed'))
      ..add(StringProperty('semanticLabel', semanticLabel, defaultValue: null));
  }
}

class _GxLinearBarGaugeState extends AnimatedGaugeState<GxLinearBarGauge> {
  @override
  double get targetValue => widget.value.value;

  @override
  Widget build(BuildContext context) {
    final GxLinearBarGauge w = widget;
    final GaugeDefaults defaults = GaugeDefaults.of(context);
    final TextDirection direction =
        Directionality.maybeOf(context) ?? TextDirection.ltr;

    return gaugeSemantics(
      label: w.semanticLabel,
      value: semanticValue(w.semanticValueFormatter, w.value.value),
      child: LinearGaugeBox(
        height: w.height,
        child: CustomPaint(
          painter: LinearBarPainter(
            value: valueAnimation,
            config: BarPainterConfig(
              scale: GaugeScale(w.value.min, w.value.max),
              bars: w.bars,
              barColor: defaults.primary,
              labelStyle: defaults.labelStyle,
              needleColor: defaults.needle,
              tooltipColor: defaults.tooltip,
              tooltipTextColor: defaults.onTooltip,
              reversed: (direction == TextDirection.rtl) != w.reverse,
              textDirection: direction,
              gap: w.gapBetweenBars,
              needle: w.needle,
              needlePainter: w.needlePainter,
              tooltip: w.tooltip,
            ),
          ),
        ),
      ),
    );
  }
}
