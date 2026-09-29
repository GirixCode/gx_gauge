import 'package:flutter/material.dart';
import 'package:girix_code_gauge/src/common/models/models.dart';
import 'package:girix_code_gauge/src/common/utils/typedef.dart';
import 'package:girix_code_gauge/src/linear/models/linear_needle_model.dart';
import 'package:girix_code_gauge/src/linear/models/scale_linear_gauge_model.dart';
import 'package:girix_code_gauge/src/linear/painters/scale_linear_gauge_painter.dart';

/// The [GxScaleLinearGauge] widget is used to display a linear gauge with a scale.
///
/// The [GxScaleLinearGauge] widget requires the following properties:
///
/// - [gaugeType]: An instance of the [ScaleLinearGaugeType] enum that holds the type of gauge to be drawn.
///
/// - [orientation]: An instance of the [LinearGaugeOrientation] enum that holds the orientation of the gauge.
///
/// - [minimum]: A double value that holds the minimum value of the gauge.
///
/// - [maximum]: A double value that holds the maximum value of the gauge.
///
/// - [interval]: A double value that holds the interval of the gauge.
///
/// - [axisSpaceExtent]: A double value that holds the extent of the axis track of the gauge such as the thickness of the axis track.
///
/// - [axisLabelStyle]: An instance of the [TextStyle] class that holds the style of the axis label of the gauge.
///
/// - [axisTrackStyle]: An instance of the [LinearAxisTrackStyle] class that holds the style of the axis track of the gauge.
///
/// - [minorTicksPerInterval]: An integer value that holds the number of minor ticks per interval of the gauge axis.
///
/// - [majorTickStyle]: An instance of the [LinearTickStyle] class that holds the style of the major tick of the gauge axis.
///
/// - [minorTickStyle]: An instance of the [LinearTickStyle] class that holds the style of the minor tick of the gauge axis.
///
/// - [ranges]: A list of [LinearGaugeRange] that holds the list of ranges of the gauge.
///
/// - [barPointers]: A list of [LinearBarPointer] that holds the list of bar pointers of the gauge.
///
/// - [markerPointers]: A list of [LinearMarkerPointer] that holds the list of marker pointers of the gauge.
///
///
/// ```dart
/// GxScaleLinearGauge(
///  gaugeType: ScaleLinearGaugeType.defaultGauge,
///  orientation: LinearGaugeOrientation.horizontal,
///  minimum: 0.0,
///  maximum: 100.0,
///  interval: 10.0,
///  axisSpaceExtent: 0.0,
///  axisLabelStyle: TextStyle(color: Colors.black, fontSize: 12),
///  axisTrackStyle: const LinearAxisTrackStyle(
///   thickness = 5.0,
///   color = Colors.grey,
///  ),
///  minorTicksPerInterval: 1,
///  majorTickStyle: const LinearTickStyle(
///   length = 8.0,
///   thickness = 1.0,
///   color = Colors.black,
///  ),
///  minorTickStyle: const LinearTickStyle(
///   length = 8.0,
///   thickness = 1.0,
///   color = Colors.black,
///  ),
///  ranges: [
///    LinearGaugeRange(
///     startValue: 0.0,
///     endValue: 50.0,
///     color: Colors.green,
///     label: 'Low',
///   ),
///  ],
///  barPointers: [
///    LinearBarPointer(
///     value: 50.0,
///     color: Colors.red,
///     thickness: 10.0,
///  ),
/// ],
/// markerPointers: [
///  LinearMarkerPointer(
///    value: 50.0,
///    marker: Icon(Icons.star, color: Colors.yellow),
/// ),
/// ],
/// )
/// ```
///
class GxScaleLinearGauge extends StatelessWidget {
  /// Specifies the type of gauge to be drawn of the [GxScaleLinearGauge].
  ///
  /// The default value is [ScaleLinearGaugeType.defaultGauge].
  ///
  /// ```dart
  /// GxScaleLinearGauge(
  ///  gaugeType: ScaleLinearGaugeType.defaultGauge,
  /// )
  /// ```
  ///
  final ScaleLinearGaugeType gaugeType;

  /// Specifies the orientation of the gauge.
  ///
  /// The default value is [LinearGaugeOrientation.horizontal].
  ///
  /// ```dart
  /// GxScaleLinearGauge(
  /// orientation: LinearGaugeOrientation.horizontal,
  /// )
  /// ```
  ///
  final LinearGaugeOrientation orientation;

  /// Specifies the value of the gauge.
  ///
  /// The default value is 0.0.
  ///
  /// ```dart
  /// GxScaleLinearGauge(
  ///  value: 50.0,
  /// )
  /// ```
  ///
  final double value;

  /// Specifies the minimum value of the gauge.
  ///
  /// The default value is 0.0.
  ///
  /// ```dart
  /// GxScaleLinearGauge(
  /// minimum: 0.0,
  /// )
  /// ```
  ///
  final double minimum;

