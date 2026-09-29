import 'package:flutter/painting.dart';

/// Lays out [text], asks [position] where to put it given its laid-out size,
/// paints it, and disposes the [TextPainter].
///
/// Returns the painted size. Disposing right after painting releases the
/// native paragraph immediately instead of waiting for garbage collection.
Size paintText(
  Canvas canvas, {
  required String text,
  required TextStyle style,
  required TextDirection textDirection,
  required Offset Function(Size size) position,
  TextAlign textAlign = TextAlign.center,
  double maxWidth = double.infinity,
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
  painter
    ..paint(canvas, position(size))
    ..dispose();
  return size;
}
