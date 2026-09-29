// lib/src/radial/widgets/radial_gauge.dart

import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/linear_gauge_common_model.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/radial/models/radial_gauge_style.dart';
import 'package:gx_gauge/src/radial/painters/radial_gauge_painter.dart';

/// The [GxRadialGauge] widget is used to display a radial gauge.
///
///
class GxRadialGauge extends StatelessWidget {
  const GxRadialGauge({
    super.key,
    required this.value,
    this.style = const GxRadialGaugeStyle(),
    this.size = const Size(200, 200),
    this.labelTickStyle = const GxRadialTickLabelStyle(),
    this.showMajorTicks = false,
    this.showMinorTicks = false,
    this.showLabels = false,
    this.majorTickStyle = const GxRadialTickStyle(),
    this.minorTickStyle = const GxRadialTickStyle(),
    this.interval = 10,
    this.minorTicksPerInterval = 10,
    this.startAngleInDegree = 0,
    this.sweepAngleInDegree = 360,
    this.showValueAtCenter = true,
    this.showNeedle = false,
    this.needle,
    this.labelFormatter,
    this.labelStyler,
    this.majorTickStyler,
    this.pointers,
    this.ranges,
  });

  /// Specifies the value of the gauge.
  ///   * [value] : The value of the gauge. The value is required.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///  value: GxGaugeValue(
  ///   value: 50,
  ///   min: 0,
  ///   max: 100,
  ///  ),
  /// )
  /// ```
  ///
  final GxGaugeValue value;

  /// Specifies the style of the gauge.
  ///  * [style] : The style of the gauge. The default value is [GxRadialGaugeStyle()]. The style is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///   style: GxRadialGaugeStyle(
  ///     color: Colors.cyan,
  ///     thickness: 35,
  ///    ),
  /// )
  /// ```
  ///
  final GxRadialGaugeStyle style;

  /// Specifies the size of the gauge.
  /// * [size] : The size of the gauge. The default value is [Size(200, 200)]. The size is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///  size: Size(200, 200),
  /// )
  /// ```
  ///
  final Size size;

  /// Specifies the style of the label tick.
  /// * [labelTickStyle] : The style of the label tick. The default value is [GxRadialTickLabelStyle()]. The labelTickStyle is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///   labelTickStyle: GxRadialTickLabelStyle(
  ///     padding: 30,
  ///     offset: 10,
  ///     style: TextStyle(
  ///      color: Colors.black,
  ///      fontSize: 12,
  ///     ),
  ///   ),
  /// )
  /// ```
  ///
  final GxRadialTickLabelStyle labelTickStyle;

  /// Specifies whether to show the major ticks.
  /// * [showMajorTicks] : The default value is false. The showMajorTicks is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///   showMajorTicks: true,
  /// )
  /// ```
  ///
  final bool showMajorTicks;

  /// Specifies whether to show the minor ticks.
  /// * [showMinorTicks] : The default value is false. The showMinorTicks is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///   showMinorTicks: true,
  /// )
  /// ```
  ///
  final bool showMinorTicks;

  /// Specifies whether to show the labels.
  /// * [showLabels] : The default value is false. The showLabels is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///   showLabels: true,
  /// )
  /// ```
  ///
  final bool showLabels;

  /// Specifies the style of the major ticks.
  /// * [majorTickStyle] : The default value is [GxRadialTickStyle()]. The majorTickStyle is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///   majorTickStyle: GxRadialTickStyle(
  ///     color: Colors.black,
  ///     thickness: 1,
  ///     length: 25,
  ///     alignment: GxRadialElementAlignment.center,
  ///     position: GxRadialElementPosition.inside,
  ///   ),
  /// )
  /// ```
  ///
  final GxRadialTickStyle majorTickStyle;

  /// Specifies the style of the minor ticks.
  /// * [minorTickStyle] : The default value is [GxRadialTickStyle()]. The minorTickStyle is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///  minorTickStyle: GxRadialTickStyle(
  ///     color: Colors.black,
  ///     thickness: 1,
  ///     length: 10,
  ///     alignment: GxRadialElementAlignment.center,
  ///     position: GxRadialElementPosition.inside,
  ///   ),
  /// )
  /// ```
  ///
  final GxRadialTickStyle minorTickStyle;

  /// Specifies the interval of the gauge.
  /// * [interval] : The default value is 10. The interval is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///  interval: 10,
  /// )
  /// ```
  ///
  final int interval;

  /// Specifies the minor ticks per interval of the gauge.
  /// * [minorTicksPerInterval] : The default value is 10. The minorTicksPerInterval is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///   minorTicksPerInterval: 10,
  /// )
  /// ```
  ///
  final int minorTicksPerInterval;

