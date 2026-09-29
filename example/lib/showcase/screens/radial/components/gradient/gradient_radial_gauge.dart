import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/item_card.dart';

class GradientRadialGaugeBody extends StatelessWidget {
  final double value;

  const GradientRadialGaugeBody({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    const Size twinSize = Size(250, 250);
    return ListView(
      children: [
        ItemCard(
          title: 'Foreground Gradient',
          child: Center(
            child: GxRadialGauge(
              showValueAtCenter: true,
              size: twinSize,
              value: GxGaugeValue(value: value),
              showLabels: false,
              labelTickStyle: const GxRadialTickLabelStyle(padding: 30),
              interval: 10,
              style: const GxRadialGaugeStyle(
                color: Colors.cyan,
                thickness: 35,
                gradient: LinearGradient(
                  colors: [
                    Colors.cyan,
                    Colors.blue,
                    Colors.purple,
                    Colors.pinkAccent,
                    Colors.redAccent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.2, 0.4, 0.6, 1.0],
                ),
              ),
            ),
          ),
        ),
        ItemCard(
          title: 'Foreground and Background Gradient',
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: GxRadialGauge(
                showValueAtCenter: false,
                startAngleInDegree: 180,
                sweepAngleInDegree: 180,
                size: twinSize,
                value: GxGaugeValue(value: value),
                showLabels: true,
                showMajorTicks: true,
                showNeedle: true,
                needle: const GxRadialNeedle(
                  color: Colors.lightBlue,
                  shape: GxRadialNeedleShape.taperedLine,
                  thickness: 18,
                  alignment: GxRadialElementAlignment.end,
                  circle: GxNeedleCap(radius: 15),
                  gradient: LinearGradient(
                    colors: [
                      Colors.yellow,
                      Colors.indigo,
                      Colors.lightBlue,
                      Colors.limeAccent,
                      Colors.redAccent,
                    ],
                  ),
                ),
                majorTickStyle: const GxRadialTickStyle(
                  color: Colors.pink,
                  thickness: 1,
                  length: 25,
                  position: GxRadialElementPosition.outside,
                  alignment: GxRadialElementAlignment.start,
                ),
                labelTickStyle: const GxRadialTickLabelStyle(
                  padding: 20,
                  position: GxRadialElementPosition.outside,
                ),
                interval: 10,
                style: const GxRadialGaugeStyle(
                  color: Colors.pink,
                  thickness: 35,
                  backgroundGradient: LinearGradient(
                    colors: [
                      Colors.yellow,
                      Colors.indigo,
                      Colors.lightBlue,
                      Colors.limeAccent,
                      Colors.redAccent,
                    ],
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.yellow,
                      Colors.indigo,
                      Colors.lightBlue,
                      Colors.limeAccent,
                      Colors.redAccent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        ItemCard(
          title: 'With Circular Gradient',
          child: Center(
            child: GxRadialGauge(
              showValueAtCenter: false,
              startAngleInDegree: 90,
              // sweepAngleInDegree: 300,
              size: twinSize,
              value: const GxGaugeValue(value: 100),
              showLabels: true,
              interval: 25,
              showMajorTicks: true,

              majorTickStyle: const GxRadialTickStyle(
                color: Colors.deepPurple,
                thickness: 1,
                length: 20,
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
                  padding: 30,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color:
                        tickValue <= value ||
                            (tickValue == 100.0 && value != 0.0)
                        ? Colors.deepPurple
                        : Colors.blueGrey,
                  ),
                  position: GxRadialElementPosition.inside,
                );
              },
              style: GxRadialGaugeStyle(
                color: Colors.deepPurple,
                thickness: 35,
                paintingStyle: PaintingStyle.fill,

                // Four gradient colors for the direction
                gradient: RadialGradient(
                  colors: const [
                    Color.fromARGB(255, 209, 212, 23),
                    Color.fromARGB(255, 27, 232, 126),
                    Color.fromARGB(255, 1, 115, 180),
                  ],
                  stops: [getStopValue(0.6), 0.5, 1],
                  center: Alignment.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double getStopValue(double max) {
    // Get a random value between 0.1 and max
    final double v = ((Random().nextDouble() + value) / 100) - max;

    return v;
  }
}