  /// Specifies the maximum value of the gauge.
  ///
  /// The default value is 100.0.
  ///
  /// ```dart
  /// GxScaleLinearGauge(
  /// maximum: 100.0,
  /// )
  /// ```
  ///
  final double maximum;

  /// Specifies the interval of the gauge.
  ///
  /// The default value is 10.0
  ///
  /// ```dart
  /// GxScaleLinearGauge(
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
  /// GxScaleLinearGauge(
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
  /// GxScaleLinearGauge(
  /// axisLabelStyle: TextStyle(color: Colors.black, fontSize: 12),
  /// )
  /// ```
  ///
  final TextStyle? axisLabelStyle;

  /// Specifies the style of the axis track of the gauge.
  ///
  /// The default value is [LinearAxisTrackStyle()].
  ///
  /// ```dart
  /// GxScaleLinearGauge(
  /// axisTrackStyle: const LinearAxisTrackStyle(
  ///   thickness = 5.0,
  ///   color = Colors.grey,
  ///  ),
  /// )
  /// ```
  ///
  final LinearAxisTrackStyle axisTrackStyle;

  /// Specifies the number of minor ticks per interval of the gauge axis. such as the number of minor ticks between two major ticks.
  ///
  /// The default value is 1.
  ///
  /// ```dart
  /// GxScaleLinearGauge(
  ///   minorTicksPerInterval: 1,
  /// )
  /// ```
  ///
  final int minorTicksPerInterval;

  /// Specifies the style of the major tick of the gauge axis such as the color, thickness, and length of the major tick.
  ///
  /// The default value is [LinearTickStyle()].
  ///
  /// ```dart
  /// GxScaleLinearGauge(
  ///   majorTickStyle: const LinearTickStyle(
  ///     length = 8.0,
  ///     thickness = 1.0,
  ///     color = Colors.black,
  ///   ),
  /// )
  /// ```
  ///
  final LinearTickStyle majorTickStyle;

  /// Specifies the style of the minor tick of the gauge axis such as the color, thickness, and length of the minor tick.
  ///
  /// The default value is [LinearTickStyle()].
  ///
  /// ```dart
  /// GxScaleLinearGauge(
  ///  minorTickStyle: const LinearTickStyle(
  ///   length = 8.0,
  ///   thickness = 1.0,
  ///   color = Colors.black,
  ///   ),
  /// )
  /// ```
  ///
  final LinearTickStyle minorTickStyle;

  /// Specifies the list of bar pointers of the gauge.
  ///
  /// The default value is null.
  ///
  /// ```dart
  /// GxScaleLinearGauge(
  ///   barPointers: [
  ///     LinearBarPointer(
  ///       value: 50.0,
  ///       color: Colors.red,
  ///       thickness: 10.0,
  ///     ),
  ///   ],
  /// )
  /// ```
  ///
  final List<LinearBarPointer>? barPointers;

  /// Specifies the size of the gauge.
  ///
  /// The default value is null.
  ///
  /// ```dart
  /// GxScaleLinearGauge(
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
  /// GxScaleLinearGauge(
  ///  markerPointers: [
  ///   LinearMarkerPointer(
  ///       value: 50.0,
  ///       marker: Icon(Icons.star, color: Colors.yellow),
  ///     ),
  ///   ],
  /// )
  /// ```
  ///
  final List<LinearMarkerPointer>? markerPointers;

  /// Specifies the width of the gauge.
  /// The default value is null.
  ///
  /// ```dart
  /// GxScaleLinearGauge(
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
  /// GxScaleLinearGauge(
  ///  valueToLabelFormatCallback: (value) => value.toStringAsFixed(0),
  /// )
  /// ```
  ///
  final ValueToLabelFormatCallback? valueToLabelFormatCallback;

  /// Specifies the label position of the gauge.
  ///
  /// The default value is [LinearGaugeLabelPosition.bottomCenter].
  ///
  /// ```dart
  /// GxScaleLinearGauge(
  ///   labelPosition: LinearGaugeLabelPosition.bottomCenter,
  /// )
  /// ```
  ///
  final LinearGaugeLabelPosition labelPosition;

  /// Specifies the tick position of the gauge.
  ///
  /// The default value is [LinearElementPosition.cross].
  ///
  /// ```dart
  /// GxScaleLinearGauge(
  ///  tickPosition: LinearElementPosition.cross,
  /// )
  /// ```
  ///
  final LinearElementPosition tickPosition;

  /// Specifies whether to show the major ticks of the gauge.
  ///
  /// The default value is true.
  ///
  /// ```dart
  /// GxScaleLinearGauge(
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
  /// GxScaleLinearGauge(
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
  /// GxScaleLinearGauge(
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
  /// GxScaleLinearGauge(
  ///  showAxisLabel: true,
  /// )
  /// ```
  final bool showAxisLabel;

