import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/radial/painters/radial_gauge_painter.dart';

import '../helpers/configs.dart';
import '../helpers/recording_canvas.dart';

const Offset _center = Offset(100, 100);

RecordingCanvas _paint(RadialPainterConfig config, {double value = 25}) {
  final RecordingCanvas canvas = RecordingCanvas();
  RadialGaugePainter(
    config: config,
    value: AlwaysStoppedAnimation<double>(value),
  ).paint(canvas, const Size(200, 200));
  return canvas;
}

/// (startAngle, sweepAngle) of each arc.
List<(double, double)> _arcs(RecordingCanvas canvas) => canvas
    .callsTo('drawArc')
    .map(
      (Invocation i) => (
        i.positionalArguments[1] as double,
        i.positionalArguments[2] as double,
      ),
    )
    .toList();

/// Tick lines drawn with [width] (major 2, minor 1).
List<Invocation> _ticks(RecordingCanvas canvas, double width) => canvas
    .callsTo('drawLine')
    .where(
      (Invocation i) =>
          (i.positionalArguments[2] as Paint).strokeWidth == width,
    )
    .toList();

/// The angle of a tick line, normalised to [0, 2π).
double _angle(Invocation line) {
  final Offset p = (line.positionalArguments[1] as Offset) - _center;
  return (math.atan2(p.dy, p.dx) + 2 * math.pi) % (2 * math.pi);
}

void main() {
  group('RadialGaugePainter arcs', () {
    test('draws the full track, then the value arc', () {
      final List<(double, double)> arcs = _arcs(_paint(radialConfig()));
      expect(arcs, hasLength(2));
      expect(arcs[0].$2, closeTo(2 * math.pi, 1e-9));
      expect(arcs[1].$2, closeTo(math.pi / 2, 1e-9));
    });

    test('honours start and sweep angles', () {
      final List<(double, double)> arcs = _arcs(
        _paint(
          radialConfig(startAngleInDegree: 135, sweepAngleInDegree: 270),
          value: 50,
        ),
      );
      expect(arcs[1].$1, closeTo(135 * math.pi / 180, 1e-9));
      expect(arcs[1].$2, closeTo(135 * math.pi / 180, 1e-9));
    });

    test('normalises the value arc with a non-zero min', () {
      final List<(double, double)> arcs = _arcs(
        _paint(radialConfig(scale: const GaugeScale(-50, 50)), value: 0),
      );
      expect(arcs[1].$2, closeTo(math.pi, 1e-9));
    });

    test('clamps an overshooting animation value', () {
      final List<(double, double)> arcs = _arcs(
        _paint(radialConfig(), value: 130),
      );
      expect(arcs[1].$2, closeTo(2 * math.pi, 1e-9));
    });
  });

  group('RadialGaugePainter ticks', () {
    test('draws one major tick per interval', () {
      expect(
        _ticks(_paint(radialConfig(showMajorTicks: true)), 2),
        hasLength(11),
      );
    });

    test('ticks respect a non-zero min', () {
      expect(
        _ticks(
          _paint(
            radialConfig(
              scale: const GaugeScale(50, 100),
              showMajorTicks: true,
            ),
          ),
          2,
        ),
        hasLength(6),
      );
    });

    test('an interval larger than the range does not produce NaN', () {
      final List<Invocation> ticks = _ticks(
        _paint(
          radialConfig(scale: const GaugeScale(0, 1), showMajorTicks: true),
        ),
        2,
      );
      expect(ticks, hasLength(2));
      expect(ticks.every((Invocation t) => _angle(t).isFinite), isTrue);
    });

    test('showMinorTicks works without major ticks or labels', () {
      expect(
        _ticks(
          _paint(radialConfig(showMinorTicks: true, minorTicksPerInterval: 4)),
          1,
        ),
        hasLength(40),
      );
    });

    test('minor ticks stay within the arc', () {
      final List<Invocation> minors = _ticks(
        _paint(
          radialConfig(
            startAngleInDegree: 135,
            sweepAngleInDegree: 270,
            showMinorTicks: true,
            minorTicksPerInterval: 4,
          ),
        ),
        1,
      );
      // The arc runs 135°..405°, i.e. everything except 45°..135°.
      for (final Invocation tick in minors) {
        final double degrees = _angle(tick) * 180 / math.pi;
        expect(degrees > 45 + 1e-6 && degrees < 135 - 1e-6, isFalse);
      }
    });
  });

  group('RadialGaugePainter needle', () {
    test('points at the normalised value', () {
      final Invocation needle = _paint(
        radialConfig(
          scale: const GaugeScale(-50, 50),
          radialNeedle: const GxRadialNeedle(shape: GxRadialNeedleShape.line),
        ),
        value: 0,
      ).callsTo('drawLine').single;
      final Offset tip = needle.positionalArguments[1] as Offset;
      expect(tip.dx, lessThan(_center.dx));
      expect(tip.dy, closeTo(_center.dy, 1e-6));
    });
  });

  group('RadialGaugePainter.shouldRepaint', () {
    const Animation<double> value = AlwaysStoppedAnimation<double>(10);
    RadialGaugePainter painter(RadialPainterConfig config) =>
        RadialGaugePainter(config: config, value: value);

    test('is false for an equal configuration', () {
      expect(
        painter(radialConfig()).shouldRepaint(painter(radialConfig())),
        isFalse,
      );
    });

    test('is true when the needle, ticks or pointers change', () {
      final RadialGaugePainter base = painter(radialConfig());
      for (final RadialPainterConfig changed in <RadialPainterConfig>[
        radialConfig(radialNeedle: const GxRadialNeedle()),
        radialConfig(showMajorTicks: true),
        radialConfig(interval: 5),
        radialConfig(sweepAngleInDegree: 180),
        radialConfig(
          pointers: const <GxRadialPointer>[GxRadialPointer(value: 3)],
        ),
      ]) {
        expect(painter(changed).shouldRepaint(base), isTrue);
      }
    });
  });
}
