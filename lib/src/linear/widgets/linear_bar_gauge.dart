import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/linear_gauge_common_model.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/linear/models/linear_needle_model.dart';
import 'package:gx_gauge/src/linear/painters/linear_bar_painter.dart';

class GxLinearBarGauge extends StatelessWidget {
  const GxLinearBarGauge({
    super.key,
    required this.value,
    required this.bars,
    this.showTooltip = true,
    required this.size,
    this.needle,
    this.gapBetweenBars = 0,
    this.alignment = Alignment.centerLeft,
    this.showNeedleInsideBar = true,
    this.tooltip,
    this.needlePainter,
  });
  final GxGaugeValue value;
  final List<GxLinearBarPointer> bars;
  final bool showTooltip;
  final GxLinearNeedle? needle;
  final Size size;
  final AlignmentGeometry alignment;
  final double gapBetweenBars;
  final bool showNeedleInsideBar;
  final GxGaugeTooltip? tooltip;
  final GxNeedlePainter? needlePainter;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinearBarPainter(
        gapBetweenBars: gapBetweenBars,
        gaugeValue: value,
        bars: bars,
        needle: needle,
        showNeedleInsideBar: showNeedleInsideBar,
        tooltip: tooltip,
        needlePainter: needlePainter,
      ),
      size: size,
    );
  }
}
