import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/common/models/gauge_value.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/core/gauge_defaults.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/gauge_widgets.dart';
import 'package:gx_gauge/src/core/semantics.dart';
import 'package:gx_gauge/src/linear/models/linear_bar_pointer.dart';
import 'package:gx_gauge/src/linear/models/linear_needle.dart';
import 'package:gx_gauge/src/linear/models/linear_scale_models.dart';
import 'package:gx_gauge/src/linear/painters/scale_linear_gauge_painter.dart';

/// A horizontal scale with an axis, major and minor ticks, labels, and
/// optional needle, marker pointers, fill areas and bars.
///
/// Takes the full available width.
///
/// ```dart
/// GxLinearScaleGauge(
///   value: const GxGaugeValue(value: 40),
///   interval: 10,
///   needle: const GxLinearNeedle(shape: GxNeedleShape.triangle),
///   fillAreas: const <GxLinearFillArea>[
///     GxLinearFillArea(start: 0, end: 40, color: Colors.green),
///   ],
/// )
/// ```
class GxLinearScaleGauge extends ImplicitlyAnimatedWidget {
  /// Creates a linear scale gauge.
  const GxLinearScaleGauge({
    super.key,
    this.value = const GxGaugeValue(value: 0),
    this.interval,
    this.minorTicksPerInterval = 1,
    this.height = 100,
    this.axisSpaceExtent = 0.0,
    this.axisTrackStyle = const GxLinearAxisStyle(),
    this.axisLabelStyle,
    this.majorTickStyle = const GxLinearTickStyle(),
    this.minorTickStyle = const GxLinearTickStyle(),
    this.labelPosition = GxLabelPosition.bottomCenter,
    this.tickPosition = GxElementPosition.cross,
    this.showMajorTicks = true,
    this.showMinorTicks = true,
    this.showAxisTrack = true,
    this.showAxisLabel = true,
    this.labelFormatter,
    this.labelStyler,
    this.majorTickStyler,
    this.needle,
    this.markers = const <GxLinearMarkerPointer>[],
    this.fillAreas = const <GxLinearFillArea>[],
    this.bars = const <GxLinearBarPointer>[],
    this.barHeight,
    this.barOffset = 0.5,
    this.applyBarColorOnAxisTick = false,
    this.reverse = false,
    this.semanticLabel,
    this.semanticValueFormatter,
    super.duration = Duration.zero,
    super.curve = Curves.easeInOut,
    super.onEnd,
  });

  /// The needle's value and the axis range (`value.min` to `value.max`).
  /// Defaults to 0 on a 0..100 axis.
  final GxGaugeValue value;

  /// The step between major ticks. Null uses a tenth of the range. When the
  /// range isn't a multiple of it, the last tick is the last multiple below
  /// `value.max`.
  final double? interval;

  /// Minor ticks between two major ticks. Defaults to 1.
  final int minorTicksPerInterval;

  /// The gauge's height, including labels and needle. Defaults to 100.
  final double height;

  /// Horizontal inset of the axis from both edges, leaving room for the first
  /// and last labels. Defaults to 0.
  final double axisSpaceExtent;

  /// The axis line.
  final GxLinearAxisStyle axisTrackStyle;

  /// Tick label style, merged onto the theme's label style.
  final TextStyle? axisLabelStyle;

  /// Major ticks.
  final GxLinearTickStyle majorTickStyle;

  /// Minor ticks.
  final GxLinearTickStyle minorTickStyle;

  /// Labels above or below the axis. Defaults to
  /// [GxLabelPosition.bottomCenter].
  final GxLabelPosition labelPosition;

  /// Where ticks sit relative to the axis. Defaults to
  /// [GxElementPosition.cross].
  final GxElementPosition tickPosition;

  /// Whether major ticks are drawn. Defaults to true.
  final bool showMajorTicks;

  /// Whether minor ticks are drawn. Defaults to true.
  final bool showMinorTicks;

  /// Whether the axis line is drawn. Defaults to true.
  final bool showAxisTrack;

  /// Whether tick labels are drawn. Defaults to true.
  final bool showAxisLabel;

  /// Formats each tick label, e.g. `(v, i) => '${v.toInt()}°'`.
  final GxValueLabelFormatter? labelFormatter;

