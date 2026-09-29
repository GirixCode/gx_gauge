import 'package:flutter/material.dart';
import 'package:girix_code_gauge/src/common/models/models.dart';
import 'package:girix_code_gauge/src/linear/models/linear_gauge_style.dart';
import 'package:girix_code_gauge/src/linear/models/stepper_linear_gauge_model.dart';
import 'package:girix_code_gauge/src/linear/utils/color_utils.dart';

class StepperLinearPainter extends CustomPainter {
  StepperLinearPainter({
    required this.gaugeValue,
    required this.stepperPointers,
    required this.style,
    required this.shape,
    required this.shapeSize,
    required this.activeStyle,
    this.offset = 10,
    required this.inActiveStyle,
    this.onPointerTap,
  });
  final GaugeValue gaugeValue;
  final List<StepperPointer> stepperPointers;
  final ProgressLinearStyle style;
  final StepperShape shape;
  final double shapeSize;
  final TextStyle activeStyle;
  final TextStyle inActiveStyle;
  final double offset;
  final Function? onPointerTap;
  late Size? size;
  bool checkListEquality(
      List<StepperPointer> list1, List<StepperPointer> list2) {
    if (list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].value != list2[i].value) {
        return false;
      }
    }
    return true;
  }

  @override
  bool hitTest(Offset position) {
    // Find out the nearest value based on the position
    // if (size != null) {
    //   final double rem = position.dx / size!.width;

    // }

    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    _drawAxis(canvas, size);
  }

  @override
  bool shouldRepaint(covariant StepperLinearPainter oldDelegate) {
    final bool isRepent = gaugeValue != oldDelegate.gaugeValue ||
        !checkListEquality(stepperPointers, oldDelegate.stepperPointers) ||
        style != oldDelegate.style ||
        shape != oldDelegate.shape ||
        shapeSize != oldDelegate.shapeSize ||
        activeStyle != oldDelegate.activeStyle;
    return isRepent;
  }

  void _drawAxis(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = style.backgroundColor ?? style.color.withOpacity(0.2)
      ..strokeWidth = style.thickness
      ..style = style.paintingStyle
      ..strokeCap = style.strokeCap;

    final double axisHeight = size.height;
    final double axisWidth = size.width;
    final double minValue = gaugeValue.min;
    final double maxValue = gaugeValue.max;
    final double value = gaugeValue.value;

    /// Actual progress of the stepper
    final double actualProgress =
        ((value - minValue) / (maxValue - minValue)) * axisWidth;

    /// Progress of the stepper without the shape size
    final double progress = actualProgress;

    final int actualInterval = stepperPointers.length;

    // Draw axis Line
    final Offset axisStart = Offset(
        shapeSize / 2, axisHeight / 2); // Start the axis from the shape size
    final Offset axisEnd = Offset(axisWidth - (shapeSize / 2),
        axisHeight / 2); // Remove the shape size from the axis width
    canvas.drawLine(axisStart, axisEnd, paint);

    // Progress Line
    final Paint progressPaint = Paint()
      ..color = style.color
      ..strokeWidth = style.thickness
      ..style = style.paintingStyle
      ..strokeCap = style.strokeCap;
    final Offset progressStart = Offset(shapeSize / 2, axisHeight / 2);
    final Offset progressEnd =
        Offset(progress - (shapeSize / 2), axisHeight / 2);

// Draw the progress line
    canvas.drawLine(progressStart, progressEnd, progressPaint);

    // Draw the Stepper Pointer
    final double stepWidth = axisWidth / (actualInterval - 1);

    for (int i = 0; i <= actualInterval - 1; i++) {
      final double x = i * stepWidth;
      final double y = axisHeight / 2;
      final Offset startPoint = Offset(x, y);
      final Offset endPoint = Offset(x, y + offset);

      // Check if the stepper pointer is in the progress line
      final bool isPointerInLine = x <= progress;

      final Paint stepperPaint = Paint()
        ..color = isPointerInLine
            ? style.color
            : style.backgroundColor ??
                ColorUtils.getMaterialColor(style.color).shade100
        ..strokeWidth = style.thickness
        ..style = style.paintingStyle;

      final StepperPointer pointer = stepperPointers[i];
      if (shape == StepperShape.circle) {
        canvas.drawCircle(startPoint, shapeSize / 2, stepperPaint);
      } else if (shape == StepperShape.rectangle) {
        canvas.drawRect(
            Rect.fromCenter(
                center: startPoint, width: shapeSize, height: shapeSize),
            stepperPaint);
      } else if (shape == StepperShape.diamond) {
        final Path diamondPath = Path()
          ..moveTo(x, y - shapeSize / 2)
          ..lineTo(x - shapeSize / 2, y)
          ..lineTo(x, y + shapeSize / 2)
          ..lineTo(x + shapeSize / 2, y)
          ..close();
        canvas.drawPath(diamondPath, stepperPaint);
      } else {
        canvas.drawLine(startPoint, endPoint, stepperPaint);
      }

      // Draw the pointer Index
      final TextPainter textIndexPainter = TextPainter(
          text: TextSpan(
              text: (pointer.value?.toInt() ?? i + 1).toString(),
              style: isPointerInLine ? activeStyle : inActiveStyle),
          textDirection: TextDirection.ltr)
        ..layout(maxWidth: stepWidth);
      textIndexPainter.paint(
          canvas, Offset(x - textIndexPainter.width / 2, y / 1.5));

      // Draw the Stepper Pointer Label
      final TextPainter textPainter = TextPainter(
          text: TextSpan(text: pointer.label.label, style: pointer.label.style),
          textDirection: TextDirection.ltr)
        ..layout(maxWidth: stepWidth);
      textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2,
              y + offset + 5)); // 10 is the height of the stepper pointer

      // On Pointer Tap
      if (onPointerTap != null) {}
    }
  }
}
