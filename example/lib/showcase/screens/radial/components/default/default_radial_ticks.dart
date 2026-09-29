import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/item_card.dart';

class DefaultRadialTicks extends StatelessWidget {
  final double value;

  final Size twinSize;
  const DefaultRadialTicks({
    super.key,
    required this.value,
    required this.twinSize,
  });

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
                diameter: twinSize.width,
                startAngleInDegree: 135,
                sweepAngleInDegree: 270,
                value: GxGaugeValue(value: value),
                showMajorTicks: true,
                interval: 10,
                majorTickStyle: const GxRadialTickStyle(
                  position: GxRadialElementPosition.inside,
                  alignment: GxRadialElementAlignment.end,
                  length: 20,
                  thickness: 2,
                  color: Colors.blue,
                ),
                style: const GxRadialGaugeStyle(
                  color: Colors.blue,
                  thickness: 20,
                ),
              ),
              GxRadialGauge(
                diameter: twinSize.width,
                startAngleInDegree: 180,
                value: GxGaugeValue(value: value),
                showMajorTicks: true,
                interval: 5,
                majorTickStyler: (value, index) {
                  final bool isOdd = index.isOdd;
                  return GxRadialTickStyle(
                    position: GxRadialElementPosition.outside,
                    alignment: GxRadialElementAlignment.start,
                    length: 20,
                    thickness: 2,
                    color: isOdd
                        ? Colors.deepOrange.shade200
                        : Colors.deepOrange.shade300,
                  );
                },
                style: const GxRadialGaugeStyle(
                  color: Colors.deepOrange,
                  thickness: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GxRadialGauge(
                showValueAtCenter: true,
                diameter: twinSize.width,
                // startAngleInDegree: 135,
                // sweepAngleInDegree: 270,
                value: GxGaugeValue(value: value),
                showMajorTicks: true,
                showMinorTicks: true,
                minorTicksPerInterval: 20,
                showLabels: true,
                interval: 10,
                labelTickStyle: const GxRadialTickLabelStyle(
                  padding: 2,
                  position: GxRadialElementPosition.outside,
                ),
                majorTickStyle: const GxRadialTickStyle(
                  position: GxRadialElementPosition.inside,
                  alignment: GxRadialElementAlignment.end,
                  length: 20,
                  thickness: 2,
                  color: Colors.red,
                ),
                minorTickStyle: const GxRadialTickStyle(
                  position: GxRadialElementPosition.outside,
                  alignment: GxRadialElementAlignment.center,
                  length: 20,
                  thickness: 1,
                  color: Colors.redAccent,
                ),
                style: const GxRadialGaugeStyle(
                  strokeCap: StrokeCap.butt,
                  color: Colors.orangeAccent,
                  thickness: 25,
                ),
              ),
              GxRadialGauge(
                showValueAtCenter: false,
                diameter: twinSize.width,
                value: GxGaugeValue(value: value),
                showMajorTicks: true,
                showMinorTicks: true,
                showLabels: true,
                interval: 10,
                majorTickStyle: const GxRadialTickStyle(
                  position: GxRadialElementPosition.inside,
                  alignment: GxRadialElementAlignment.center,
                  length: 15,
                  thickness: 3,
                  color: Colors.blue,
                ),
                minorTickStyle: const GxRadialTickStyle(
                  position: GxRadialElementPosition.outside,
                  alignment: GxRadialElementAlignment.center,
                  length: 20,
                  thickness: 1,
                  color: Colors.lightBlueAccent,
                ),
                style: const GxRadialGaugeStyle(
                  color: Colors.lightBlueAccent,
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
