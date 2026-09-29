import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/linear/painters/scale_linear_gauge_painter.dart';

import '../helpers/configs.dart';
import '../helpers/recording_canvas.dart';

RecordingCanvas _paint(ScalePainterConfig config, {double value = 50}) {
  final RecordingCanvas canvas = RecordingCanvas();
  ScaleLinearGaugePainter(
    config: config,
    value: AlwaysStoppedAnimation<double>(value),
  ).paint(canvas, const Size(220, 100));
  return canvas;
}

/// Lines drawn with [width] (major ticks are 2 wide, minor 1, axis 5).
List<Invocation> _lines(RecordingCanvas canvas, double width) => canvas
    .callsTo('drawLine')
    .where(
      (Invocation i) =>
          (i.positionalArguments[2] as Paint).strokeWidth == width,
    )
    .toList();

double _x(Invocation line) => (line.positionalArguments[0] as Offset).dx;

void main() {
  group('ScaleLinearGaugePainter ticks', () {
    test('draws one major tick per interval step', () {
      expect(_lines(_paint(scaleConfig()), 2), hasLength(11));
    });

    test('showMajorTicks: false hides major ticks', () {
      expect(_lines(_paint(scaleConfig(showMajorTicks: false)), 2), isEmpty);
    });

    test('degenerate intervals neither throw nor produce NaN', () {
      for (final double interval in <double>[0, -1, 1000]) {
        final List<Invocation> majors = _lines(
          _paint(scaleConfig(interval: interval)),
          2,
        );
        expect(majors, isNotEmpty);
        expect(majors.every((Invocation l) => _x(l).isFinite), isTrue);
      }
    });

    test('minor ticks fall strictly between major ticks', () {
      final RecordingCanvas canvas = _paint(
        scaleConfig(interval: 25, minorTicksPerInterval: 3),
      );
      final List<double> minors = _lines(canvas, 1).map(_x).toList();
      expect(minors, hasLength(12));
      expect(minors.every((double x) => x > 0 && x < 220), isTrue);
      expect(minors.first, closeTo(220 * 0.0625, 1e-9));
    });

    test('ticks, needle and value share the same track', () {
      final RecordingCanvas canvas = _paint(
        scaleConfig(
          axisSpaceExtent: 20,
          linearNeedle: const GxLinearNeedle(shape: GxNeedleShape.circle),
        ),
      );
      final double tickAt50 = _x(_lines(canvas, 2)[5]);
      final Offset needle =
          canvas.callsTo('drawCircle').single.positionalArguments[0] as Offset;
      expect(tickAt50, 110);
      expect(needle.dx, 110);
    });

    test('normalises with a non-zero min', () {
      final RecordingCanvas canvas = _paint(
        scaleConfig(
          scale: const GaugeScale(-50, 50),
          linearNeedle: const GxLinearNeedle(shape: GxNeedleShape.circle),
        ),
        value: 0,
      );
      final Offset needle =
          canvas.callsTo('drawCircle').single.positionalArguments[0] as Offset;
      expect(needle.dx, 110);
    });

    test('reversed puts min on the right', () {
      expect(_x(_lines(_paint(scaleConfig(reversed: true)), 2).first), 220);
    });
  });

  group('ScaleLinearGaugePainter bars', () {
    test('are drawn with the default cross tick position', () {
      final RecordingCanvas canvas = _paint(
        scaleConfig(
          bars: const <GxLinearBarPointer>[
            GxLinearBarPointer(start: 0, end: 40),
          ],
        ),
      );
      expect(canvas.callsTo('drawRRect'), hasLength(1));
    });
  });

  test('shouldRepaint notices a changed tick position', () {
    const Animation<double> value = AlwaysStoppedAnimation<double>(10);
    expect(
      ScaleLinearGaugePainter(
        config: scaleConfig(tickPosition: GxElementPosition.inside),
        value: value,
      ).shouldRepaint(
        ScaleLinearGaugePainter(config: scaleConfig(), value: value),
      ),
      isTrue,
    );
  });
}
