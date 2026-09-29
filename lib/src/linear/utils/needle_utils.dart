import 'package:flutter/painting.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/core/text_utils.dart';
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
  ///
  /// When the needle has a label, it is drawn beyond the needle with
  /// `{value}` replaced by [valueText], in [labelStyle] merged with the
  /// label's own style. [upright] keeps the text readable on a vertical
  /// gauge.
  static void drawIt({
    required Canvas canvas,
    required Size size,
    required double x,
    required GxLinearNeedle needle,
    required double thickness,
    required Color color,
    bool dense = false,
    GxNeedlePainter? needlePainter,
    String valueText = '',
    TextStyle labelStyle = const TextStyle(),
    TextDirection textDirection = TextDirection.ltr,
    bool upright = false,
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
          y = size.height + height / 2;
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

    final GxNeedleLabel? label = needle.label;
    if (label == null) {
      return;
    }
    final double halfExtent = switch (needle.shape) {
      GxNeedleShape.circle ||
      GxNeedleShape.triangle ||
      GxNeedleShape.diamond => width / 2,
      _ => height / 2,
    };
    final bool below = needle.position == GxNeedlePosition.bottom;
    const double gap = 2;
    paintText(
      canvas,
      text: label.label.replaceAll('{value}', valueText),
      style: labelStyle.merge(label.textStyle),
      textDirection: textDirection,
      upright: upright,
      position: (Size text) => Offset(
        x - text.width / 2,
        below
            ? y + halfExtent + gap + label.offset
            : y - halfExtent - gap - label.offset - text.height,
      ),
    );
  }
}
