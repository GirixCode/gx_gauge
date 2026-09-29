import 'package:examples/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class DefaultRadialTickLabel extends StatelessWidget {
  final double value;

  final Size twinSize;
  const DefaultRadialTickLabel(
      {super.key, required this.value, required this.twinSize});

  @override
  Widget build(BuildContext context) {
    return ItemCard(
        title: 'With Label Customisation',
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
                  labelTickStyle: const RadialTickLabelStyle(
                    padding: 20,
                  ),
                  interval: 10,
                  style:
                      const RadialGaugeStyle(color: Colors.cyan, thickness: 15),
                ),
                GxRadialGauge(
                  showValueAtCenter: false,
                  startAngleInDegree: 45,
                  size: twinSize,
                  value: GaugeValue(
                    value: value,
                  ),
                  showLabels: true,
                  interval: 10,
                  valueToLabelFormatCallback: (value, index) => index == 0
                      ? ''
                      : index.isEven
                          ? 'E${index.toInt()}'
                          : 'O${index.toInt()}',
                  valueToLabelStyleCallback: (value, index) {
                    if (index.isEven) {
                      return const RadialTickLabelStyle(
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.cyan));
                    } else {
                      return const RadialTickLabelStyle(
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.teal));
                    }
                  },
                  style:
                      const RadialGaugeStyle(color: Colors.teal, thickness: 15),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 10),
                  child: GxRadialGauge(
                    showValueAtCenter: false,
                    startAngleInDegree: 180,
                    sweepAngleInDegree: 180,
                    size: twinSize,
                    value: GaugeValue(
                      value: value,
                    ),
                    showLabels: true,
                    showMajorTicks: true,
                    showNeedle: true,
                    needle: const RadialNeedle(
                      color: Colors.pink,
                      shape: RadialNeedleShape.line,
                      thickness: 2,
                    ),
                    majorTickStyle: const RadialTickStyle(
                        color: Colors.pink,
                        thickness: 1,
                        length: 15,
                        position: RadialElementPosition.outside,
                        alignment: RadialElementAlignment.start),
                    labelTickStyle: const RadialTickLabelStyle(
                      padding: 10,
                      position: RadialElementPosition.outside,
                    ),
                    interval: 10,
                    style: const RadialGaugeStyle(
                        color: Colors.pink, thickness: 15),
                  ),
                ),
                GxRadialGauge(
                  showValueAtCenter: false,
                  startAngleInDegree: 90,
                  // sweepAngleInDegree: 300,
                  size: twinSize,
                  value: GaugeValue(
                    value: value,
                  ),
                  showLabels: true,
                  interval: 25,
                  showMajorTicks: true,

                  majorTickStyle: const RadialTickStyle(
                      color: Colors.deepPurple,
                      thickness: 1,
                      length: 15,
                      position: RadialElementPosition.inside,
                      alignment: RadialElementAlignment.end),

                  valueToLabelFormatCallback: (value, index) {
                    if (index == 0) {
                      return '';
                    } else {
                      return index == 1
                          ? 'West'
                          : index == 2
                              ? 'North'
                              : index == 3
                                  ? 'East'
                                  : 'South';
                    }
                  },
                  valueToLabelStyleCallback: (tickValue, index) {
                    return RadialTickLabelStyle(
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: tickValue <= value ||
                                  (tickValue == 100.0 && value != 0.0)
                              ? Colors.deepPurple
                              : Colors.deepPurple.shade200),
                      position: RadialElementPosition.inside,
                    );
                  },
                  style: const RadialGaugeStyle(
                      color: Colors.deepPurple, thickness: 15),
                ),
              ],
            ),
          ],
        ));
  }
}
