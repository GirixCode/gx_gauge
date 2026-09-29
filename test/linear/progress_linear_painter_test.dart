import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/linear/painters/progress_linear_painter.dart';

import '../helpers/configs.dart';
import '../helpers/recording_canvas.dart';

const Size _size = Size(200, 20);

RecordingCanvas _paint(ProgressPainterConfig config, double value) {
  final RecordingCanvas canvas = RecordingCanvas();
  ProgressLinearPainter(
    config: config,
    value: AlwaysStoppedAnimation<double>(value),
  ).paint(canvas, _size);
  return canvas;
}

void main() {
  group('ProgressLinearPainter (dense)', () {
    test('draws the track then the progress line', () {
      final List<Invocation> lines = _paint(
        progressConfig(),
        25,
      ).callsTo('drawLine').toList();
      expect(lines, hasLength(2));
      expect(lines[0].positionalArguments[1], const Offset(200, 10));
      expect(lines[1].positionalArguments[0], const Offset(0, 10));
      expect(lines[1].positionalArguments[1], const Offset(50, 10));
    });

    test('normalises with a non-zero min', () {
      expect(
        _paint(
          progressConfig(scale: const GaugeScale(50, 150)),
          75,
        ).callsTo('drawLine').last.positionalArguments[1],
        const Offset(50, 10),
      );
    });

    test('clamps an overshooting animation value to the track', () {
      expect(
        _paint(
          progressConfig(),
          112,
        ).callsTo('drawLine').last.positionalArguments[1],
        const Offset(200, 10),
      );
    });

    test('fills from the right when reversed', () {
      final Invocation progress = _paint(
        progressConfig(reversed: true),
        25,
      ).callsTo('drawLine').last;
      expect(progress.positionalArguments[0], const Offset(200, 10));
      expect(progress.positionalArguments[1], const Offset(150, 10));
    });
  });

  group('ProgressLinearPainter (not dense)', () {
    test('draws a full-size track and a proportional value rect', () {
      final List<Invocation> rrects = _paint(
        progressConfig(
          style: const GxLinearProgressStyle(dense: false, radius: Radius.zero),
        ),
        40,
      ).callsTo('drawRRect').toList();
      expect(rrects, hasLength(2));
      expect(
        (rrects[0].positionalArguments[0] as RRect).outerRect,
        Offset.zero & _size,
      );
      expect(
        (rrects[1].positionalArguments[0] as RRect).outerRect,
        const Rect.fromLTWH(0, 0, 80, 20),
      );
    });
  });

  group('ProgressLinearPainter.shouldRepaint', () {
    const Animation<double> value = AlwaysStoppedAnimation<double>(10);
    ProgressLinearPainter painter(ProgressPainterConfig config) =>
        ProgressLinearPainter(config: config, value: value);

    test('is false for an equal configuration', () {
      expect(
        painter(progressConfig()).shouldRepaint(painter(progressConfig())),
        isFalse,
      );
    });

    test('is true when any drawn field changes', () {
      final ProgressLinearPainter base = painter(progressConfig());
      for (final ProgressPainterConfig changed in <ProgressPainterConfig>[
        progressConfig(reversed: true),
        progressConfig(scale: const GaugeScale(0, 50)),
        progressConfig(
          style: const GxLinearProgressStyle(strokeCap: StrokeCap.round),
        ),
        progressConfig(
          style: const GxLinearProgressStyle(
            paintingStyle: PaintingStyle.stroke,
          ),
        ),
        progressConfig(gaugeLabel: const GxGaugeLabel(label: 'x')),
        progressConfig(linearNeedle: const GxLinearNeedle()),
      ]) {
        expect(painter(changed).shouldRepaint(base), isTrue);
      }
    });
  });
}
