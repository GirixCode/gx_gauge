import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/item_card.dart';

class DefaultRadialTickLabel extends StatelessWidget {
  final double value;

  final Size twinSize;
  const DefaultRadialTickLabel({
    super.key,
    required this.value,
    required this.twinSize,
  });

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
                diameter: twinSize.width,
                value: GxGaugeValue(value: value),
                showLabels: true,
                labelTickStyle: const GxRadialTickLabelStyle(padding: 20),
                interval: 10,
                style: const GxRadialGaugeStyle(
                  color: Colors.cyan,
                  thickness: 15,
                ),
              ),
              GxRadialGauge(
                showValueAtCenter: false,
                startAngleInDegree: 45,
                diameter: twinSize.width,
                value: GxGaugeValue(value: value),
                showLabels: true,
                interval: 10,
                labelFormatter: (value, index) => index == 0
                    ? ''
                    : index.isEven
                    ? 'E${index.toInt()}'
                    : 'O${index.toInt()}',
                labelStyler: (value, index) {
                  if (index.isEven) {
                    return const GxRadialTickLabelStyle(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.cyan,
                      ),
                    );
                  } else {
                    return const GxRadialTickLabelStyle(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.teal,
                      ),
                    );
                  }
                },
                style: const GxRadialGaugeStyle(
                  color: Colors.teal,
                  thickness: 15,
                ),
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
                  diameter: twinSize.width,
                  value: GxGaugeValue(value: value),
                  showLabels: true,
                  showMajorTicks: true,
                  showNeedle: true,
                  needle: const GxRadialNeedle(
                    color: Colors.pink,
                    shape: GxRadialNeedleShape.line,
                    thickness: 2,
                  ),
                  majorTickStyle: const GxRadialTickStyle(
                    color: Colors.pink,
                    thickness: 1,
                    length: 15,
                    position: GxRadialElementPosition.outside,
                    alignment: GxRadialElementAlignment.start,
                  ),
                  labelTickStyle: const GxRadialTickLabelStyle(
                    padding: 10,
                    position: GxRadialElementPosition.outside,
                  ),
                  interval: 10,
                  style: const GxRadialGaugeStyle(
                    color: Colors.pink,
                    thickness: 15,
                  ),
                ),
              ),
              GxRadialGauge(
                showValueAtCenter: false,
                startAngleInDegree: 90,
                // sweepAngleInDegree: 300,
                diameter: twinSize.width,
                value: GxGaugeValue(value: value),
                showLabels: true,
                interval: 25,
                showMajorTicks: true,

                majorTickStyle: const GxRadialTickStyle(
                  color: Colors.deepPurple,
                  thickness: 1,
                  length: 15,
                  position: GxRadialElementPosition.inside,
                  alignment: GxRadialElementAlignment.end,
                ),

                labelFormatter: (value, index) {
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
                labelStyler: (tickValue, index) {
                  return GxRadialTickLabelStyle(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color:
                          tickValue <= value ||
                              (tickValue == 100.0 && value != 0.0)
                          ? Colors.deepPurple
                          : Colors.deepPurple.shade200,
                    ),
                    position: GxRadialElementPosition.inside,
                  );
                },
                style: const GxRadialGaugeStyle(
                  color: Colors.deepPurple,
                  thickness: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