  /// Styles each tick label; the result merges onto [axisLabelStyle].
  final GxValueLabelStyler<TextStyle>? labelStyler;

  /// Styles each major tick, replacing [majorTickStyle].
  final GxValueTickStyler<GxLinearTickStyle>? majorTickStyler;

  /// An optional needle at `value.value`.
  final GxLinearNeedle? needle;

  /// Extra needles at fixed values.
  final List<GxLinearMarkerPointer> markers;

  /// Colored stretches of the axis.
  final List<GxLinearFillArea> fillAreas;

  /// Bars along the axis, drawn on the opposite side from the ticks (or
  /// centered on the axis for [GxElementPosition.cross]).
  final List<GxLinearBarPointer> bars;

  /// Bar height. Null uses half the gauge's height.
  final double? barHeight;

  /// Gap between the axis and the bars. Defaults to 0.5.
  final double barOffset;

  /// Whether ticks take the color of the bar they fall on. Hides the axis
  /// line and ignores [barOffset]. Defaults to false.
  final bool applyBarColorOnAxisTick;

  /// Runs from the end instead of the start. In a right-to-left locale the
  /// scale already runs from the right, and [reverse] flips it back.
  final bool reverse;

  /// Describes the gauge to screen readers.
  final String? semanticLabel;

  /// Formats the value announced by screen readers.
  final GxSemanticValueFormatter? semanticValueFormatter;

  @override
  AnimatedGaugeState<GxLinearScaleGauge> createState() =>
      _GxLinearScaleGaugeState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<GxGaugeValue>('value', value))
      ..add(DoubleProperty('interval', interval, defaultValue: null))
      ..add(DoubleProperty('height', height, defaultValue: 100.0))
      ..add(EnumProperty<GxElementPosition>('tickPosition', tickPosition))
      ..add(
        DiagnosticsProperty<GxLinearNeedle>(
          'needle',
          needle,
          defaultValue: null,
        ),
      )
      ..add(FlagProperty('reverse', value: reverse, ifTrue: 'reversed'))
      ..add(StringProperty('semanticLabel', semanticLabel, defaultValue: null));
  }
}

class _GxLinearScaleGaugeState extends AnimatedGaugeState<GxLinearScaleGauge> {
  @override
  double get targetValue => widget.value.value;

  @override
  Widget build(BuildContext context) {
    final GxLinearScaleGauge w = widget;
    final GaugeDefaults defaults = GaugeDefaults.of(context);
    final TextDirection direction =
        Directionality.maybeOf(context) ?? TextDirection.ltr;

    return gaugeSemantics(
      label: w.semanticLabel,
      value: semanticValue(w.semanticValueFormatter, w.value.value),
      child: LinearGaugeBox(
        height: w.height,
        child: CustomPaint(
          painter: ScaleLinearGaugePainter(
            value: valueAnimation,
            config: ScalePainterConfig(
              scale: GaugeScale(w.value.min, w.value.max),
              interval: w.interval,
              axisSpaceExtent: w.axisSpaceExtent,
              axisStyle: w.axisTrackStyle,
              axisColor: defaults.track,
              majorTickStyle: w.majorTickStyle,
              minorTickStyle: w.minorTickStyle,
              tickColor: defaults.tick,
              minorTicksPerInterval: w.minorTicksPerInterval,
              labelStyle: defaults.labelStyle.merge(w.axisLabelStyle),
              labelPosition: w.labelPosition,
              tickPosition: w.tickPosition,
              showMajorTicks: w.showMajorTicks,
              showMinorTicks: w.showMinorTicks,
              showAxisTrack: w.showAxisTrack,
              showAxisLabel: w.showAxisLabel,
              needleColor: defaults.needle,
              barColor: defaults.primary,
              barLabelStyle: defaults.labelStyle,
              barOffset: w.barOffset,
              applyBarColorOnAxisTick: w.applyBarColorOnAxisTick,
              reversed: (direction == TextDirection.rtl) != w.reverse,
              textDirection: direction,
              labelFormatter: w.labelFormatter,
              labelStyler: w.labelStyler,
              majorTickStyler: w.majorTickStyler,
              needle: w.needle,
              markers: w.markers,
              fillAreas: w.fillAreas,
              bars: w.bars,
              barHeight: w.barHeight,
            ),
          ),
        ),
      ),
    );
  }
}
