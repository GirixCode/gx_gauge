import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/item_card.dart';

class DefaultRadialNeedle extends StatelessWidget {
  final double value;

  final Size twinSize;
  const DefaultRadialNeedle({
    super.key,
    required this.value,
    required this.twinSize,
  });

  @override
  Widget build(BuildContext context) {
    return ItemCard(
      title: 'With Needle Customisation',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GxRadialGauge(
                showValueAtCenter: false,
                size: twinSize,
                value: GxGaugeValue(value: value),
                showLabels: true,
                interval: 10,
                showNeedle: true,
                needle: const GxRadialNeedle(
                  circle: GxNeedleCap(
                    radius: 10,
                    paintingStyle: PaintingStyle.fill,
                  ),
                  color: Colors.red,
                  bottomOffset: 1.0,
                  thickness: 20,
                  topOffest: 0,
                  alignment: GxRadialElementAlignment.start,
                ),
                style: const GxRadialGaugeStyle(
                  color: Colors.cyan,
                  thickness: 10,
                ),
              ),
              GxRadialGauge(
                showValueAtCenter: false,
                startAngleInDegree: 135,
                sweepAngleInDegree: 270,
                size: twinSize,
                value: GxGaugeValue(value: value),
                interval: 10,
                showNeedle: true,
                needle: const GxRadialNeedle(
                  circle: GxNeedleCap(
                    radius: 12,
                    strokeWidth: 5,
                    innerColor: Colors.orange,
                    paintingStyle: PaintingStyle.stroke,
                  ),
                  color: Colors.indigo,
                  bottomOffset: 1.0,
                  thickness: 20,
                  topOffest: 0,
                  alignment: GxRadialElementAlignment.end,
                ),
                style: const GxRadialGaugeStyle(
                  color: Colors.indigo,
                  thickness: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GxRadialGauge(
                showValueAtCenter: false,
                startAngleInDegree: 90,
                sweepAngleInDegree: 180,
                size: twinSize,
                value: GxGaugeValue(value: value),
                interval: 10,
                showNeedle: true,
                showMajorTicks: true,
                majorTickStyler: (tickValue, index) {
                  return GxRadialTickStyle(
                    position: GxRadialElementPosition.inside,
                    alignment: GxRadialElementAlignment.end,
                    length: 12,
                    thickness: 2,
                    color: tickValue < value
                        ? Colors.amber
                        : Colors.amber.withValues(alpha: 0.3),
                  );
                },
                needle: const GxRadialNeedle(
                  circle: GxNeedleCap(
                    radius: 8,
                    strokeWidth: 5,
                    innerColor: Colors.orange,
                    paintingStyle: PaintingStyle.fill,
                  ),
                  color: Colors.brown,
                  bottomOffset: 20.0,
                  thickness: 10,
                  topOffest: 12,
                  alignment: GxRadialElementAlignment.start,
                ),
                style: const GxRadialGaugeStyle(
                  color: Colors.amber,
                  thickness: 15,
                ),
              ),
              GxRadialGauge(
                showValueAtCenter: false,
                size: twinSize,
                value: GxGaugeValue(value: value),
                showLabels: true,
                interval: 10,
                showNeedle: true,
                needle: const GxRadialNeedle(
                  shape: GxRadialNeedleShape.line,
                  circle: GxNeedleCap(
                    radius: 8,
                    strokeWidth: 4,
                    paintingStyle: PaintingStyle.stroke,
                  ),
                  color: Colors.grey,
                  bottomOffset: 20.0,
                  thickness: 4,
                  topOffest: 0,
                  alignment: GxRadialElementAlignment.start,
                ),
                style: const GxRadialGaugeStyle(
                  color: Colors.blueGrey,
                  thickness: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
