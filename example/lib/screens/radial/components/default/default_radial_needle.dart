import 'package:examples/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class DefaultRadialNeedle extends StatelessWidget {
  final double value;

  final Size twinSize;
  const DefaultRadialNeedle(
      {super.key, required this.value, required this.twinSize});

  @override
  Widget build(BuildContext context) {
    const GaugeLabel defaultLabel = GaugeLabel(
      label: '{value}',
      style: TextStyle(fontSize: 12, color: Colors.black),
    );
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
                  value: GaugeValue(
                    value: value,
                  ),
                  showLabels: true,
                  interval: 10,
                  showNeedle: true,
                  needle: const RadialNeedle(
                      circle: NeedleCircle(
                          radius: 10, paintingStyle: PaintingStyle.fill),
                      color: Colors.red,
                      bottomOffset: 1.0,
                      thickness: 20,
                      topOffest: 0,
                      alignment: RadialElementAlignment.start),
                  style:
                      const RadialGaugeStyle(color: Colors.cyan, thickness: 10),
                ),
                GxRadialGauge(
                  showValueAtCenter: false,
                  startAngleInDegree: 135,
                  sweepAngleInDegree: 270,
                  size: twinSize,
                  value: GaugeValue(
                    value: value,
                  ),
                  interval: 10,
                  showNeedle: true,
                  needle: const RadialNeedle(
                      circle: NeedleCircle(
                          radius: 12,
                          strokeWidth: 5,
                          innerColor: Colors.orange,
                          paintingStyle: PaintingStyle.stroke),
                      color: Colors.indigo,
                      bottomOffset: 1.0,
                      thickness: 20,
                      topOffest: 0,
                      alignment: RadialElementAlignment.end),
                  style: const RadialGaugeStyle(
                      color: Colors.indigo, thickness: 15),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GxRadialGauge(
                  showValueAtCenter: false,
                  startAngleInDegree: 90,
                  sweepAngleInDegree: 180,
                  size: twinSize,
                  value: GaugeValue(
                    value: value,
                  ),
                  interval: 10,
                  showNeedle: true,
                  showMajorTicks: true,
                  valueToMajorTickCallback: (tickValue, index) {
                    return RadialTickStyle(
                        position: RadialElementPosition.inside,
                        alignment: RadialElementAlignment.end,
                        length: 12,
                        thickness: 2,
                        color: tickValue < value
                            ? Colors.amber
                            : Colors.amber.withOpacity(0.3));
                  },
                  needle: const RadialNeedle(
                      circle: NeedleCircle(
                          radius: 8,
                          strokeWidth: 5,
                          innerColor: Colors.orange,
                          paintingStyle: PaintingStyle.fill),
                      color: Colors.brown,
                      bottomOffset: 20.0,
                      thickness: 10,
                      topOffest: 12,
                      alignment: RadialElementAlignment.start),
                  style: const RadialGaugeStyle(
                      color: Colors.amber, thickness: 15),
                ),
                GxRadialGauge(
                  showValueAtCenter: false,
                  size: twinSize,
                  value: GaugeValue(
                    value: value,
                  ),
                  showLabels: true,
                  interval: 10,
                  showNeedle: true,
                  needle: const RadialNeedle(
                      shape: RadialNeedleShape.line,
                      circle: NeedleCircle(
                          radius: 8,
                          strokeWidth: 4,
                          paintingStyle: PaintingStyle.stroke),
                      color: Colors.grey,
                      bottomOffset: 20.0,
                      thickness: 4,
                      topOffest: 0,
                      alignment: RadialElementAlignment.start),
                  style: const RadialGaugeStyle(
                      color: Colors.blueGrey, thickness: 10),
                ),
              ],
            ),
          ],
        ));
  }
}
