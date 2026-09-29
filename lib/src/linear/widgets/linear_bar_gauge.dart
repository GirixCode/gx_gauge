import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';
import 'package:girix_code_gauge/src/linear/painters/linear_bar_painter.dart';

class GxLinearBarGauge extends StatelessWidget {
  const GxLinearBarGauge({
    super.key,
    this.direction = LinearGaugeDirection.horizontal,
    required this.value,
    required this.barPointers,
    this.showTooltip = true,
    required this.size,
    this.needle,
    this.gapBetweenBars = 0,
    this.alignment = Alignment.centerLeft,
    this.showNeedleInsideBar = true,
    this.tooltip,
    this.customDrawNeedle,
  });
  final GaugeValue value;
  final List<LinearBarPointer> barPointers;
  final bool showTooltip;
  final LinearNeedle? needle;
  final Size size;
  final LinearGaugeDirection direction;
  final AlignmentGeometry alignment;
  final double gapBetweenBars;
  final bool showNeedleInsideBar;
  final GaugeTooltip? tooltip;
  final void Function(Canvas canvas, Offset position)? customDrawNeedle;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinearBarPainter(
        gapBetweenBars: gapBetweenBars,
        gaugeValue: value,
        barPointers: barPointers,
        needle: needle,
        showNeedleInsideBar: showNeedleInsideBar,
        direction: direction,
        tooltip: tooltip,
        customDrawNeedle: customDrawNeedle,
      ),
      size: size,
    );
  }
}
