import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/item_card.dart';

class DefaultRadialAngle extends StatelessWidget {
  final double value;

  final Size twinSize;
  const DefaultRadialAngle({
    super.key,
    required this.value,
    required this.twinSize,
  });

  @override
  Widget build(BuildContext context) {
    return ItemCard(
      title: 'With Angle Customisation',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GxRadialGauge(
            showValueAtCenter: true,
            diameter: twinSize.width,
            startAngleInDegree: 180,
            sweepAngleInDegree: 180,
            value: GxGaugeValue(value: value),
            style: const GxRadialGaugeStyle(
              strokeCap: StrokeCap.butt,
              color: Colors.amber,
              thickness: 20,
            ),
          ),
          GxRadialGauge(
            showValueAtCenter: true,
            diameter: twinSize.width,
            startAngleInDegree: 270,
            sweepAngleInDegree: 180,
            value: GxGaugeValue(value: value),
            style: GxRadialGaugeStyle(
              color: Colors.cyanAccent.shade700,
              thickness: 20,
            ),
          ),
        ],
      ),
    );
  }
}