  /// Specifies the value to major tick style callback of the gauge.
  ///
  /// The default value is null.
  ///
  ///  The [majorTickStyle] argument will be ignored if the [valueToMajorTickStyleCallback] is not null.
  ///
  /// ```dart
  /// LinearTickStyle majorTickStyle(double value, int index) {
  ///  return LinearTickStyle(
  ///   length: 20,
  ///   thickness: 2,
  ///   color: Colors.blue,
  /// );
  /// }
  /// ```
  ///
  final ValueToMajorTickStyleCallback? valueToMajorTickStyleCallback;

  /// Specifies the needle of the gauge.
  ///
  /// The default value is null.
  ///
  /// ```dart
  /// GxScaleLinearGauge(
  ///   needle: LinearNeedle(
  ///      enabled: true,
  ///      position: LinearGaugeNeedlePosition.bottom,
  ///      size: const Size(20, 20),
  ///      color: Colors.blueGrey,
  ///     needleType: LinearGaugeNeedleType.triangle),
  /// )
  /// ```
  ///
  final LinearNeedle? needle;

  /// Specifies the list of fill area pointer of the gauge.
  ///
  /// The default value is null.
  ///
  /// ```dart
  /// GxScaleLinearGauge(
  ///  fillAreaPointers: [
  ///    FillAreaPointer(
  ///     startValue: 0.0,
  ///     endValue: 50.0,
  ///     color: Colors.green,
  ///     thickness: 10.0,
  ///   ),
  ///  ],
  /// )
  /// ```
  ///
  final List<FillAreaPointer>? fillAreaPointers;

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
  final ValueToLabelStyleCallback? valueToLabelStyleCallback;

  /// Specifies whether to apply the bar color on the axis and the ticks.
  ///
  /// This will be applied only when the `barPointers` are not null.
  ///
  /// ``barOffset`` and `axis` will be ignored when this is set to true.
  ///
  /// The default value is `false`.
  ///
  /// ```dart
  /// GxScaleLinearGauge(
  ///  applyBarColorOnAxisTick: true,
  /// )
  /// ```
  ///
  final bool applyBarColorOnAxisTick;

  const GxScaleLinearGauge({
    super.key,
    this.gaugeType = ScaleLinearGaugeType.defaultGauge,
    this.orientation = LinearGaugeOrientation.horizontal,
    this.minimum = 0.0,
    this.maximum = 100.0,
    this.interval,
    this.axisSpaceExtent = 0.0,
    this.axisLabelStyle,
    this.axisTrackStyle = const LinearAxisTrackStyle(),
    this.minorTicksPerInterval = 1,
    this.majorTickStyle = const LinearTickStyle(),
    this.minorTickStyle = const LinearTickStyle(),
    this.barPointers,
    this.barHeight,
    this.markerPointers,
    this.size,
    this.valueToLabelFormatCallback,
    this.labelPosition = LinearGaugeLabelPosition.bottomCenter,
    this.tickPosition = LinearElementPosition.cross,
    this.showMajorTicks = true,
    this.showMinorTicks = true,
    this.showAxisTrack = true,
    this.showAxisLabel = true,
    this.valueToMajorTickStyleCallback,
    this.needle,
    this.value = 0.0,
    this.fillAreaPointers,
    this.valueToLabelStyleCallback,
    this.barOffset = 0.5,
    this.applyBarColorOnAxisTick = false,
  })  : assert(minimum < maximum, 'min must be less than max'),
        assert(value >= minimum && value <= maximum,
            'value must be between min and max'),
        // BarHeight can not be null when barPoints are not null
        assert(barPointers != null || barHeight == null,
            'barHeight can not be null when barPoints are not null');

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: ScaleLinearGaugePainter(
          gaugeType: gaugeType,
          orientation: orientation,
          minimum: minimum,
          maximum: maximum,
          interval: interval,
          axisSpaceExtent: axisSpaceExtent,
          axisLabelStyle: axisLabelStyle,
          axisTrackStyle: axisTrackStyle,
          minorTicksPerInterval: minorTicksPerInterval,
          majorTickStyle: majorTickStyle,
          minorTickStyle: minorTickStyle,
          barPointers: barPointers,
          markerPointers: markerPointers,
          valueToLabelFormatCallback: valueToLabelFormatCallback,
          labelPosition: labelPosition,
          tickPosition: tickPosition,
          showMajorTicks: showMajorTicks,
          showMinorTicks: showMinorTicks,
          showAxisTrack: showAxisTrack,
          showAxisLabel: showAxisLabel,
          valueToMajorTickStyleCallback: valueToMajorTickStyleCallback,
          value: value,
          needle: needle,
          fillAreaPointers: fillAreaPointers,
          valueToLabelStyleCallback: valueToLabelStyleCallback,
          barHeight: barHeight,
          barOffset: barOffset,
          applyBarColorOnAxisTick: applyBarColorOnAxisTick,
        ),
        size: size ?? const Size.fromHeight(100));
  }
}
