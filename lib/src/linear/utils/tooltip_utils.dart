import 'package:flutter/painting.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/common/models/gauge_tooltip.dart';
import 'package:gx_gauge/src/core/text_utils.dart';

/// Draws a [GxGaugeTooltip] for a linear gauge.
abstract final class TooltipUtils {
  /// Draws [tooltip] showing [text] at horizontal position [x].
  ///
  /// The bubble is kept inside the gauge's width. [color] and [textColor]
  /// are the resolved bubble and default text colors.
  static void drawTooltip({
    required Canvas canvas,
    required Size size,
    required double x,
    required GxGaugeTooltip tooltip,
    required String text,
    required Color color,
    required Color textColor,
    required TextDirection textDirection,
    bool upright = false,
  }) {
    final Color strokeColor = tooltip.borderColor ?? color;
    final Paint paint = Paint()
      ..color = tooltip.paintingStyle == PaintingStyle.stroke
          ? strokeColor
          : color
      ..strokeWidth = tooltip.thickness
      ..strokeCap = tooltip.strokeCap
      ..style = tooltip.paintingStyle;

    // On a vertical gauge the canvas is rotated, so swap the bubble's sides
    // to keep it `tooltip.size` on screen.
    final double width = upright ? tooltip.size.height : tooltip.size.width;
    final double height = upright ? tooltip.size.width : tooltip.size.height;

    double centerY = size.height / 2;
    Offset pointerStart = Offset(x, 0);
    Offset pointerEnd = Offset(x, 0);
    switch (tooltip.position) {
      case GxTooltipPosition.top:
        centerY = -size.height / 2 - tooltip.offset;
        pointerEnd = Offset(x, centerY + height / 2);
      case GxTooltipPosition.bottom:
        centerY = size.height + size.height / 2 + tooltip.offset;
        pointerStart = Offset(x, size.height);
        pointerEnd = Offset(x, centerY - height / 2);
    }

    // Keep the bubble within the gauge's width.
    final double maxLeft = size.width - width;
    final double left = maxLeft <= 0
        ? (size.width - width) / 2
        : (x - width / 2).clamp(0.0, maxLeft);
    final Rect bubble = Rect.fromLTWH(
      left,
      centerY - height / 2,
      width,
      height,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(bubble, tooltip.radius ?? Radius.zero),
      paint,
    );
    if (tooltip.type == GxTooltipType.normal && tooltip.showPointer) {
      canvas.drawLine(
        pointerStart,
        pointerEnd,
        Paint()
          ..color = strokeColor
          ..strokeCap = tooltip.strokeCap
          ..strokeWidth = tooltip.thickness,
      );
    }

    paintText(
      canvas,
      text: text,
      style: TextStyle(
        color: tooltip.paintingStyle == PaintingStyle.fill
            ? textColor
            : strokeColor,
      ).merge(tooltip.textStyle),
      textDirection: textDirection,
      maxWidth: tooltip.size.width,
      upright: upright,
      position: (Size textSize) =>
          bubble.center - Offset(textSize.width / 2, textSize.height / 2),
    );
  }
}
