import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge/src/linear/utils/needle_utils.dart';

import '../helpers/recording_canvas.dart';

/// Draws a circle needle and returns the circle's center.
Offset _needleCenter({
  required double min,
  required double max,
  required double value,
  Size size = const Size(200, 20),
  GxNeedlePosition position = GxNeedlePosition.center,
}) {
  final RecordingCanvas canvas = RecordingCanvas();
  NeedleUtils.drawIt(
    canvas: canvas,
    size: size,
    minValue: min,
    maxValue: max,
    value: value,
    needle: GxLinearNeedle(shape: GxNeedleShape.circle, position: position),
    thickness: 4,
  );
  final Invocation circle = canvas.callsTo('drawCircle').single;
  return circle.positionalArguments[0] as Offset;
}

void main() {
  group('NeedleUtils.drawIt', () {
    test('maps value to x using (value - min) / (max - min)', () {
      expect(_needleCenter(min: 0, max: 100, value: 25).dx, 50);
      expect(_needleCenter(min: 50, max: 150, value: 100).dx, 100);
      expect(_needleCenter(min: -50, max: 50, value: 0).dx, 100);
    });

    test('clamps values outside the range to the track ends', () {
      expect(_needleCenter(min: 0, max: 100, value: 150).dx, 200);
      expect(_needleCenter(min: 0, max: 100, value: -10).dx, 0);
    });

    test('centers the needle vertically by default', () {
      expect(_needleCenter(min: 0, max: 100, value: 50).dy, 10);
    });

    test('uses half the needle width as the circle radius', () {
      final RecordingCanvas canvas = RecordingCanvas();
      NeedleUtils.drawIt(
        canvas: canvas,
        size: const Size(100, 10),
        minValue: 0,
        maxValue: 100,
        value: 50,
        needle: const GxLinearNeedle(
          shape: GxNeedleShape.circle,
          size: Size(16, 16),
        ),
        thickness: 4,
      );
      expect(canvas.callsTo('drawCircle').single.positionalArguments[1], 8);
    });

    test('passes the anchor and the needle to a custom painter', () {
      const GxLinearNeedle needle = GxLinearNeedle(
        shape: GxNeedleShape.custom,
        color: Color(0xFFFF9800),
      );
      Offset? receivedAnchor;
      GxLinearNeedle? receivedNeedle;
      NeedleUtils.drawIt(
        canvas: RecordingCanvas(),
        size: const Size(200, 20),
        minValue: 0,
        maxValue: 100,
        value: 75,
        needle: needle,
        thickness: 4,
        needlePainter: (Canvas canvas, Offset anchor, GxLinearNeedle n) {
          receivedAnchor = anchor;
          receivedNeedle = n;
        },
      );
      expect(receivedAnchor, const Offset(150, 10));
      expect(receivedNeedle, same(needle));
    });
  });
}
