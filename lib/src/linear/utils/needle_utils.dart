import 'dart:ui';

import 'package:girix_code_gauge/girix_code_gauge.dart';

class NeedleUtils {
  static void drawIt({
    required Canvas canvas,
    required Size size,
    required double minValue,
    required double maxValue,
    required double value,
    bool dense = false,
    required LinearNeedle needle,
    required double thickness,
    void Function(Canvas canvas, Offset position)? customDrawNeedle,
  }) {
// Calculate the needle's x-position based on the needle position
    final double progress =
        ((value - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);

    // To allign nnedle with center position 0: Start after progress
    // final double denseValue = dense ? -5 : needle.size.width / 2;
    const double denseValue = 0;
    final double needleX = (size.width * progress) - denseValue;
    double needleY = size.height / 2;

    final LinearGaugeNeedlePosition needlePosition = needle.position;
    final Color needleColor = needle.color;
    final double needleWidthSize = needle.size.width;
    final double needleHeightSize = needle.size.height;
    final LinearGaugeNeedleType needleType = needle.needleType;

    //    |
    // -------- X+
    //    | Y+ needle

    switch (needlePosition) {
      case LinearGaugeNeedlePosition.top:
        needleY = -(dense ? thickness : needleHeightSize / 2);
        break;
      case LinearGaugeNeedlePosition.bottom:
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
      case LinearGaugeNeedlePosition.center:
        // Use the calculated needleX based on the value
        // needleX = size.height / 2;
        break;
    }

    // Computed needle X
    // needleX = needleX - needleWidthSize / 4;

    final Paint needlePaint = Paint()
      ..color = needleColor
      ..style = PaintingStyle.fill;

    switch (needleType) {
      case LinearGaugeNeedleType.circle:
        canvas.drawCircle(
            Offset(needleX, needleY), needleWidthSize / 2, needlePaint);
        break;
      case LinearGaugeNeedleType.triangle:
        final Path trianglePath = Path();
        trianglePath.moveTo(needleX, needleY - needleWidthSize / 2);
        trianglePath.lineTo(
            needleX - needleWidthSize / 2, needleY + needleWidthSize / 2);
        trianglePath.lineTo(
            needleX + needleWidthSize / 2, needleY + needleWidthSize / 2);
        trianglePath.close();
        canvas.drawPath(trianglePath, needlePaint);
        break;
      case LinearGaugeNeedleType.diamond:
        final Path diamondPath = Path();
        diamondPath.moveTo(needleX, needleY - needleWidthSize / 2);
        diamondPath.lineTo(needleX - needleWidthSize / 2, needleY);
        diamondPath.lineTo(needleX, needleY + needleWidthSize / 2);
        diamondPath.lineTo(needleX + needleWidthSize / 2, needleY);
        diamondPath.close();
        canvas.drawPath(diamondPath, needlePaint);
        break;
      case LinearGaugeNeedleType.rectangle:
        final Rect rect = Rect.fromCenter(
          center: Offset(needleX, needleY),
          width: needleWidthSize,
          height: needleWidthSize,
        );
        canvas.drawRect(rect, needlePaint);
        break;
      case LinearGaugeNeedleType.custom:
        if (customDrawNeedle != null) {
          customDrawNeedle(canvas, Offset(needleX, needleY));
        }
        break;
      case LinearGaugeNeedleType.pipe:
        final Rect rect = Rect.fromCenter(
          center: Offset(needleX, needleY),
          width: needleWidthSize,
          height: needle.size.height,
        );
        canvas.drawRect(rect, needlePaint);
        break;
    }
  }

  static void drawNeedle(
      {required Canvas canvas,
      required Size size,
      required GaugeValue gaugeValue,
      bool dense = false,
      required ProgressLinearStyle style,
      required LinearNeedle needle,
      void Function(Canvas canvas, Offset position)? customDrawNeedle}) {
    return drawIt(
      canvas: canvas,
      size: size,
      minValue: gaugeValue.min,
      maxValue: gaugeValue.max,
      value: gaugeValue.value,
      dense: dense,
      needle: needle,
      thickness: style.thickness,
      customDrawNeedle: customDrawNeedle,
    );
  }
}
