import 'dart:math' as math;

import 'package:flutter/painting.dart';

/// Lays out [text], asks [position] where to put it given its footprint,
/// paints it, and disposes the [TextPainter].
///
/// When [upright] is true the canvas has been rotated a quarter turn
/// counter-clockwise (a vertical linear gauge). The text is then rotated back
/// so it reads normally on screen, and [position] receives the text's
/// footprint in the rotated space (width and height swapped).
///
/// Returns the footprint that was passed to [position].
Size paintText(
  Canvas canvas, {
  required String text,
  required TextStyle style,
  required TextDirection textDirection,
  required Offset Function(Size footprint) position,
  TextAlign textAlign = TextAlign.center,
  double maxWidth = double.infinity,
  bool upright = false,
}) {
  final TextPainter painter =
      TextPainter(
        text: TextSpan(text: text, style: style),
        textAlign: textAlign,
        textDirection: textDirection,
      )..layout(
        maxWidth: maxWidth.isFinite && maxWidth > 0
            ? maxWidth
            : double.infinity,
      );
  final Size size = painter.size;
  if (!upright) {
    painter
      ..paint(canvas, position(size))
      ..dispose();
    return size;
  }
  final Size footprint = size.flipped;
  final Offset topLeft = position(footprint);
  final Offset center =
      topLeft + Offset(footprint.width / 2, footprint.height / 2);
  canvas
    ..save()
    ..translate(center.dx, center.dy)
    ..rotate(math.pi / 2);
  painter.paint(canvas, Offset(-size.width / 2, -size.height / 2));
  canvas.restore();
  painter.dispose();
  return footprint;
}
