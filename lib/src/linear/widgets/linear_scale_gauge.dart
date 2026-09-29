import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/models.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/linear/models/linear_needle_model.dart';
import 'package:gx_gauge/src/linear/models/scale_linear_gauge_model.dart';
import 'package:gx_gauge/src/linear/painters/scale_linear_gauge_painter.dart';

/// A horizontal linear gauge with an axis, major and minor ticks, labels,
/// and optional needle, bar pointers, marker pointers and fill areas.
///
/// ```dart
/// GxLinearScaleGauge(
///   value: const GxGaugeValue(value: 40),
///   interval: 10,
///   needle: const GxLinearNeedle(shape: GxNeedleShape.triangle),
///   fillAreas: <GxLinearFillArea>[
///     GxLinearFillArea(startValue: 0, endValue: 40, color: Colors.green),
///   ],
/// )
/// ```
class GxLinearScaleGauge extends StatelessWidget {
  const GxLinearScaleGauge({
    super.key,
    this.value = const GxGaugeValue(value: 0),
    this.interval,
    this.axisSpaceExtent = 0.0,
    this.axisLabelStyle,
    this.axisTrackStyle = const GxLinearAxisStyle(),
    this.minorTicksPerInterval = 1,
    this.majorTickStyle = const GxLinearTickStyle(),
    this.minorTickStyle = const GxLinearTickStyle(),
    this.bars,
    this.barHeight,
    this.markers,
    this.size,
    this.labelFormatter,
    this.labelPosition = GxLabelPosition.bottomCenter,
    this.tickPosition = GxElementPosition.cross,
    this.showMajorTicks = true,
    this.showMinorTicks = true,
    this.showAxisTrack = true,
    this.showAxisLabel = true,
    this.majorTickStyler,
    this.needle,
    this.fillAreas,
    this.labelStyler,
    this.barOffset = 0.5,
    this.applyBarColorOnAxisTick = false,
  }) : // BarHeight can not be null when barPoints are not null
       assert(
         bars != null || barHeight == null,
         'barHeight can not be null when barPoints are not null',
       );

  /// The gauge's value and its `min`..`max` range.
  ///
  /// The needle points at `value.value`, and the axis runs from `value.min`
  /// to `value.max`. Defaults to `GxGaugeValue(value: 0)` on a 0..100 axis.
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///   value: const GxGaugeValue(value: 25, min: -50, max: 50),
  /// )
  /// ```
  final GxGaugeValue value;

  /// Specifies the interval of the gauge.
  ///
  /// The default value is 10.0
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  /// interval: 10.0,
  /// )
  /// ```
  ///
  final double? interval;

  /// Specifies the extent of the axis track of the gauge such as the amount of size of the axis track from the axis line.
  ///
  /// The default value is 0.0.
  ///
  /// Example:
  ///
  /// When 0: SizeStart<-AxisTrack ->SizeEnd
  ///
  /// When 10: SizeStart__10__AxisTrack__10__SizeEnd
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  /// axisSpaceExtent: 0.0,
  /// )
  /// ```
  ///
  final double axisSpaceExtent;

  /// Specifies the style of the axis label of the gauge.
  ///
  /// The default value is null.
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  /// axisLabelStyle: TextStyle(color: Colors.black, fontSize: 12),
  /// )
  /// ```
  ///
  final TextStyle? axisLabelStyle;

  /// Specifies the style of the axis track of the gauge.
  ///
  /// The default value is [GxLinearAxisStyle()].
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  /// axisTrackStyle: const GxLinearAxisStyle(
  ///   thickness = 5.0,
  ///   color = Colors.grey,
  ///  ),
  /// )
  /// ```
  ///
  final GxLinearAxisStyle axisTrackStyle;

  /// Specifies the number of minor ticks per interval of the gauge axis. such as the number of minor ticks between two major ticks.
  ///
  /// The default value is 1.
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///   minorTicksPerInterval: 1,
  /// )
  /// ```
  ///
  final int minorTicksPerInterval;

  /// Specifies the style of the major tick of the gauge axis such as the color, thickness, and length of the major tick.
  ///
  /// The default value is [GxLinearTickStyle()].
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///   majorTickStyle: const GxLinearTickStyle(
  ///     length = 8.0,
  ///     thickness = 1.0,
  ///     color = Colors.black,
  ///   ),
  /// )
  /// ```
  ///
  final GxLinearTickStyle majorTickStyle;

  /// Specifies the style of the minor tick of the gauge axis such as the color, thickness, and length of the minor tick.
  ///
  /// The default value is [GxLinearTickStyle()].
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///  minorTickStyle: const GxLinearTickStyle(
  ///   length = 8.0,
  ///   thickness = 1.0,
  ///   color = Colors.black,
  ///   ),
  /// )
  /// ```
  ///
  final GxLinearTickStyle minorTickStyle;

  /// Specifies the list of bar pointers of the gauge.
  ///
  /// The default value is null.
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///   bars: [
  ///     GxLinearBarPointer(
  ///       value: 50.0,
  ///       color: Colors.red,
  ///       thickness: 10.0,
  ///     ),
  ///   ],
  /// )
  /// ```
  ///
  final List<GxLinearBarPointer>? bars;

  /// Specifies the size of the gauge.
  ///
  /// The default value is null.
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///  size: Size(300, 100),
  /// )
  /// ```
  ///
  final double? barHeight;

  /// Specifies the offset position of the bar pointer. Default is 0.5.
  final double barOffset;

