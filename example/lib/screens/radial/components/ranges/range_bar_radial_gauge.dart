import 'dart:math';

import 'package:examples/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class RangeBarRadialGaugeBody extends StatelessWidget {
  final double value;

  const RangeBarRadialGaugeBody({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    const Size twinSize = Size(200, 200);
    return ListView(
      children: [
        ItemCard(
          title: 'Range Bar',
          child: Center(
            child: GxRadialGauge(
              showValueAtCenter: true,
              // startAngleInDegree: 180,
              // sweepAngleInDegree: 180,
              size: twinSize,
              value: GaugeValue(
                value: value,
              ),
              showLabels: true,
              labelTickStyle: const RadialTickLabelStyle(
                padding: 30,
              ),
              interval: 10,
              style: const RadialGaugeStyle(
                color: Colors.cyan,
                thickness: 5,
              ),
              rangeBars: const [
                RadialBarRange(
                    // offset: 18,
                    height: 30,
                    startValue: 0,
                    endValue: 33,
                    color: Colors.green,
                    label: GaugeLabel(
                        label: 'Poor', style: TextStyle(color: Colors.red))),
                RadialBarRange(
                    height: 30,
                    startValue: 33,
                    endValue: 66,
                    color: Colors.yellow,
                    label: GaugeLabel(
                        label: 'Average', style: TextStyle(color: Colors.red))),
                RadialBarRange(
                    height: 30,
                    startValue: 66,
                    endValue: 100,
                    color: Colors.red,
                    label: GaugeLabel(
                        label: 'Good', style: TextStyle(color: Colors.red))),
                // RadialBarRange(
                //     startValue: 33,
                //     endValue: 49,
                //     label: GaugeLabel(
                //         label: 'Average', style: TextStyle(color: Colors.red))),
              ],
            ),
          ),
        ),
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
