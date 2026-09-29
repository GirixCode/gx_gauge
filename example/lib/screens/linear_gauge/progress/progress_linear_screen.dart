import 'dart:math' as math;

import 'package:examples/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class MyProgressLinearGauge extends StatefulWidget {
  const MyProgressLinearGauge({super.key});

  @override
  State<MyProgressLinearGauge> createState() => _MyProgressLinearGaugeState();
}

class _MyProgressLinearGaugeState extends State<MyProgressLinearGauge> {
  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Linear Gauge'),
      ),
      body: ListView(
        key: const Key('linear_gauge_list'),
        padding: const EdgeInsets.all(10),
        children: [
          // const SizedBox(height: 2),

          const ItemCard(
            height: 80,
            title: 'Default Progress Linear Gauge',
            child: GxProgressLinearGauge(
              value: GaugeValue(value: 50),
              key: Key('linear_gauge_1'),
            ),
          ),
          // const SizedBox(height: 2),

          ItemCard(
            height: 80,
            title: 'Diamond Needle (Center)',
            child: GxProgressLinearGauge(
              value: const GaugeValue(value: 80, min: 00, max: 100),
              style: const ProgressLinearStyle(
                color: Colors.orange,
              ),
              key: const Key('linear_gauge_2'),
              needle: LinearNeedle(
                  position: LinearGaugeNeedlePosition.center,
                  size: const Size(20, 20),
                  color: Colors.blueGrey[800]!,
                  needleType: LinearGaugeNeedleType.diamond),
            ),
          ),
          const ItemCard(
            height: 100,
            title: 'With Label',
            child: GxProgressLinearGauge(
              // needle: LinearNeedle(
              //     enabled: true,
              //     position: LinearGaugeNeedlePosition.bottom,
              //     // size: Size(20, 20),
              //     color: Colors.blueGrey,
              //     needleType: LinearGaugeNeedleType.diamond),
              label: GaugeLabel(
                  label: '{value} %',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  spaceExtent: 4),
              showLabel: true,
              height: 30,
              value: GaugeValue(value: 39, min: 00, max: 100),
              style: ProgressLinearStyle(
                  color: Colors.orange, dense: false, thickness: 6),
              key: Key('linear_gauge_2_1'),
            ),
          ),
          const ItemCard(
            height: 100,
            title: 'With Reverse',
            child: GxProgressLinearGauge(
              // needle: LinearNeedle(
              //     enabled: true,
              //     position: LinearGaugeNeedlePosition.bottom,
              //     // size: Size(20, 20),
              //     color: Colors.blueGrey,
              //     needleType: LinearGaugeNeedleType.diamond),
              label: GaugeLabel(
                  label: '{value} %',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  spaceExtent: 4),
              showLabel: true,
              reverse: true,

              height: 20,
              value: GaugeValue(value: 61, min: 00, max: 100),
              style: ProgressLinearStyle(
                  color: Colors.greenAccent, dense: false, thickness: 6),
              key: Key('linear_gauge_2_1'),
            ),
          ),
          // const SizedBox(height: 2),

          ItemCard(
            height: 90,
            title: 'Circle Needle (Top)',
            child: GxProgressLinearGauge(
              value: const GaugeValue(value: 40, min: 10, max: 100),
              style: const ProgressLinearStyle(
                  radius: Radius.circular(20),
                  color: Colors.red,
                  thickness: 10),
              key: const Key('linear_gauge_3'),
              needle: LinearNeedle(
                  enabled: true,
                  position: LinearGaugeNeedlePosition.top,
                  size: const Size(20, 20),
                  color: Colors.blueGrey[800]!,
                  needleType: LinearGaugeNeedleType.circle),
            ),
          ),
          // const SizedBox(height: 2),

          ItemCard(
            // height: 80,
            title: 'Triangle Needle (Bottom)',
            child: GxProgressLinearGauge(
              value: const GaugeValue(value: 60, min: 10, max: 100),
              style: const ProgressLinearStyle(
                  radius: Radius.circular(20),
                  color: Colors.blueGrey,
                  thickness: 20),
              key: const Key('linear_gauge_4'),
              needle: LinearNeedle(
                  enabled: true,
                  position: LinearGaugeNeedlePosition.bottom,
                  size: const Size(20, 20),
                  color: Colors.blueGrey[800]!,
                  needleType: LinearGaugeNeedleType.triangle),
            ),
          ),
          // Pipe Needle
          // const SizedBox(height: 2),

          ItemCard(
            height: 80,
            title: 'Pipe Needle (Center)',
            child: GxProgressLinearGauge(
              value: const GaugeValue(value: 70, min: 0, max: 100),
              style: const ProgressLinearStyle(
                color: Colors.blue,
              ),
              key: const Key('linear_gauge_5'),
              label: const GaugeLabel(label: 'Pipe Needle'),
              needle: LinearNeedle(
                  enabled: true,
                  position: LinearGaugeNeedlePosition.center,
                  size: const Size(2, 70),
                  color: Colors.blue.shade500,
                  needleType: LinearGaugeNeedleType.pipe),
            ),
          ),
          // const SizedBox(height: 2),

          ItemCard(
            height: 80,
            title: 'Pipe Needle (Bottom)',
            child: GxProgressLinearGauge(
              value: const GaugeValue(value: 45, min: 0, max: 100),
              style: const ProgressLinearStyle(
                  color: Colors.brown,
                  dense: false,
                  radius: Radius.circular(20)),
              key: const Key('linear_gauge_5'),
              needle: LinearNeedle(
                  enabled: true,
                  position: LinearGaugeNeedlePosition.bottom,
                  size: const Size(4, 49),
                  color: Colors.brown.shade500,
                  needleType: LinearGaugeNeedleType.pipe),
            ),
          ),
          // Custom Needle
          // const SizedBox(height: 2),

          ItemCard(
            height: 80,
            title: 'Custom Needle (Center)',
            child: GxProgressLinearGauge(
              value: const GaugeValue(value: 50, min: 0, max: 100),
              style: const ProgressLinearStyle(
                color: Colors.greenAccent,
              ),
              key: const Key('linear_gauge_6'),
              needle: LinearNeedle(
                  enabled: true,
                  position: LinearGaugeNeedlePosition.center,
                  size: const Size(20, 20),
                  color: Colors.blue.shade500,
                  needleType: LinearGaugeNeedleType.custom),
              customDrawNeedle: _drawCustomNeedle,
            ),
          ),

          // const SizedBox(height: 2),
          ItemCard(
            height: 80,
            title: 'Animated Progress Linear Gauge',
            child: GxAnimatedProgressLinearGauge(
              value: 60,
              style: ProgressLinearStyle(
                  color: Colors.deepOrange.shade100, thickness: 10),
              animationType: GaugeAnimationType.linear,
              needle: const LinearNeedle(
                  position: LinearGaugeNeedlePosition.bottom,
                  size: Size(20, 20),
                  color: Colors.deepOrange,
                  needleType: LinearGaugeNeedleType.triangle),
              key: const Key('linear_gauge_7'),
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

// My Custom Needle
  void _drawCustomNeedle(Canvas canvas, Offset position) {
    // log('GxProgressLinearGauge: Custom Needle');
    final Paint customPaint = Paint()
      ..color = Colors.green.shade600
      ..style = PaintingStyle.fill;

    // Example: Draw a star shape
    Path starPath = Path();
    double radius = 10.0;
    for (int i = 0; i < 5; i++) {
      double angle = (i * 72.0) * (math.pi / 180.0);
      double x = position.dx + radius * math.cos(angle);
      double y = position.dy + radius * math.sin(angle);
      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();
    canvas.drawPath(starPath, customPaint);
  }
}
