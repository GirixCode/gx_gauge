import 'package:flutter/material.dart';
import 'package:girix_code_gauge/src/common/models/linear_gauge_common_model.dart';
import 'package:girix_code_gauge/src/linear/models/linear_needle_model.dart';
import 'package:girix_code_gauge/src/linear/utils/needle_utils.dart';

class LinearBarUtils {
  // Draw the Linear bars

  static void drawBars({
    required Canvas canvas,
    required Size size,
    required List<LinearBarPointer> barPointers,
    required double value,
    required double gapBetweenBars,
    required double minValue,
    required double maxValue,
    double barOffset = 0,
  }) {
    final double height = size.height;
    final double width = size.width;

    double startValue = minValue;

    // Gap Value between bars wrt to the width
    final double gapValue = (gapBetweenBars / maxValue) * width;

    // Find out the no of gaps between bars
    final int noOfGaps = barPointers.length - 1;

    // Calculate the size after gap between bars
    // final double widthAfterGap = size.width - (gapValue * noOfGaps);

    for (int index = 0; index < barPointers.length; index++) {
      final LinearBarPointer barPointer = barPointers[index];
      final double barToDrawnValue = barPointer.value;

      final Paint paintAxis = Paint()
        ..color = barPointer.color
        ..strokeWidth = barPointer.thickness
        ..strokeCap = barPointer.strokeCap
        ..style = barPointer.paintingStyle;
      double barToDrawnWidth = (barToDrawnValue / maxValue) * width;

      //Allowing the bar to be drawn with a gap between them
      final bool isGap = gapBetweenBars > 0 && index <= noOfGaps;

      // Gap To Drawn Value. We need to divide the gapValue by 2 to get the gap value for each side
      final double gapToDrawn = gapValue / 2;
      if (isGap) {
        // Ignore start value for the first bar. It will be 0
        if (index > 0) {
          startValue += gapToDrawn;
        }

        final double tempBarToDrawn = barToDrawnWidth - gapToDrawn;

        // Adjust the size to bartoDrawnValue because of the [noOfGaps] and BarPointers.length
        barToDrawnWidth = tempBarToDrawn + (gapToDrawn / barPointers.length);
      }

      final Rect barRect = Rect.fromLTWH(
        startValue,
        barOffset,
        barToDrawnWidth,
        height,
      );

      final RRect rRect = RRect.fromRectAndRadius(
        barRect,
        barPointer.radius ?? Radius.zero,
      );

      canvas.drawRRect(rRect, paintAxis);
      startValue += barToDrawnWidth;

      // Text label and style

      if (barPointer.label != null) {
        final GaugeLabel label = barPointer.label!;
        final TextPainter textPainter = TextPainter(
          text: TextSpan(text: label.label, style: label.style),
          textDirection: TextDirection.rtl,
          textAlign: barPointer.label?.textAlign ?? TextAlign.center,
        )..layout();
        final double textWidth = textPainter.width;
        final double textHeight = textPainter.height;

        double textX = barRect.left + (barRect.width - textWidth) / 2;
        double textY = barRect.top + (barRect.height - textHeight) / 2;

        if (barPointer.label!.offset != null) {
          textX += barPointer.label!.offset!.dx;
          textY += barPointer.label!.offset!.dy;
        } else {
          switch (barPointer.label!.textAlign!) {
            case TextAlign.center:
            case TextAlign.justify:
              break;
            case TextAlign.left:
              textX = barRect.left;
              break;
            case TextAlign.right:
              textX = barRect.right - textWidth;
              break;

            case TextAlign.start:
              textY = 5;
              break;
            case TextAlign.end:
              textY = barRect.height - textHeight - 5;
              break;
          }
        }

        textPainter.paint(canvas, Offset(textX, textY));
      }
    }
  }

  // Draw Needle for the Linear Bars
  static void drawNeedle({
    required Canvas canvas,
    required Size size,
    required LinearNeedle needle,
    required double value,
    required double minValue,
    required double maxValue,
    required double gapBetweenBars,
    required List<LinearBarPointer> barPointers,
    required bool showNeedleInsideBar,
    void Function(Canvas canvas, Offset position)? customDrawNeedle,
  }) {
    double needleValue = value;

    // Gap Value
    if (gapBetweenBars > 0 && showNeedleInsideBar) {
      // Find out the no of gaps between bars
      final int noOfGaps = barPointers.length - 1;
      // Check whether the needleValue is inside the gap range
      if (noOfGaps > 0) {
        for (int index = 0; index < noOfGaps; index++) {
          final double startValue = barPointers[index].value;
          final double endValue = startValue + gapBetweenBars;

          if (needleValue == startValue) {
            needleValue = startValue - gapBetweenBars / 2;
            break;
          } else if (needleValue > startValue && needleValue < endValue) {
            needleValue = needleValue;
            break;
          } else if (needleValue > startValue && needleValue < endValue) {
            needleValue += gapBetweenBars;

            break;
          }
        }
      }
    }

    // Draw the needle
    NeedleUtils.drawIt(
      canvas: canvas,
      size: size,
      maxValue: maxValue,
      minValue: minValue,
      thickness: needle.offset,
      value: needleValue,
      needle: needle,
      customDrawNeedle: customDrawNeedle,
    );
  }
}
