import 'dart:ui';

import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/common/models/linear_gauge_common_model.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/linear/models/linear_gauge_style.dart';
import 'package:gx_gauge/src/linear/models/linear_needle_model.dart';

class NeedleUtils {
  static void drawIt({
    required Canvas canvas,
    required Size size,
    required double minValue,
    required double maxValue,
    required double value,
    bool dense = false,
    required GxLinearNeedle needle,
    required double thickness,
    GxNeedlePainter? needlePainter,
  }) {
    // Calculate the needle's x-position based on the needle position
    final double progress = ((value - minValue) / (maxValue - minValue)).clamp(
      0.0,
      1.0,
    );

    // To allign nnedle with center position 0: Start after progress
    // final double denseValue = dense ? -5 : needle.size.width / 2;
    const double denseValue = 0;
    final double needleX = (size.width * progress) - denseValue;
    double needleY = size.height / 2;

    final GxNeedlePosition needlePosition = needle.position;
    final Color needleColor = needle.color;
    final double needleWidthSize = needle.size.width;
    final double needleHeightSize = needle.size.height;
    final GxNeedleShape shape = needle.shape;

    //    |
    // -------- X+
    //    | Y+ needle

    switch (needlePosition) {
      case GxNeedlePosition.top:
        needleY = -(dense ? thickness : needleHeightSize / 2);
        break;
      case GxNeedlePosition.bottom:
        if (dense) {
          if (size.height >= thickness) {
            needleY = size.height + needleHeightSize / 2;
          } else {
            needleY = size.height + thickness / 2;
          }
        } else {
          needleY = size.height;
        }
        break;
      case GxNeedlePosition.center:
        // Use the calculated needleX based on the value
        // needleX = size.height / 2;
        break;
    }

    // Computed needle X
    // needleX = needleX - needleWidthSize / 4;

    final Paint needlePaint = Paint()
      ..color = needleColor
      ..style = needle.paintingStyle
      ..strokeWidth = needle.strokeWidth
      ..strokeCap = needle.strokeCap;

    switch (shape) {
      case GxNeedleShape.circle:
        canvas.drawCircle(
          Offset(needleX, needleY),
          needleWidthSize / 2,
          needlePaint,
        );
        break;
      case GxNeedleShape.triangle:
        final Path trianglePath = Path()
          ..moveTo(needleX, needleY - needleWidthSize / 2)
          ..lineTo(needleX - needleWidthSize / 2, needleY + needleWidthSize / 2)
          ..lineTo(needleX + needleWidthSize / 2, needleY + needleWidthSize / 2)
          ..close();
        canvas.drawPath(trianglePath, needlePaint);
        break;
      case GxNeedleShape.diamond:
        final Path diamondPath = Path()
          ..moveTo(needleX, needleY - needleWidthSize / 2)
          ..lineTo(needleX - needleWidthSize / 2, needleY)
          ..lineTo(needleX, needleY + needleWidthSize / 2)
          ..lineTo(needleX + needleWidthSize / 2, needleY)
          ..close();
        canvas.drawPath(diamondPath, needlePaint);
        break;
      case GxNeedleShape.rectangle:
        final Rect rect = Rect.fromCenter(
          center: Offset(needleX, needleY),
          width: needleWidthSize,
          height: needleWidthSize,
        );
        canvas.drawRect(rect, needlePaint);
        break;
      case GxNeedleShape.custom:
        if (needlePainter != null) {
          needlePainter(canvas, Offset(needleX, needleY), needle);
        }
        break;
      case GxNeedleShape.pipe:
        final Rect rect = Rect.fromCenter(
          center: Offset(needleX, needleY),
          width: needleWidthSize,
          height: needle.size.height,
        );
        canvas.drawRect(rect, needlePaint);
        break;
    }
  }

  static void drawNeedle({
    required Canvas canvas,
    required Size size,
    required GxGaugeValue gaugeValue,
    bool dense = false,
    required GxLinearProgressStyle style,
    required GxLinearNeedle needle,
    GxNeedlePainter? needlePainter,
  }) {
    return drawIt(
      canvas: canvas,
      size: size,
      minValue: gaugeValue.min,
      maxValue: gaugeValue.max,
      value: gaugeValue.value,
      dense: dense,
      needle: needle,
      thickness: style.thickness,
      needlePainter: needlePainter,
    );
  }
}
