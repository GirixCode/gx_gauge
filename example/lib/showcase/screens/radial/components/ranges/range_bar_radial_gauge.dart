import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/item_card.dart';

class RangeBarRadialGaugeBody extends StatelessWidget {
  final double value;

  const RangeBarRadialGaugeBody({super.key, required this.value});

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
              diameter: twinSize.width,
              value: GxGaugeValue(value: value),
              showLabels: true,
              labelTickStyle: const GxRadialTickLabelStyle(padding: 30),
              interval: 10,
              style: const GxRadialGaugeStyle(color: Colors.cyan, thickness: 5),
              ranges: const [
                GxRadialRange(
                  // offset: 18,
                  height: 30,
                  start: 0,
                  end: 33,
                  color: Colors.green,
                  label: GxGaugeLabel(
                    label: 'Poor',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                GxRadialRange(
                  height: 30,
                  start: 33,
                  end: 66,
                  color: Colors.yellow,
                  label: GxGaugeLabel(
                    label: 'Average',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                GxRadialRange(
                  height: 30,
                  start: 66,
                  end: 100,
                  color: Colors.red,
                  label: GxGaugeLabel(
                    label: 'Good',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                // GxRadialRange(
                //     start: 33,
                //     end: 49,
                //     label: GxGaugeLabel(
                //         label: 'Average', style: TextStyle(color: Colors.red))),
              ],
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
