import 'package:examples/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class DefaultRadialAngle extends StatelessWidget {
  final double value;

  final Size twinSize;
  const DefaultRadialAngle(
      {super.key, required this.value, required this.twinSize});

  @override
  Widget build(BuildContext context) {
    return ItemCard(
        title: 'With Angle Customisation',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GxRadialGauge(
              showValueAtCenter: true,
              size: twinSize,
              startAngleInDegree: 180,
              sweepAngleInDegree: 180,
              value: GaugeValue(
                value: value,
              ),
              style: const RadialGaugeStyle(
                  strokeCap: StrokeCap.butt,
                  color: Colors.amber,
                  thickness: 20),
            ),
            GxRadialGauge(
              showValueAtCenter: true,
              size: twinSize,
              startAngleInDegree: 270,
              sweepAngleInDegree: 180,
              value: GaugeValue(
                value: value,
              ),
              style: RadialGaugeStyle(
                  color: Colors.cyanAccent.shade700, thickness: 20),
            ),
          ],
        ));
  }
}
