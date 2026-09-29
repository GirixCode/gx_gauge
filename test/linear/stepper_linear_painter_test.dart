import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge/src/linear/painters/stepper_linear_painter.dart';

import '../helpers/configs.dart';
import '../helpers/recording_canvas.dart';

List<GxStepperStep> _steps(int n) => <GxStepperStep>[
  for (int i = 0; i < n; i++) GxStepperStep(label: GxGaugeLabel(label: '$i')),
];

List<Invocation> _circles(StepperPainterConfig config, double value) {
  final RecordingCanvas canvas = RecordingCanvas();
  StepperLinearPainter(
    config: config,
    value: AlwaysStoppedAnimation<double>(value),
  ).paint(canvas, const Size(200, 50));
  return canvas.callsTo('drawCircle').toList();
}

void main() {
  group('StepperLinearPainter', () {
    test('spaces steps evenly inside the track', () {
      final List<double> xs = _circles(
        stepperConfig(steps: _steps(3)),
        0,
      ).map((Invocation i) => (i.positionalArguments[0] as Offset).dx).toList();
      expect(xs, <double>[10, 100, 190]);
    });

    test('colors reached and unreached steps', () {
      final List<int> colors = _circles(stepperConfig(steps: _steps(3)), 1)
          .map(
            (Invocation i) =>
                (i.positionalArguments[2] as Paint).color.toARGB32(),
          )
          .toList();
      expect(colors, <int>[
        primary.toARGB32(),
        primary.toARGB32(),
        tick.toARGB32(),
      ]);
    });

    test('a single step does not divide by zero', () {
      final Offset center =
          _circles(
                stepperConfig(steps: _steps(1)),
                50,
              ).single.positionalArguments[0]
              as Offset;
      expect(center.dx.isFinite, isTrue);
    });

    test('no steps draws just the lines', () {
      expect(_circles(stepperConfig(), 50), isEmpty);
    });
  });
}
