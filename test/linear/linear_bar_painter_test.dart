import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge/src/linear/painters/linear_bar_painter.dart';

import '../helpers/configs.dart';
import '../helpers/recording_canvas.dart';

const List<GxLinearBarPointer> _bars = <GxLinearBarPointer>[
  GxLinearBarPointer(start: 0, end: 50),
  GxLinearBarPointer(start: 50, end: 100),
];

RecordingCanvas _paint(BarPainterConfig config, {double value = 75}) {
  final RecordingCanvas canvas = RecordingCanvas();
  LinearBarPainter(
    config: config,
    value: AlwaysStoppedAnimation<double>(value),
  ).paint(canvas, const Size(200, 20));
  return canvas;
}

List<Rect> _barRects(RecordingCanvas canvas) => canvas
    .callsTo('drawRRect')
    .map((Invocation i) => (i.positionalArguments[0] as RRect).outerRect)
    .toList();

void main() {
  group('LinearBarPainter', () {
    test('draws each bar over its start..end range', () {
      expect(_barRects(_paint(barConfig(bars: _bars))), <Rect>[
        const Rect.fromLTRB(0, 0, 100, 20),
        const Rect.fromLTRB(100, 0, 200, 20),
      ]);
    });

    test('leaves a pixel gap between adjacent bars only', () {
      expect(_barRects(_paint(barConfig(bars: _bars, gap: 10))), <Rect>[
        const Rect.fromLTRB(0, 0, 95, 20),
        const Rect.fromLTRB(105, 0, 200, 20),
      ]);
    });

    test('mirrors the bars when reversed', () {
      expect(
        _barRects(_paint(barConfig(bars: _bars, reversed: true))).first,
        const Rect.fromLTRB(100, 0, 200, 20),
      );
    });

    test('puts the needle at the value, independent of gaps', () {
      final Offset center =
          _paint(
                barConfig(
                  bars: _bars,
                  gap: 10,
                  linearNeedle: const GxLinearNeedle(
                    shape: GxNeedleShape.circle,
                  ),
                ),
              ).callsTo('drawCircle').single.positionalArguments[0]
              as Offset;
      expect(center.dx, 150);
    });

    test('draws the tooltip bubble and its text', () {
      final RecordingCanvas canvas = _paint(
        barConfig(bars: _bars, tooltip: const GxGaugeTooltip()),
      );
      expect(_barRects(canvas), hasLength(3));
      expect(canvas.callsTo('drawParagraph'), hasLength(1));
    });

    test('shouldRepaint notices tooltip changes', () {
      const Animation<double> value = AlwaysStoppedAnimation<double>(10);
      expect(
        LinearBarPainter(
          config: barConfig(tooltip: const GxGaugeTooltip(label: 'a')),
          value: value,
        ).shouldRepaint(
          LinearBarPainter(
            config: barConfig(tooltip: const GxGaugeTooltip(label: 'b')),
            value: value,
          ),
        ),
        isTrue,
      );
    });
  });
}
