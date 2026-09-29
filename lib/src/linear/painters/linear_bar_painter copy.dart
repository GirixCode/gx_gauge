import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class LinearBarPainter extends CustomPainter {
  LinearBarPainter({
    required this.gaugeValue,
    required this.barPointers,
    required this.direction,
  });
  final GaugeValue gaugeValue;
  final List<LinearBarPointer> barPointers;
  final LinearGaugeDirection direction;
  @override
  void paint(Canvas canvas, Size size) {
    // draw the gauge
    if (barPointers.isNotEmpty) {
      _drawBars(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant LinearBarPainter oldDelegate) {
    return gaugeValue != oldDelegate.gaugeValue ||
        barPointers != oldDelegate.barPointers;
  }

  void _drawBars(
    Canvas canvas,
    Size size,
  ) {
    // Gauge Value
    final double minValue = gaugeValue.min;
    final double maxValue = gaugeValue.max;
    // final double currentValue = gaugeValue.value;

    // Bar
    double startValue = 0;
    double endValue = 0;

    // log('GxLinearBarGauge: Size: $size');

    for (int index = 0; index < barPointers.length; index++) {
      final LinearBarPointer barPointer = barPointers[index];
      // log('GxLinearBarGauge: Index: $index, BarValue: ${barPointer.value}');
      final Paint paintAxis = Paint()
        ..color = barPointer.color
        ..strokeWidth = barPointer.thickness
        ..strokeCap = barPointer.strokeCap
        ..style = barPointer.paintingStyle;

      endValue = startValue + barPointer.value;

      final double barStartValue =
          ((startValue - minValue) / (maxValue - minValue)) * size.width;
      final double barEndValue =
          ((endValue - minValue) / (maxValue - minValue)) * size.width;

      // log('GxLinearBarGauge: Start Value: $startValue => $barStartValue');
      // log('GxLinearBarGauge: End Value: $endValue => $barEndValue');
      final Rect rect =
          Rect.fromLTWH(barStartValue, 0, barEndValue, size.height);
      final RRect rRect =
          RRect.fromRectAndRadius(rect, barPointer.radius ?? Radius.zero);

      canvas.drawRRect(rRect, paintAxis);

      startValue = endValue;

      // log('GxLinearBarGauge: Bar Drawn ======================');
    }
  }
}
