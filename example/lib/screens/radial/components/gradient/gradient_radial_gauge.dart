import 'dart:math';

import 'package:examples/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class GradientRadialGaugeBody extends StatelessWidget {
  final double value;

  const GradientRadialGaugeBody({
    super.key,
    required this.value,
  });

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
              value: GaugeValue(
                value: value,
              ),
              showLabels: false,
              labelTickStyle: const RadialTickLabelStyle(
                padding: 30,
              ),
              interval: 10,
              style: const RadialGaugeStyle(
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
                    stops: [0.0, 0.2, 0.4, 0.6, 1.0]),
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
                  value: GaugeValue(
                    value: value,
                  ),
                  showLabels: true,
                  showMajorTicks: true,
                  showNeedle: true,
                  needle: const RadialNeedle(
                    color: Colors.lightBlue,
                    shape: RadialNeedleShape.tapperedLine,
                    thickness: 18,
                    alignment: RadialElementAlignment.end,
                    circle: NeedleCircle(
                      radius: 15,
                    ),
                    gradient: LinearGradient(colors: [
                      Colors.yellow,
                      Colors.indigo,
                      Colors.lightBlue,
                      Colors.limeAccent,
                      Colors.redAccent,
                    ]),
                  ),
                  majorTickStyle: const RadialTickStyle(
                      color: Colors.pink,
                      thickness: 1,
                      length: 25,
                      position: RadialElementPosition.outside,
                      alignment: RadialElementAlignment.start),
                  labelTickStyle: const RadialTickLabelStyle(
                    padding: 20,
                    position: RadialElementPosition.outside,
                  ),
                  interval: 10,
                  style: const RadialGaugeStyle(
                    color: Colors.pink,
                    thickness: 35,
                    backgroundGradient: LinearGradient(colors: [
                      Colors.yellow,
                      Colors.indigo,
                      Colors.lightBlue,
                      Colors.limeAccent,
                      Colors.redAccent,
                    ]),
                    gradient: LinearGradient(colors: [
                      Colors.yellow,
                      Colors.indigo,
                      Colors.lightBlue,
                      Colors.limeAccent,
                      Colors.redAccent,
                    ]),
                  ),
                ),
              ),
            )),
        ItemCard(
            title: 'With Circular Gradient',
            child: Center(
              child: GxRadialGauge(
                showValueAtCenter: false,
                startAngleInDegree: 90,
                // sweepAngleInDegree: 300,
                size: twinSize,
                value: const GaugeValue(
                  value: 100,
                ),
                showLabels: true,
                interval: 25,
                showMajorTicks: true,

                majorTickStyle: const RadialTickStyle(
                    color: Colors.deepPurple,
                    thickness: 1,
                    length: 20,
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
                    padding: 30,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: tickValue <= value ||
                                (tickValue == 100.0 && value != 0.0)
                            ? Colors.deepPurple
                            : Colors.blueGrey),
                    position: RadialElementPosition.inside,
                  );
                },
                style: RadialGaugeStyle(
                    color: Colors.deepPurple,
                    thickness: 35,
                    paintingStyle: PaintingStyle.fill,

                    // Four gradient colors for the direction
                    gradient: RadialGradient(
                      colors: const [
                        Color.fromARGB(255, 209, 212, 23),
                        Color.fromARGB(255, 27, 232, 126),
                        Color.fromARGB(255, 1, 115, 180)
                      ],
                      stops: [getStopValue(0.6), 0.5, 1],
                      center: Alignment.center,
                    )),
              ),
            )),
      ],
    );
  }

  getStopValue(double max) {
    // Get a random value between 0.1 and max
    final double v = ((Random().nextDouble() + value) / 100) - max;
    print('Radial Gradient Value: $v');

    return v;
  }
}
