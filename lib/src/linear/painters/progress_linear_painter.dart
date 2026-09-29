// lib/src/linear/painters/linear_gauge_painter.dart

import 'package:flutter/material.dart';
import 'package:girix_code_gauge/src/common/models/linear_gauge_common_model.dart';
import 'package:girix_code_gauge/src/linear/models/linear_gauge_style.dart';
import 'package:girix_code_gauge/src/linear/models/linear_needle_model.dart';
import 'package:girix_code_gauge/src/linear/utils/needle_utils.dart';

/// [ProgressLinearPainter] is a custom painter class that is used to paint the GxProgressLinearGauge widget.
///
/// It extends the [CustomPainter] class from Flutter.
///
/// The [ProgressLinearPainter] class contains the following properties:
///
/// - [value]: An instance of the [GaugeValue] class that holds the value of the gauge.
///
/// - [style]: An instance of the [ProgressLinearStyle] class that holds the style properties of the gauge.
///
class ProgressLinearPainter extends CustomPainter {
  ProgressLinearPainter({
    required this.gaugeValue,
    this.needle,
    this.customDrawNeedle,
    this.reverse = false,
    this.showLabel = false,
    this.height,
    required this.style,
    this.label,
  });
  final GaugeValue gaugeValue;
  final ProgressLinearStyle style;
  final GaugeLabel? label;
  final LinearNeedle? needle;
  final void Function(Canvas canvas, Offset position)? customDrawNeedle;
  final bool reverse;
  final bool showLabel;
  final double? height;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the gauge
    _drawGauge(canvas, size);
    _drawNeedle(canvas, size);

    // Draw Label
    _drawLabel(canvas, size);
  }

  @override
  bool shouldRepaint(covariant ProgressLinearPainter oldDelegate) {
    final bool shouldRepaint = oldDelegate.gaugeValue != gaugeValue ||
        oldDelegate.style != style ||
        oldDelegate.needle != needle ||
        oldDelegate.reverse != reverse ||
        oldDelegate.showLabel != showLabel ||
        oldDelegate.height != height;

    return shouldRepaint;
  }

  // Draw the gauge
  void _drawGauge(Canvas canvas, Size size) {
    // Style Properties: Background
    final double thicknessBg = style.thickness;
    final Color backgroundColor =
        style.backgroundColor ?? style.color.withOpacity(0.2);
    final double barWidth = size.width;
    final double barHeight = size.height;

    // Style Properties: Foreground

    final Color color = style.color;

    // Value Properties
    final double minValue = gaugeValue.min;
    final double maxValue = gaugeValue.max;
    final double value = gaugeValue.value;

    // Calculate progress ratio
    final double progress =
        ((value - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);

    final double progressWidth = size.width * progress;

    // Paint Background
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = style.paintingStyle
      ..strokeWidth = thicknessBg
      ..strokeCap = style.strokeCap;

    // Paint Foreground
    final Paint foregroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = style.thickness
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = style.strokeCap;

    if (style.dense) {
      // Draw the background line (full width)
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        backgroundPaint,
      );
      // Draw Foreground
      // Draw the progress line
      // P2 x: (size.width * progress) this value can be used directly
      // P1 x: (size.width * progress) - (foregroundStyle.thickness / 2) due to the thickness provided

      if (reverse) {
        canvas.drawLine(
          Offset(size.width, size.height / 2),
          Offset(size.width - progressWidth, size.height / 2),
          foregroundPaint,
        );
      } else {
        canvas.drawLine(
          Offset(0, size.height / 2),
          Offset(progressWidth, size.height / 2),
          foregroundPaint,
        );
      }
    } else {
      final Rect rect = Rect.fromLTWH(0, 0, barWidth, barHeight);
      final RRect rrect =
          RRect.fromRectAndRadius(rect, style.radius ?? Radius.zero);
      canvas.drawRRect(rrect, backgroundPaint);

      final double frontWidth = progress * barWidth;
      late final Rect valueRect;
      if (reverse) {
        valueRect =
            Rect.fromLTWH(barWidth - frontWidth, 0, frontWidth, barHeight);
      } else {
        valueRect = Rect.fromLTWH(0, 0, frontWidth, barHeight);
      }

      final RRect valueRRect =
          RRect.fromRectAndRadius(valueRect, style.radius ?? Radius.zero);

      canvas.drawRRect(valueRRect, foregroundPaint);
    }
  }

  void _drawLabel(Canvas canvas, Size size) {
    final double val = gaugeValue.value;
    if (label != null && showLabel) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: label!.label.replaceAll('{value}', val.toString()),
          style: label?.style,
        ),
        textAlign: label?.textAlign ?? TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      final Offset offset = label!.offset ?? Offset.zero;

      double x;
      if (label?.textAlign == TextAlign.right) {
        x = size.width - textPainter.width + offset.dx - label!.spaceExtent;
      } else if (label?.textAlign == TextAlign.left) {
        x = offset.dx + label!.spaceExtent;
      } else {
        x = size.width / 2 - textPainter.width / 2 + offset.dx;
      }
      final double y = size.height / 2 - textPainter.height / 2 + offset.dy;

      // Paint the text on the canvas
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  void _drawNeedle(Canvas canvas, Size size) {
    if (needle != null && needle!.enabled) {
      // Draw the needle
      // NeedleUtils.drawNeedle(
      //     canvas: canvas,
      //     size: size,
      //     gaugeValue: gaugeValue,
      //     dense: style.dense,
      //     style: style,
      //     customDrawNeedle: customDrawNeedle,
      //     needle: needle!);

      // Draw the needle
      NeedleUtils.drawIt(
          dense: style.dense,
          canvas: canvas,
          size: size,
          minValue: gaugeValue.min,
          maxValue: gaugeValue.max,
          value: gaugeValue.value,
          needle: needle!,
          thickness: style.thickness,
          customDrawNeedle: customDrawNeedle);
    }
  }
}
