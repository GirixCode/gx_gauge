// The source of every code snippet in the package README. The README shows
// each region's widget expression (sometimes with values inlined).
//
// `flutter analyze` compiles this file, so a README example that stops
// compiling fails the build. `tool/screenshots_test.dart` renders the
// quick-start snippets into doc/screenshots/, so README images always match
// the code next to them.
//
// When you change a region, update the matching README block, and when you
// change a quick-start region, re-run the screenshot tool.

import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';

// #docregion linear-progress
Widget linearProgress() => const GxLinearProgressGauge(
  value: GxGaugeValue(value: 68),
  needle: GxLinearNeedle(
    shape: GxNeedleShape.triangle,
    position: GxNeedlePosition.bottom,
    size: Size(14, 14),
  ),
);
// #enddocregion linear-progress

// #docregion linear-stepper
Widget linearStepper() => const GxLinearStepperGauge(
  currentStep: 2,
  steps: <GxStepperStep>[
    GxStepperStep(label: GxGaugeLabel(label: 'Ordered')),
    GxStepperStep(label: GxGaugeLabel(label: 'Packed')),
    GxStepperStep(label: GxGaugeLabel(label: 'Shipped')),
    GxStepperStep(label: GxGaugeLabel(label: 'Delivered')),
  ],
);
// #enddocregion linear-stepper

// #docregion linear-scale
Widget linearScale() => const GxLinearScaleGauge(
  value: GxGaugeValue(value: 72),
  interval: 20,
  minorTicksPerInterval: 3,
  needle: GxLinearNeedle(
    shape: GxNeedleShape.triangle,
    position: GxNeedlePosition.top,
    size: Size(14, 14),
  ),
  ranges: <GxLinearRange>[
    GxLinearRange(start: 0, end: 60, color: Colors.green),
    GxLinearRange(start: 60, end: 85, color: Colors.orange),
    GxLinearRange(start: 85, end: 100, color: Colors.red),
  ],
);
// #enddocregion linear-scale

// #docregion linear-bar
Widget linearBar() => const GxLinearBarGauge(
  value: GxGaugeValue(value: 72),
  gapBetweenBars: 4,
  bars: <GxLinearBarPointer>[
    GxLinearBarPointer(start: 0, end: 50, color: Colors.green),
    GxLinearBarPointer(start: 50, end: 80, color: Colors.orange),
    GxLinearBarPointer(start: 80, end: 100, color: Colors.red),
  ],
  needle: GxLinearNeedle(
    shape: GxNeedleShape.triangle,
    position: GxNeedlePosition.top,
    size: Size(14, 14),
  ),
);
// #enddocregion linear-bar

// #docregion radial
Widget radial() => const GxRadialGauge(
  value: GxGaugeValue(value: 65),
  diameter: 220,
  startAngleInDegree: 135,
  sweepAngleInDegree: 270,
  interval: 20,
  showMajorTicks: true,
  showMinorTicks: true,
  minorTicksPerInterval: 3,
  showLabels: true,
  showNeedle: true,
  needle: GxRadialNeedle(),
);
// #enddocregion radial

// #docregion radial-ranges
Widget radialRanges() => const GxRadialGauge(
  value: GxGaugeValue(value: 45),
  diameter: 220,
  startAngleInDegree: 150,
  sweepAngleInDegree: 240,
  style: GxRadialGaugeStyle(thickness: 6),
  showNeedle: true,
  needle: GxRadialNeedle(thickness: 6),
  ranges: <GxRadialRange>[
    GxRadialRange(
      start: 0,
      end: 60,
      offset: -16,
      color: Colors.green,
      label: GxGaugeLabel(label: 'Eco'),
    ),
    GxRadialRange(
      start: 60,
      end: 100,
      offset: -16,
      color: Colors.red,
      label: GxGaugeLabel(label: 'Sport'),
    ),
  ],
);
// #enddocregion radial-ranges

// #docregion custom-needle
// A top-level function is stable across rebuilds, so it doesn't force a
// repaint every time the parent rebuilds.
void drawPin(Canvas canvas, Offset anchor, GxLinearNeedle needle) {
  final Paint paint = Paint()..color = needle.color!;
  canvas.drawCircle(anchor, needle.size.width / 2, paint);
}

Widget customNeedle() => const GxLinearScaleGauge(
  value: GxGaugeValue(value: 40),
  needle: GxLinearNeedle(shape: GxNeedleShape.custom, size: Size(12, 12)),
  needlePainter: drawPin,
);
// #enddocregion custom-needle

// #docregion animation
Widget animated(double speed) => GxRadialGauge(
  value: GxGaugeValue(value: speed, max: 240),
  duration: const Duration(milliseconds: 600),
  curve: Curves.easeOutCubic,
);
// #enddocregion animation

// #docregion interaction
class VolumeKnob extends StatefulWidget {
  const VolumeKnob({super.key});

  @override
  State<VolumeKnob> createState() => _VolumeKnobState();
}

class _VolumeKnobState extends State<VolumeKnob> {
  double _volume = 30;

  @override
  Widget build(BuildContext context) {
    return GxRadialGauge(
      value: GxGaugeValue(value: _volume),
      semanticLabel: 'Volume',
      onChanged: (double v) => setState(() => _volume = v),
    );
  }
}
// #enddocregion interaction

// #docregion vertical
Widget vertical() => const SizedBox(
  height: 240,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      GxLinearProgressGauge(
        value: GxGaugeValue(value: 70),
        direction: Axis.vertical,
      ),
      GxLinearScaleGauge(
        value: GxGaugeValue(value: 70),
        direction: Axis.vertical,
        height: 80,
        interval: 25,
        needle: GxLinearNeedle(
          shape: GxNeedleShape.triangle,
          position: GxNeedlePosition.top,
        ),
      ),
    ],
  ),
);
// #enddocregion vertical

// #docregion theming
Widget themed() => Theme(
  data: ThemeData(colorSchemeSeed: Colors.teal, brightness: Brightness.dark),
  // Colors left unset come from the theme's ColorScheme.
  child: const GxLinearProgressGauge(value: GxGaugeValue(value: 40)),
);

Widget explicit() => const GxLinearProgressGauge(
  value: GxGaugeValue(value: 40),
  style: GxLinearProgressStyle(
    color: Colors.deepPurple,
    backgroundColor: Colors.black12,
  ),
);
// #enddocregion theming
