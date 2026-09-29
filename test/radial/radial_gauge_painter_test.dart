import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

import '../helpers/recording_canvas.dart';

RadialGaugePainter _painter({
  required GaugeValue value,
  double startAngleInDegree = 0,
  double sweepAngleInDegree = 360,
}) {
  return RadialGaugePainter(
    value: value,
    style: const RadialGaugeStyle(),
    showMajorTicks: false,
    showMinorTicks: false,
    showLabels: false,
    majorTickStyle: const RadialTickStyle(),
    minorTickStyle: const RadialTickStyle(),
    labelTickStyle: const RadialTickLabelStyle(),
    interval: 10,
    minorTicksPerInterval: 10,
    startAngleInDegree: startAngleInDegree,
    sweepAngleInDegree: sweepAngleInDegree,
    showValueAtCenter: false,
    showNeedle: false,
    needleCircleInnerColor: Colors.white,
  );
}

/// Returns (startAngle, sweepAngle) for the track arc and the value arc.
List<(double, double)> _arcs(RadialGaugePainter painter) {
  final RecordingCanvas canvas = RecordingCanvas();
  painter.paint(canvas, const Size(200, 200));
  return canvas
      .callsTo('drawArc')
      .map(
        (Invocation i) => (
          i.positionalArguments[1] as double,
          i.positionalArguments[2] as double,
        ),
      )
      .toList();
}

void main() {
  group('RadialGaugePainter arcs', () {
    test('draws the full track, then the value arc (min = 0)', () {
      final List<(double, double)> arcs = _arcs(
        _painter(value: const GaugeValue(value: 25)),
      );
      expect(arcs, hasLength(2));
      expect(arcs[0].$2, closeTo(2 * math.pi, 1e-9));
      expect(arcs[1].$2, closeTo(math.pi / 2, 1e-9));
    });

    test('honours start and sweep angles', () {
      final List<(double, double)> arcs = _arcs(
        _painter(
          value: const GaugeValue(value: 50),
          startAngleInDegree: 135,
          sweepAngleInDegree: 270,
        ),
      );
      expect(arcs[1].$1, closeTo(135 * math.pi / 180, 1e-9));
      expect(arcs[1].$2, closeTo(135 * math.pi / 180, 1e-9));
    });

    test('normalises the value arc with a non-zero min', () {
      final List<(double, double)> arcs = _arcs(
        _painter(value: const GaugeValue(value: 0, min: -50, max: 50)),
      );
      expect(arcs[1].$2, closeTo(math.pi, 1e-9));
    }, skip: 'Known bug CR Radial 1: uses value / max. Fixed in Phase 2.');
  });

  group('RadialGaugePainter.shouldRepaint', () {
    test('is true when the value changes', () {
      expect(
        _painter(value: const GaugeValue(value: 1))
            .shouldRepaint(_painter(value: const GaugeValue(value: 2))),
        isTrue,
      );
    });
  });
}
