import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/linear_gauge_common_model.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/linear/models/linear_needle_model.dart';
import 'package:gx_gauge/src/linear/utils/linear_bar_utils.dart';
import 'package:gx_gauge/src/linear/utils/tooltip_utils.dart';

class LinearBarPainter extends CustomPainter {
  LinearBarPainter({
    required this.gaugeValue,
    required this.bars,
    this.gapBetweenBars = 0,
    this.needle,
    this.showNeedleInsideBar = true,
    this.tooltip,
    this.needlePainter,
  });
  final GxGaugeValue gaugeValue;
  final List<GxLinearBarPointer> bars;
  final double gapBetweenBars;
  final GxLinearNeedle? needle;
  final bool showNeedleInsideBar;
  final GxGaugeTooltip? tooltip;
  GxNeedlePainter? needlePainter;

  @override
  void paint(Canvas canvas, Size size) {
    // draw the gauge
    if (bars.isNotEmpty) {
      _drawBars(canvas, size);
    }

    _drawNeedle(canvas, size);

    // Draw Tooltip
    _drawTooltip(canvas, size);
  }

  @override
  bool shouldRepaint(covariant LinearBarPainter oldDelegate) {
    return gaugeValue != oldDelegate.gaugeValue ||
        _isBarPointersChanged(oldDelegate.bars) ||
        gapBetweenBars != oldDelegate.gapBetweenBars ||
        needle != oldDelegate.needle ||
        showNeedleInsideBar != oldDelegate.showNeedleInsideBar;
  }

  void _drawBars(Canvas canvas, Size size) {
    LinearBarUtils.drawBars(
      canvas: canvas,
      size: size,
      bars: bars,
      value: gaugeValue.value,
      gapBetweenBars: gapBetweenBars,
      minValue: gaugeValue.min,
      maxValue: gaugeValue.max,
    );
  }

  void _drawNeedle(Canvas canvas, Size size) {
    if (needle != null && needle!.enabled) {
      LinearBarUtils.drawNeedle(
        canvas: canvas,
        size: size,
        needle: needle!,
        value: gaugeValue.value,
        minValue: gaugeValue.min,
        maxValue: gaugeValue.max,
        gapBetweenBars: gapBetweenBars,
        bars: bars,
        showNeedleInsideBar: showNeedleInsideBar,
        needlePainter: needlePainter,
      );
    }
  }

  // Draw Tooltip
  void _drawTooltip(Canvas canvas, Size size) {
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
  bool _isBarPointersChanged(List<GxLinearBarPointer> oldBarPointers) {
    if (bars.length != oldBarPointers.length) {
      return true;
    }

    for (int index = 0; index < bars.length; index++) {
      final GxLinearBarPointer barPointer = bars[index];
      final GxLinearBarPointer oldBarPointer = oldBarPointers[index];

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