  /// Specifies the start angle of the gauge in degree.
  /// * [startAngleInDegree] : The default value is 0. The startAngleInDegree is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///   startAngleInDegree: 0,
  /// )
  /// ```
  ///
  final double startAngleInDegree;

  /// Specifies the sweep angle of the gauge in degree.
  /// * [sweepAngleInDegree] : The default value is 360. The sweepAngleInDegree is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///  sweepAngleInDegree: 360,
  /// )
  /// ```
  ///
  final double sweepAngleInDegree;

  /// Specifies whether to show the value at the center of the gauge.
  /// * [showValueAtCenter] : The default value is true. The showValueAtCenter is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///  showValueAtCenter: true,
  /// )
  /// ```
  ///
  final bool showValueAtCenter;

  /// Specifies whether to show the needle.
  /// * [showNeedle] : The default value is false. The showNeedle is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///  showNeedle: true,
  /// )
  /// ```
  ///
  final bool showNeedle;

  /// Specifies the needle of the gauge.
  /// * [needle] : The needle of the gauge. The needle is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///  needle: GxRadialNeedle(
  ///   color: Colors.lightBlue,
  ///   shape: GxRadialNeedleShape.taperedLine,
  ///   thickness: 18,
  ///   alignment: GxRadialElementAlignment.end,
  ///   circle: GxNeedleCap(
  ///     radius: 15,
  ///     color: Colors.red
  ///     ),
  ///   ),
  /// )
  /// ```
  ///
  final GxRadialNeedle? needle;

  /// Specifies the value to label format callback.
  /// * [labelFormatter] : The value to label format callback. The labelFormatter is optional.
  ///
  /// ```dart
  /// GxRadialGauge(
  ///   labelFormatter: (double value, int index) {
  ///     return value.toStringAsFixed(2);
  ///   },
  /// )
  /// ```
  ///
  final GxValueLabelFormatter? labelFormatter;

  /// Specifies the value to label style callback.
  /// * [labelStyler] : The value to label style callback. The labelStyler is optional.
  /// ```dart
  /// GxRadialGauge(
  ///   labelStyler: (double value, int index) {
  ///    return GxRadialTickStyle(
  ///       color: Colors.black,
  ///       thickness: 1,
  ///       length: 25,
  ///      );
  ///  },
  /// )
  /// ```
  ///
  final GxValueTickStyler<GxRadialTickStyle>? majorTickStyler;
  // Callbacks

  /// Specifies the value to label style callback.
  /// * [labelStyler] : The value to label style callback. The labelStyler is optional.
  /// ```dart
  /// GxRadialGauge(
  ///  labelStyler: (double value, int index) {
  ///   return GxRadialTickLabelStyle(
  ///     padding: 30,
  ///     offset: 10,
  ///     style: TextStyle(
  ///       color: Colors.black,
  ///       fontSize: 12,
  ///       ),
  ///    );
  ///   },
  /// )
  /// ```
  ///
  final GxValueLabelStyler<GxRadialTickLabelStyle>? labelStyler;

  /// Specifies the radial pointers.
  /// * [pointers] : The radial pointers. The pointers is optional.
  /// ```dart
  /// GxRadialGauge(
  ///   pointers: [
  ///    GxRadialPointer(
  ///      value: 50,
  ///     ),
  ///   ],
  /// )
  /// ```
  ///
  final List<GxRadialPointer>? pointers;

  /// Specifies the range bars.
  /// * [ranges] : The range bars. The ranges is optional.
  /// ```dart
  /// GxRadialGauge(
  ///  ranges: [
  ///   GxRadialRange(
  ///     height: 30,
  ///     startValue: 0,
  ///     endValue: 33,
  ///     color: Colors.green,
  ///     )
  ///   ],
  /// )
  /// ```
  final List<GxRadialRange>? ranges;

  @override
  Widget build(BuildContext context) {
    final Color needleCircleInnerColor =
        context.findAncestorWidgetOfExactType<Material>()?.color ??
        Theme.of(context).colorScheme.surface;
    return CustomPaint(
      size: size,
      painter: RadialGaugePainter(
        startAngleInDegree: startAngleInDegree,
        sweepAngleInDegree: sweepAngleInDegree,
        value: value,
        style: style,
        labelTickStyle: labelTickStyle,
        showMajorTicks: showMajorTicks,
        showMinorTicks: showMinorTicks,
        showLabels: showLabels,
        majorTickStyle: majorTickStyle,
        minorTickStyle: minorTickStyle,
        interval: interval,
        minorTicksPerInterval: minorTicksPerInterval,
        showValueAtCenter: showValueAtCenter,
        showNeedle: showNeedle,
        needle: needle,
        needleCircleInnerColor: needleCircleInnerColor,
        labelFormatter: labelFormatter,
        labelStyler: labelStyler,
        majorTickStyler: majorTickStyler,
        pointers: pointers,
        ranges: ranges,
      ),
    );
  }
}
