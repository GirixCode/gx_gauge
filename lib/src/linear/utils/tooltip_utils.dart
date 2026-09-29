import 'package:flutter/material.dart';
import 'package:girix_code_gauge/src/common/models/models.dart';

class TooltipUtils {
  static void drawTooltip(
      {required Canvas canvas,
      required Size size,
      required GaugeTooltip tooltip,
      required double minValue,
      required double maxValue,
      required double value}) {
    final double progress =
        ((value - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);

    final Color strokeColor = tooltip.borderColor ?? tooltip.color;

    final Paint paint = Paint()
      ..color = tooltip.paintingStyle == PaintingStyle.stroke
          ? strokeColor
          : tooltip.color
      ..strokeWidth = tooltip.thickness
      ..strokeCap = tooltip.strokeCap
      ..style = tooltip.paintingStyle;

    // Tooltip Size
    final double tooltipWidth = tooltip.size.width;
    final double tooltipHeight = tooltip.size.height;

    // Tooltip Position in ---X----
    double tooltipX = size.width * progress;
    //                     |
    // Tooltip Position in Y
    //                     |
    double tooltipY = size.height / 2;

    Offset tooltipBarStart = Offset(tooltipX, 0);
    Offset tooltipBarEnd = Offset(tooltipX, 0);

    if (tooltip.position == GaugeTooltipPosition.top) {
      tooltipY = -size.height / 2 - tooltip.offset;
      tooltipBarEnd = Offset(tooltipX, tooltipY + tooltipHeight / 2);
    } else if (tooltip.position == GaugeTooltipPosition.bottom) {
      tooltipY = size.height + size.height / 2 + tooltip.offset;
      tooltipBarStart = Offset(tooltipX, size.height);
      tooltipBarEnd = Offset(tooltipX, tooltipY - tooltipHeight / 2);
    }

    Rect tooltipRect = Rect.fromLTWH(
      tooltipX - tooltipWidth / 2,
      tooltipY - tooltipHeight / 2,
      tooltipWidth,
      tooltipHeight,
    );

    // check Overflow
    final bool isOverflowRight = tooltipRect.right > size.width;
    final bool isOverflowLeft = tooltipRect.left < 0;
    if (isOverflowRight) {
      tooltipRect = Rect.fromLTWH(
        size.width - tooltipWidth,
        tooltipY - tooltipHeight / 2,
        tooltipWidth,
        tooltipHeight,
      );
    } else if (isOverflowLeft) {
      tooltipRect = Rect.fromLTWH(
        0,
        tooltipY - tooltipHeight / 2,
        tooltipWidth,
        tooltipHeight,
      );
    }

    final RRect rRect = RRect.fromRectAndRadius(
      tooltipRect,
      tooltip.radius ?? Radius.zero,
    );

    canvas.drawRRect(rRect, paint);
    if (tooltip.type == GaugeTooltipType.normal && tooltip.showPointer) {
      canvas.drawLine(
          tooltipBarStart,
          tooltipBarEnd,
          Paint()
            ..color = strokeColor
            ..strokeCap = tooltip.strokeCap
            ..strokeWidth = tooltip.thickness);
    }

    // Tooltip text painter
    // Based on the Tooltip Size, we can adjust the Text Size
    final double? textSize = tooltip.textStyle.fontSize;
    final Color textColor = tooltip.textStyle.color ?? strokeColor;
    late final String tooltipText;
    if (tooltip.label == null) {
      tooltipText = value.toString();
    } else {
      if (tooltip.label!.contains('{value}')) {
        tooltipText = tooltip.label!.replaceAll('{value}', value.toString());
      } else {
        tooltipText = tooltip.label.toString();
      }
    }

    final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: tooltipText,
          style: tooltip.textStyle.copyWith(
            fontSize: textSize,
            color: textColor,
          ),
        ),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center);

    textPainter.layout();
    final double textWidth = textPainter.width;
    final double textHeight = textPainter.height;

    if (isOverflowRight) {
      tooltipX = size.width - tooltipWidth / 2;
    } else if (isOverflowLeft) {
      tooltipX = tooltipWidth / 2;
    }

    final double textX = tooltipX - textWidth / 2;
    final double textY = tooltipY - textHeight / 2;

    textPainter.paint(canvas, Offset(textX, textY));
  }
}
