import 'package:flutter/painting.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/linear/models/linear_needle.dart';

/// Draws a [GxLinearNeedle] on a horizontal track.
abstract final class NeedleUtils {
  /// Draws [needle] at horizontal position [x] within a gauge of [size].
  ///
  /// The vertical position follows `needle.position`. In [dense] mode, a
  /// needle above or below the track is offset by the track [thickness]
  /// instead of by its own height. [color] is the resolved needle color.
  /// For [GxNeedleShape.custom], [needlePainter] receives the anchor and the
  /// needle with its color resolved.
  static void drawIt({
    required Canvas canvas,
    required Size size,
    required double x,
    required GxLinearNeedle needle,
    required double thickness,
    required Color color,
    bool dense = false,
    GxNeedlePainter? needlePainter,
  }) {
    final double width = needle.size.width;
    final double height = needle.size.height;

    double y = size.height / 2;
    switch (needle.position) {
      case GxNeedlePosition.top:
        y = -(dense ? thickness : height / 2);
      case GxNeedlePosition.bottom:
        if (dense) {
          y = size.height >= thickness
              ? size.height + height / 2
              : size.height + thickness / 2;
        } else {
          y = size.height;
        }
      case GxNeedlePosition.center:
        break;
    }

    final Paint paint = Paint()
      ..color = color
      ..style = needle.paintingStyle
      ..strokeWidth = needle.strokeWidth
      ..strokeCap = needle.strokeCap;

    switch (needle.shape) {
      case GxNeedleShape.circle:
        canvas.drawCircle(Offset(x, y), width / 2, paint);
      case GxNeedleShape.triangle:
        canvas.drawPath(
          Path()
            ..moveTo(x, y - width / 2)
            ..lineTo(x - width / 2, y + width / 2)
            ..lineTo(x + width / 2, y + width / 2)
            ..close(),
          paint,
        );
      case GxNeedleShape.diamond:
        canvas.drawPath(
          Path()
            ..moveTo(x, y - width / 2)
            ..lineTo(x - width / 2, y)
            ..lineTo(x, y + width / 2)
            ..lineTo(x + width / 2, y)
            ..close(),
          paint,
        );
      case GxNeedleShape.rectangle:
      case GxNeedleShape.pipe:
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: width, height: height),
          paint,
        );
      case GxNeedleShape.custom:
        needlePainter?.call(
          canvas,
          Offset(x, y),
          needle.color == null ? needle.copyWith(color: color) : needle,
        );
    }
  }
}
