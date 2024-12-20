import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';
import 'package:girix_code_gauge/src/linear/utils/linear_bar_utils.dart';
import 'package:girix_code_gauge/src/linear/utils/tooltip_utils.dart';

class LinearBarPainter extends CustomPainter {
  LinearBarPainter({
    required this.gaugeValue,
    required this.barPointers,
    required this.direction,
    this.gapBetweenBars = 0,
    this.needle,
    this.showNeedleInsideBar = true,
    this.tooltip,
    this.customDrawNeedle,
  });
  final GaugeValue gaugeValue;
  final List<LinearBarPointer> barPointers;
  final LinearGaugeDirection direction;
  final double gapBetweenBars;
  final LinearNeedle? needle;
  final bool showNeedleInsideBar;
  final GaugeTooltip? tooltip;
  void Function(Canvas canvas, Offset position)? customDrawNeedle;

  @override
  void paint(Canvas canvas, Size size) {
    // draw the gauge
    if (barPointers.isNotEmpty) {
      _drawBars(canvas, size);
    }

    _drawNeedle(canvas, size);

    // Draw Tooltip
    _drawTooltip(canvas, size);
  }

  @override
  bool shouldRepaint(covariant LinearBarPainter oldDelegate) {
    return gaugeValue != oldDelegate.gaugeValue ||
        _isBarPointersChanged(oldDelegate.barPointers) ||
        direction != oldDelegate.direction ||
        gapBetweenBars != oldDelegate.gapBetweenBars ||
        needle != oldDelegate.needle ||
        showNeedleInsideBar != oldDelegate.showNeedleInsideBar;
  }

  void _drawBars(
    Canvas canvas,
    Size size,
  ) {
    LinearBarUtils.drawBars(
        canvas: canvas,
        size: size,
        barPointers: barPointers,
        value: gaugeValue.value,
        gapBetweenBars: gapBetweenBars,
        minValue: gaugeValue.min,
        maxValue: gaugeValue.max);
  }

  void _drawNeedle(
    Canvas canvas,
    Size size,
  ) {
    if (needle != null && needle!.enabled) {
      LinearBarUtils.drawNeedle(
        canvas: canvas,
        size: size,
        needle: needle!,
        value: gaugeValue.value,
        minValue: gaugeValue.min,
        maxValue: gaugeValue.max,
        gapBetweenBars: gapBetweenBars,
        barPointers: barPointers,
        showNeedleInsideBar: showNeedleInsideBar,
      );
    }
  }

  // Draw Tooltip
  void _drawTooltip(
    Canvas canvas,
    Size size,
  ) {
    if (tooltip != null && tooltip!.enabled) {
      final double minValue = gaugeValue.min;
      final double maxValue = gaugeValue.max;
      final double value = gaugeValue.value;

      TooltipUtils.drawTooltip(
        canvas: canvas,
        size: size,
        tooltip: tooltip!,
        value: value,
        minValue: minValue,
        maxValue: maxValue,
      );
    }
  }

  // Check List of BarPointers changes
  bool _isBarPointersChanged(List<LinearBarPointer> oldBarPointers) {
    if (barPointers.length != oldBarPointers.length) {
      return true;
    }

    for (int index = 0; index < barPointers.length; index++) {
      final LinearBarPointer barPointer = barPointers[index];
      final LinearBarPointer oldBarPointer = oldBarPointers[index];

      if (barPointer.value != oldBarPointer.value ||
          barPointer.color != oldBarPointer.color ||
          barPointer.thickness != oldBarPointer.thickness ||
          barPointer.position != oldBarPointer.position ||
          barPointer.offset != oldBarPointer.offset ||
          barPointer.radius != oldBarPointer.radius ||
          barPointer.paintingStyle != oldBarPointer.paintingStyle ||
          barPointer.strokeCap != oldBarPointer.strokeCap ||
          barPointer.label != oldBarPointer.label) {
        return true;
      }
    }

    return false;
  }
}
