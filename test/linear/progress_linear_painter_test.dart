import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge/src/linear/painters/progress_linear_painter.dart';

import '../helpers/recording_canvas.dart';

void main() {
  const Size size = Size(200, 20);

  RecordingCanvas paint(ProgressLinearPainter painter) {
    final RecordingCanvas canvas = RecordingCanvas();
    painter.paint(canvas, size);
    return canvas;
  }

  group('ProgressLinearPainter (dense)', () {
    test('draws the track then the progress line', () {
      final RecordingCanvas canvas = paint(
        ProgressLinearPainter(
          gaugeValue: const GxGaugeValue(value: 25),
          style: const GxLinearProgressStyle(),
        ),
      );
      final List<Invocation> lines = canvas.callsTo('drawLine').toList();
      expect(lines, hasLength(2));
      expect(lines[0].positionalArguments[1], const Offset(200, 10));
      expect(lines[1].positionalArguments[0], const Offset(0, 10));
      expect(lines[1].positionalArguments[1], const Offset(50, 10));
    });

    test('normalises with a non-zero min', () {
      final RecordingCanvas canvas = paint(
        ProgressLinearPainter(
          gaugeValue: const GxGaugeValue(value: 75, min: 50, max: 150),
          style: const GxLinearProgressStyle(),
        ),
      );
      expect(
        canvas.callsTo('drawLine').last.positionalArguments[1],
        const Offset(50, 10),
      );
    });

    test('fills from the right when reversed', () {
      final RecordingCanvas canvas = paint(
        ProgressLinearPainter(
          gaugeValue: const GxGaugeValue(value: 25),
          style: const GxLinearProgressStyle(),
          reverse: true,
        ),
      );
      final Invocation progress = canvas.callsTo('drawLine').last;
      expect(progress.positionalArguments[0], const Offset(200, 10));
      expect(progress.positionalArguments[1], const Offset(150, 10));
    });
  });

  group('ProgressLinearPainter (not dense)', () {
    test('draws a full-size track and a proportional value rect', () {
      final RecordingCanvas canvas = paint(
        ProgressLinearPainter(
          gaugeValue: const GxGaugeValue(value: 40),
          style: const GxLinearProgressStyle(dense: false, radius: Radius.zero),
        ),
      );
      final List<Invocation> rrects = canvas.callsTo('drawRRect').toList();
      expect(rrects, hasLength(2));
      expect(
        (rrects[0].positionalArguments[0] as RRect).outerRect,
        Offset.zero & size,
      );
      expect(
        (rrects[1].positionalArguments[0] as RRect).outerRect,
        const Rect.fromLTWH(0, 0, 80, 20),
      );
    });
  });

  group('ProgressLinearPainter.shouldRepaint', () {
    ProgressLinearPainter painter({double value = 10, bool reverse = false}) =>
        ProgressLinearPainter(
          gaugeValue: GxGaugeValue(value: value),
          style: const GxLinearProgressStyle(),
          reverse: reverse,
        );

    test('is false for an identical configuration', () {
      expect(painter().shouldRepaint(painter()), isFalse);
    });

    test('is true when value or reverse change', () {
      expect(painter(value: 11).shouldRepaint(painter()), isTrue);
      expect(painter(reverse: true).shouldRepaint(painter()), isTrue);
    });
  });
}
