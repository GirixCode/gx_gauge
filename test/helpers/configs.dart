import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/linear/painters/linear_bar_painter.dart';
import 'package:gx_gauge/src/linear/painters/progress_linear_painter.dart';
import 'package:gx_gauge/src/linear/painters/scale_linear_gauge_painter.dart';
import 'package:gx_gauge/src/linear/painters/stepper_linear_painter.dart';
import 'package:gx_gauge/src/radial/painters/radial_gauge_painter.dart';

/// Painter configurations with fixed colors, for painter unit tests.
const Color primary = Color(0xFF0000FF);
const Color track = Color(0xFF00FF00);
const Color tick = Color(0xFF111111);
const Color needle = Color(0xFF222222);
const TextStyle label = TextStyle(fontSize: 10);

ProgressPainterConfig progressConfig({
  GaugeScale scale = const GaugeScale(0, 100),
  GxLinearProgressStyle style = const GxLinearProgressStyle(),
  bool reversed = false,
  GxLinearNeedle? linearNeedle,
  GxGaugeLabel? gaugeLabel,
  bool showLabel = false,
}) {
  return ProgressPainterConfig(
    scale: scale,
    style: style,
    color: primary,
    backgroundColor: track,
    reversed: reversed,
    textDirection: TextDirection.ltr,
    labelStyle: label,
    needleColor: needle,
    needle: linearNeedle,
    label: gaugeLabel,
    showLabel: showLabel,
  );
}

BarPainterConfig barConfig({
  GaugeScale scale = const GaugeScale(0, 100),
  List<GxLinearBarPointer> bars = const <GxLinearBarPointer>[],
  double gap = 0,
  bool reversed = false,
  GxLinearNeedle? linearNeedle,
  GxGaugeTooltip? tooltip,
}) {
  return BarPainterConfig(
    scale: scale,
    bars: bars,
    barColor: primary,
    labelStyle: label,
    needleColor: needle,
    tooltipColor: tick,
    tooltipTextColor: track,
    reversed: reversed,
    textDirection: TextDirection.ltr,
    gap: gap,
    needle: linearNeedle,
    tooltip: tooltip,
  );
}

StepperPainterConfig stepperConfig({
  GaugeScale scale = const GaugeScale(0, 100),
  List<GxStepperStep> steps = const <GxStepperStep>[],
  bool reversed = false,
}) {
  return StepperPainterConfig(
    scale: scale,
    steps: steps,
    style: const GxLinearProgressStyle(thickness: 4),
    color: primary,
    trackColor: track,
    inactiveColor: tick,
    shape: GxStepperShape.circle,
    shapeSize: 20,
    offset: 10,
    activeStyle: label,
    inactiveStyle: label,
    labelStyle: label,
    reversed: reversed,
    textDirection: TextDirection.ltr,
  );
}

ScalePainterConfig scaleConfig({
  GaugeScale scale = const GaugeScale(0, 100),
  double? interval = 10,
  int minorTicksPerInterval = 0,
  double axisSpaceExtent = 0,
  bool showMajorTicks = true,
  bool showMinorTicks = true,
  bool showAxisLabel = false,
  bool showAxisTrack = true,
  GxElementPosition tickPosition = GxElementPosition.cross,
  GxLinearNeedle? linearNeedle,
  List<GxLinearBarPointer> bars = const <GxLinearBarPointer>[],
  bool reversed = false,
}) {
  return ScalePainterConfig(
    scale: scale,
    interval: interval,
    axisSpaceExtent: axisSpaceExtent,
    axisStyle: const GxLinearAxisStyle(),
    axisColor: track,
    majorTickStyle: const GxLinearTickStyle(length: 10, thickness: 2),
    minorTickStyle: const GxLinearTickStyle(length: 4),
    tickColor: tick,
    minorTicksPerInterval: minorTicksPerInterval,
    labelStyle: label,
    labelPosition: GxLabelPosition.bottomCenter,
    tickPosition: tickPosition,
    showMajorTicks: showMajorTicks,
    showMinorTicks: showMinorTicks,
    showAxisTrack: showAxisTrack,
    showAxisLabel: showAxisLabel,
    needleColor: needle,
    barColor: primary,
    barLabelStyle: label,
    barOffset: 0.5,
    applyBarColorOnAxisTick: false,
    reversed: reversed,
    textDirection: TextDirection.ltr,
    needle: linearNeedle,
    bars: bars,
  );
}

RadialPainterConfig radialConfig({
  GaugeScale scale = const GaugeScale(0, 100),
  double startAngleInDegree = 0,
  double sweepAngleInDegree = 360,
  double? interval = 10,
  int minorTicksPerInterval = 0,
  bool showMajorTicks = false,
  bool showMinorTicks = false,
  bool showLabels = false,
  GxRadialNeedle? radialNeedle,
  List<GxRadialPointer> pointers = const <GxRadialPointer>[],
}) {
  return RadialPainterConfig(
    scale: scale,
    style: const GxRadialGaugeStyle(),
    color: primary,
    trackColor: track,
    startAngleInDegree: startAngleInDegree,
    sweepAngleInDegree: sweepAngleInDegree,
    interval: interval,
    minorTicksPerInterval: minorTicksPerInterval,
    showMajorTicks: showMajorTicks,
    showMinorTicks: showMinorTicks,
    showLabels: showLabels,
    majorTickStyle: const GxRadialTickStyle(thickness: 2),
    minorTickStyle: const GxRadialTickStyle(),
    tickColor: tick,
    labelTickStyle: const GxRadialTickLabelStyle(),
    labelStyle: label,
    showValueAtCenter: false,
    valueStyle: label,
    showNeedle: radialNeedle != null,
    needleColor: needle,
    pointerColor: primary,
    rangeColor: primary,
    capInnerColor: Colors.white,
    textDirection: TextDirection.ltr,
    needle: radialNeedle,
    pointers: pointers,
  );
}
