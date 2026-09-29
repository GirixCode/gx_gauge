import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/gauge_value.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/core/gauge_defaults.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/gauge_widgets.dart';
import 'package:gx_gauge/src/core/semantics.dart';
import 'package:gx_gauge/src/radial/models/radial_gauge_style.dart';
import 'package:gx_gauge/src/radial/painters/radial_gauge_painter.dart';

/// A circular gauge: an arc filled up to the value, with optional ticks,
/// labels, needle, pointers and ranges.
///
/// Without a [diameter] it fills the shortest bounded side of its parent.
/// Angles are in degrees, clockwise from 3 o'clock.
///
/// ```dart
/// GxRadialGauge(
///   value: const GxGaugeValue(value: 65),
///   startAngleInDegree: 135,
///   sweepAngleInDegree: 270,
///   showMajorTicks: true,
///   showLabels: true,
///   showNeedle: true,
///   needle: const GxRadialNeedle(),
/// )
/// ```
class GxRadialGauge extends ImplicitlyAnimatedWidget {
  /// Creates a radial gauge.
  const GxRadialGauge({
    super.key,
    required this.value,
    this.style = const GxRadialGaugeStyle(),
    this.diameter,
    this.startAngleInDegree = 0,
    this.sweepAngleInDegree = 360,
    this.interval = 10,
    this.minorTicksPerInterval = 10,
    this.showMajorTicks = false,
    this.showMinorTicks = false,
    this.showLabels = false,
    this.majorTickStyle = const GxRadialTickStyle(),
    this.minorTickStyle = const GxRadialTickStyle(),
    this.labelTickStyle = const GxRadialTickLabelStyle(),
    this.labelFormatter,
    this.labelStyler,
    this.majorTickStyler,
    this.showValueAtCenter = true,
    this.showNeedle = false,
    this.needle,
    this.pointers = const <GxRadialPointer>[],
    this.ranges = const <GxRadialRange>[],
    this.semanticLabel,
    this.semanticValueFormatter,
    super.duration = Duration.zero,
    super.curve = Curves.easeInOut,
    super.onEnd,
  });

  /// The value and its range.
  final GxGaugeValue value;

  /// The arc's colors and thickness.
  final GxRadialGaugeStyle style;

  /// The gauge's diameter. Null fills the shortest bounded side of the
  /// parent, or 200 when unbounded.
  final double? diameter;

  /// Where the arc starts, in degrees clockwise from 3 o'clock. Defaults to 0.
  final double startAngleInDegree;

  /// How far the arc sweeps, in degrees. Defaults to 360.
  final double sweepAngleInDegree;

  /// The step between major ticks. Null uses a tenth of the range. Defaults
  /// to 10.
  final double? interval;

  /// Minor ticks between two major ticks. Defaults to 10.
  final int minorTicksPerInterval;

  /// Whether major ticks are drawn. Defaults to false.
  final bool showMajorTicks;

  /// Whether minor ticks are drawn. Defaults to false.
  final bool showMinorTicks;

  /// Whether tick labels are drawn. Defaults to false.
  final bool showLabels;

  /// Major ticks.
  final GxRadialTickStyle majorTickStyle;

  /// Minor ticks.
  final GxRadialTickStyle minorTickStyle;

  /// Tick label placement and style.
  final GxRadialTickLabelStyle labelTickStyle;

  /// Formats each tick label.
  final GxValueLabelFormatter? labelFormatter;

  /// Returns the label style per tick, replacing [labelTickStyle].
  final GxValueLabelStyler<GxRadialTickLabelStyle>? labelStyler;

  /// Returns the major tick style per tick, replacing [majorTickStyle].
  final GxValueTickStyler<GxRadialTickStyle>? majorTickStyler;

  /// Whether the value is written at the center. Defaults to true.
  final bool showValueAtCenter;

  /// Whether [needle] is drawn. Defaults to false.
  final bool showNeedle;

  /// The needle pointing at the value.
  final GxRadialNeedle? needle;

  /// Extra markers and needles at fixed values.
  final List<GxRadialPointer> pointers;

  /// Colored bands along the arc.
  final List<GxRadialRange> ranges;

  /// Describes the gauge to screen readers.
  final String? semanticLabel;

  /// Formats the value announced by screen readers.
  final GxSemanticValueFormatter? semanticValueFormatter;

  @override
  AnimatedGaugeState<GxRadialGauge> createState() => _GxRadialGaugeState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<GxGaugeValue>('value', value))
      ..add(DiagnosticsProperty<GxRadialGaugeStyle>('style', style))
      ..add(DoubleProperty('diameter', diameter, defaultValue: null))
      ..add(DoubleProperty('startAngleInDegree', startAngleInDegree))
      ..add(DoubleProperty('sweepAngleInDegree', sweepAngleInDegree))
      ..add(DoubleProperty('interval', interval))
      ..add(StringProperty('semanticLabel', semanticLabel, defaultValue: null));
  }
}

class _GxRadialGaugeState extends AnimatedGaugeState<GxRadialGauge> {
  @override
  double get targetValue => widget.value.value;

  @override
  Widget build(BuildContext context) {
    final GxRadialGauge w = widget;
    final GaugeDefaults defaults = GaugeDefaults.of(context);
    final TextDirection direction =
        Directionality.maybeOf(context) ?? TextDirection.ltr;
    final Color color = w.style.color ?? defaults.primary;
    final Color capInner =
        context.findAncestorWidgetOfExactType<Material>()?.color ??
        defaults.surface;

    return gaugeSemantics(
      label: w.semanticLabel,
      value: semanticValue(w.semanticValueFormatter, w.value.value),
      child: RadialGaugeBox(
        diameter: w.diameter,
        child: CustomPaint(
          painter: RadialGaugePainter(
            value: valueAnimation,
            config: RadialPainterConfig(
              scale: GaugeScale(w.value.min, w.value.max),
              style: w.style,
              color: color,
              trackColor:
                  w.style.backgroundColor ?? color.withValues(alpha: 0.2),
              startAngleInDegree: w.startAngleInDegree,
              sweepAngleInDegree: w.sweepAngleInDegree,
              interval: w.interval,
              minorTicksPerInterval: w.minorTicksPerInterval,
              showMajorTicks: w.showMajorTicks,
              showMinorTicks: w.showMinorTicks,
              showLabels: w.showLabels,
              majorTickStyle: w.majorTickStyle,
              minorTickStyle: w.minorTickStyle,
              tickColor: defaults.tick,
              labelTickStyle: w.labelTickStyle,
              labelStyle: defaults.labelStyle,
              showValueAtCenter: w.showValueAtCenter,
              valueStyle: defaults.valueStyle,
              showNeedle: w.showNeedle,
              needleColor: defaults.needle,
              pointerColor: defaults.tertiary,
              rangeColor: color,
              capInnerColor: capInner,
              textDirection: direction,
              needle: w.needle,
              pointers: w.pointers,
              ranges: w.ranges,
              labelFormatter: w.labelFormatter,
              labelStyler: w.labelStyler,
              majorTickStyler: w.majorTickStyler,
            ),
          ),
        ),
      ),
    );
  }
}
