import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge/src/linear/utils/needle_utils.dart';

import '../helpers/recording_canvas.dart';

const Color _color = Color(0xFF123456);

RecordingCanvas _draw(GxLinearNeedle needle, {double x = 50}) {
  final RecordingCanvas canvas = RecordingCanvas();
  NeedleUtils.drawIt(
    canvas: canvas,
    size: const Size(200, 20),
    x: x,
    needle: needle,
    thickness: 4,
    color: _color,
  );
  return canvas;
}

void main() {
  group('NeedleUtils.drawIt', () {
    test('draws a circle at x, centered vertically, radius width / 2', () {
      final Invocation circle = _draw(
        const GxLinearNeedle(shape: GxNeedleShape.circle, size: Size(16, 16)),
        x: 120,
      ).callsTo('drawCircle').single;
      expect(circle.positionalArguments[0], const Offset(120, 10));
      expect(circle.positionalArguments[1], 8);
      expect(
        (circle.positionalArguments[2] as Paint).color.toARGB32(),
        _color.toARGB32(),
      );
    });

    test('a rectangle needle uses both width and height', () {
      final Rect rect =
          _draw(const GxLinearNeedle(size: Size(4, 30)))
                  .callsTo('drawRect')
                  .single
                  .positionalArguments[0]
              as Rect;
      expect(rect.width, 4);
      expect(rect.height, 30);
    });

    test('a top needle sits above the track', () {
      final Invocation circle = _draw(
        const GxLinearNeedle(
          shape: GxNeedleShape.circle,
          position: GxNeedlePosition.top,
        ),
      ).callsTo('drawCircle').single;
      expect((circle.positionalArguments[0] as Offset).dy, -5);
    });

    test('passes the anchor and the color-resolved needle to a painter', () {
      Offset? anchor;
      GxLinearNeedle? received;
      NeedleUtils.drawIt(
        canvas: RecordingCanvas(),
        size: const Size(200, 20),
        x: 150,
        needle: const GxLinearNeedle(shape: GxNeedleShape.custom),
        thickness: 4,
        color: _color,
        needlePainter: (Canvas canvas, Offset a, GxLinearNeedle n) {
          anchor = a;
          received = n;
        },
      );
      expect(anchor, const Offset(150, 10));
      expect(received?.color, _color);
    });
  });
}
