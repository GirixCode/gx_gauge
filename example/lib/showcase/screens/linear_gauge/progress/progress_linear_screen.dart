import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/item_card.dart';

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
      appBar: AppBar(title: const Text('Progress Linear Gauge')),
      body: ListView(
        key: const Key('linear_gauge_list'),
        padding: const EdgeInsets.all(10),
        children: [
          // const SizedBox(height: 2),

          const ItemCard(
            height: 80,
            title: 'Default Progress Linear Gauge',
            child: GxLinearProgressGauge(
              value: GxGaugeValue(value: 50),
              key: Key('linear_gauge_1'),
            ),
          ),
          // const SizedBox(height: 2),

          ItemCard(
            height: 80,
            title: 'Diamond Needle (Center)',
            child: GxLinearProgressGauge(
              value: const GxGaugeValue(value: 80, min: 00, max: 100),
              style: const GxLinearProgressStyle(color: Colors.orange),
              key: const Key('linear_gauge_2'),
              needle: GxLinearNeedle(
                position: GxNeedlePosition.center,
                size: const Size(20, 20),
                color: Colors.blueGrey[800]!,
                shape: GxNeedleShape.diamond,
              ),
            ),
          ),
          const ItemCard(
            height: 100,
            title: 'With Label',
            child: GxLinearProgressGauge(
              // needle: GxLinearNeedle(
              //     enabled: true,
              //     position: GxNeedlePosition.bottom,
              //     // size: Size(20, 20),
              //     color: Colors.blueGrey,
              //     shape: GxNeedleShape.diamond),
              label: GxGaugeLabel(
                label: '{value} %',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                spaceExtent: 4,
              ),
              showLabel: true,
              height: 30,
              value: GxGaugeValue(value: 39, min: 00, max: 100),
              style: GxLinearProgressStyle(
                color: Colors.orange,
                dense: false,
                thickness: 6,
              ),
              key: Key('linear_gauge_2_1'),
            ),
          ),
          const ItemCard(
            height: 100,
            title: 'With Reverse',
            child: GxLinearProgressGauge(
              // needle: GxLinearNeedle(
              //     enabled: true,
              //     position: GxNeedlePosition.bottom,
              //     // size: Size(20, 20),
              //     color: Colors.blueGrey,
              //     shape: GxNeedleShape.diamond),
              label: GxGaugeLabel(
                label: '{value} %',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                spaceExtent: 4,
              ),
              showLabel: true,
              reverse: true,

              height: 20,
              value: GxGaugeValue(value: 61, min: 00, max: 100),
              style: GxLinearProgressStyle(
                color: Colors.greenAccent,
                dense: false,
                thickness: 6,
              ),
              key: Key('linear_gauge_2_1'),
            ),
          ),
          // const SizedBox(height: 2),

          ItemCard(
            height: 90,
            title: 'Circle Needle (Top)',
            child: GxLinearProgressGauge(
              value: const GxGaugeValue(value: 40, min: 10, max: 100),
              style: const GxLinearProgressStyle(
                radius: Radius.circular(20),
                color: Colors.red,
                thickness: 10,
              ),
              key: const Key('linear_gauge_3'),
              needle: GxLinearNeedle(
                enabled: true,
                position: GxNeedlePosition.top,
                size: const Size(20, 20),
                color: Colors.blueGrey[800]!,
                shape: GxNeedleShape.circle,
              ),
            ),
          ),
          // const SizedBox(height: 2),

          ItemCard(
            // height: 80,
            title: 'Triangle Needle (Bottom)',
            child: GxLinearProgressGauge(
              value: const GxGaugeValue(value: 60, min: 10, max: 100),
              style: const GxLinearProgressStyle(
                radius: Radius.circular(20),
                color: Colors.blueGrey,
                thickness: 20,
              ),
              key: const Key('linear_gauge_4'),
              needle: GxLinearNeedle(
                enabled: true,
                position: GxNeedlePosition.bottom,
                size: const Size(20, 20),
                color: Colors.blueGrey[800]!,
                shape: GxNeedleShape.triangle,
              ),
            ),
          ),
          // Pipe Needle
          // const SizedBox(height: 2),

          ItemCard(
            height: 80,
            title: 'Pipe Needle (Center)',
            child: GxLinearProgressGauge(
              value: const GxGaugeValue(value: 70, min: 0, max: 100),
              style: const GxLinearProgressStyle(color: Colors.blue),
              key: const Key('linear_gauge_5'),
              label: const GxGaugeLabel(label: 'Pipe Needle'),
              needle: GxLinearNeedle(
                enabled: true,
                position: GxNeedlePosition.center,
                size: const Size(2, 70),
                color: Colors.blue.shade500,
                shape: GxNeedleShape.pipe,
              ),
            ),
          ),
          // const SizedBox(height: 2),

          ItemCard(
            height: 80,
            title: 'Pipe Needle (Bottom)',
            child: GxLinearProgressGauge(
              value: const GxGaugeValue(value: 45, min: 0, max: 100),
              style: const GxLinearProgressStyle(
                color: Colors.brown,
                dense: false,
                radius: Radius.circular(20),
              ),
              key: const Key('linear_gauge_5'),
              needle: GxLinearNeedle(
                enabled: true,
                position: GxNeedlePosition.bottom,
                size: const Size(4, 49),
                color: Colors.brown.shade500,
                shape: GxNeedleShape.pipe,
              ),
            ),
          ),
          // Custom Needle
          // const SizedBox(height: 2),

          ItemCard(
            height: 80,
            title: 'Custom Needle (Center)',
            child: GxLinearProgressGauge(
              value: const GxGaugeValue(value: 50, min: 0, max: 100),
              style: const GxLinearProgressStyle(color: Colors.greenAccent),
              key: const Key('linear_gauge_6'),
              needle: GxLinearNeedle(
                enabled: true,
                position: GxNeedlePosition.center,
                size: const Size(20, 20),
                color: Colors.blue.shade500,
                shape: GxNeedleShape.custom,
              ),
              needlePainter: _drawCustomNeedle,
            ),
          ),

          // const SizedBox(height: 2),
          ItemCard(
            height: 80,
            title: 'Animated Progress Linear Gauge',
            child: GxLinearProgressGauge(
              value: const GxGaugeValue(value: 60),
              duration: const Duration(milliseconds: 600),
              curve: Curves.linear,
              style: GxLinearProgressStyle(
                color: Colors.deepOrange.shade100,
                thickness: 10,
              ),
              needle: const GxLinearNeedle(
                position: GxNeedlePosition.bottom,
                size: Size(20, 20),
                color: Colors.deepOrange,
                shape: GxNeedleShape.triangle,
              ),
              key: const Key('linear_gauge_7'),
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // My Custom Needle
  void _drawCustomNeedle(
    Canvas canvas,
    Offset position,
    GxLinearNeedle needle,
  ) {
    // log('GxLinearProgressGauge: Custom Needle');
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