  /// Specifies the list of marker pointers of the gauge.
  ///
  /// The default value is null.
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///  markers: [
  ///   GxLinearMarkerPointer(
  ///       value: 50.0,
  ///       marker: Icon(Icons.star, color: Colors.yellow),
  ///     ),
  ///   ],
  /// )
  /// ```
  ///
  final List<GxLinearMarkerPointer>? markers;

  /// Specifies the width of the gauge.
  /// The default value is null.
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///  size: Size.fromWidth(300),
  /// )
  /// ```
  ///
  final Size? size;

  /// Specifies the value to label format callback of the gauge.
  ///
  /// The default value is null.
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///  labelFormatter: (value) => value.toStringAsFixed(0),
  /// )
  /// ```
  ///
  final GxValueLabelFormatter? labelFormatter;

  /// Specifies the label position of the gauge.
  ///
  /// The default value is [GxLabelPosition.bottomCenter].
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///   labelPosition: GxLabelPosition.bottomCenter,
  /// )
  /// ```
  ///
  final GxLabelPosition labelPosition;

  /// Specifies the tick position of the gauge.
  ///
  /// The default value is [GxElementPosition.cross].
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///  tickPosition: GxElementPosition.cross,
  /// )
  /// ```
  ///
  final GxElementPosition tickPosition;

  /// Specifies whether to show the major ticks of the gauge.
  ///
  /// The default value is true.
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///  showMajorTicks: true,
  /// )
  /// ```
  ///
  final bool showMajorTicks;

  /// Specifies whether to show the minor ticks of the gauge.
  ///
  /// The default value is true.
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///  showMinorTicks: true,
  /// )
  /// ```
  ///
  final bool showMinorTicks;

  /// Specifies whether to show the axis track of the gauge.
  ///
  /// The default value is true.
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///  showAxisTrack: true,
  /// )
  /// ```
  ///
  final bool showAxisTrack;

  /// Specifies whether to show the axis label of the gauge.
  ///
  /// The default value is true.
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///  showAxisLabel: true,
  /// )
  /// ```
  final bool showAxisLabel;

  /// Specifies the value to major tick style callback of the gauge.
  ///
  /// The default value is null.
  ///
  ///  The [majorTickStyle] argument will be ignored if the [majorTickStyler] is not null.
  ///
  /// ```dart
  /// GxLinearTickStyle majorTickStyle(double value, int index) {
  ///  return GxLinearTickStyle(
  ///   length: 20,
  ///   thickness: 2,
  ///   color: Colors.blue,
  /// );
  /// }
  /// ```
  ///
  final GxValueTickStyler<GxLinearTickStyle>? majorTickStyler;

  /// Specifies the needle of the gauge.
  ///
  /// The default value is null.
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///   needle: GxLinearNeedle(
  ///      enabled: true,
  ///      position: GxNeedlePosition.bottom,
  ///      size: const Size(20, 20),
  ///      color: Colors.blueGrey,
  ///     shape: GxNeedleShape.triangle),
  /// )
  /// ```
  ///
  final GxLinearNeedle? needle;

  /// Specifies the list of fill area pointer of the gauge.
  ///
  /// The default value is null.
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///  fillAreas: [
  ///    GxLinearFillArea(
  ///     startValue: 0.0,
  ///     endValue: 50.0,
  ///     color: Colors.green,
  ///     thickness: 10.0,
  ///   ),
  ///  ],
  /// )
  /// ```
  ///
  final List<GxLinearFillArea>? fillAreas;

  /// Specifies the value to label style callback of the gauge.
  ///
  /// The default value is null.
  ///
  /// ```dart
  /// TextStyle valueToLabelStyle(double value) {
  ///   return TextStyle(
  ///   color: Colors.black,
  ///   fontSize: 12,
  ///  );
  /// }
  /// ```
  ///
  final GxValueLabelStyler<TextStyle>? labelStyler;

  /// Specifies whether to apply the bar color on the axis and the ticks.
  ///
  /// This will be applied only when the `bars` are not null.
  ///
  /// ``barOffset`` and `axis` will be ignored when this is set to true.
  ///
  /// The default value is `false`.
  ///
  /// ```dart
  /// GxLinearScaleGauge(
  ///  applyBarColorOnAxisTick: true,
  /// )
  /// ```
  ///
  final bool applyBarColorOnAxisTick;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScaleLinearGaugePainter(
        minimum: value.min,
        maximum: value.max,
        interval: interval,
        axisSpaceExtent: axisSpaceExtent,
        axisLabelStyle: axisLabelStyle,
        axisTrackStyle: axisTrackStyle,
        minorTicksPerInterval: minorTicksPerInterval,
        majorTickStyle: majorTickStyle,
        minorTickStyle: minorTickStyle,
        bars: bars,
        markers: markers,
        labelFormatter: labelFormatter,
        labelPosition: labelPosition,
        tickPosition: tickPosition,
        showMajorTicks: showMajorTicks,
        showMinorTicks: showMinorTicks,
        showAxisTrack: showAxisTrack,
        showAxisLabel: showAxisLabel,
        majorTickStyler: majorTickStyler,
        value: value.value,
        needle: needle,
        fillAreas: fillAreas,
        labelStyler: labelStyler,
        barHeight: barHeight,
        barOffset: barOffset,
        applyBarColorOnAxisTick: applyBarColorOnAxisTick,
      ),
      size: size ?? const Size.fromHeight(100),
    );
  }
}
