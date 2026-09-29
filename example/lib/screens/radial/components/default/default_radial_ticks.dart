import 'package:examples/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class DefaultRadialTicks extends StatelessWidget {
  final double value;

  final Size twinSize;
  const DefaultRadialTicks(
      {super.key, required this.value, required this.twinSize});

  @override
  Widget build(BuildContext context) {
    return ItemCard(
        title: 'With Customised Major Ticks',
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GxRadialGauge(
                  size: twinSize,
                  startAngleInDegree: 135,
                  sweepAngleInDegree: 270,
                  value: GaugeValue(
                    value: value,
                  ),
                  showMajorTicks: true,
                  interval: 10,
                  majorTickStyle: const RadialTickStyle(
                      position: RadialElementPosition.inside,
                      alignment: RadialElementAlignment.end,
                      length: 20,
                      thickness: 2,
                      color: Colors.blue),
                  style:
                      const RadialGaugeStyle(color: Colors.blue, thickness: 20),
                ),
                GxRadialGauge(
                  size: twinSize,
                  startAngleInDegree: 180,
                  value: GaugeValue(
                    value: value,
                  ),
                  showMajorTicks: true,
                  interval: 5,
                  valueToMajorTickCallback: (value, index) {
                    final bool isOdd = index.isOdd;
                    return RadialTickStyle(
                        position: RadialElementPosition.outside,
                        alignment: RadialElementAlignment.start,
                        length: 20,
                        thickness: 2,
                        color: isOdd
                            ? Colors.deepOrange.shade200
                            : Colors.deepOrange.shade300);
                  },
                  style: const RadialGaugeStyle(
                      color: Colors.deepOrange, thickness: 20),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GxRadialGauge(
                  showValueAtCenter: true,
                  size: twinSize,
                  // startAngleInDegree: 135,
                  // sweepAngleInDegree: 270,
                  value: GaugeValue(
                    value: value,
                  ),
                  showMajorTicks: true,
                  showMinorTicks: true,
                  minorTicksPerInterval: 20,
                  showLabels: true,
                  interval: 10,
                  labelTickStyle: const RadialTickLabelStyle(
                      padding: 2, position: RadialElementPosition.outside),
                  majorTickStyle: const RadialTickStyle(
                      position: RadialElementPosition.inside,
                      alignment: RadialElementAlignment.end,
                      length: 20,
                      thickness: 2,
                      color: Colors.red),
                  minorTickStyle: const RadialTickStyle(
                      position: RadialElementPosition.outside,
                      alignment: RadialElementAlignment.center,
                      length: 20,
                      thickness: 1,
                      color: Colors.redAccent),
                  style: const RadialGaugeStyle(
                      strokeCap: StrokeCap.butt,
                      color: Colors.orangeAccent,
                      thickness: 25),
                ),
                GxRadialGauge(
                  showValueAtCenter: false,
                  size: twinSize,
                  value: GaugeValue(
                    value: value,
                  ),
                  showMajorTicks: true,
                  showMinorTicks: true,
                  showLabels: true,
                  interval: 10,
                  majorTickStyle: const RadialTickStyle(
                      position: RadialElementPosition.inside,
                      alignment: RadialElementAlignment.center,
                      length: 15,
                      thickness: 3,
                      color: Colors.blue),
                  minorTickStyle: const RadialTickStyle(
                      position: RadialElementPosition.outside,
                      alignment: RadialElementAlignment.center,
                      length: 20,
                      thickness: 1,
                      color: Colors.lightBlueAccent),
                  style: const RadialGaugeStyle(
                      color: Colors.lightBlueAccent, thickness: 15),
                ),
              ],
            )
          ],
        ));
  }
}
