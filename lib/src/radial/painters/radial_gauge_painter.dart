// lib/src/radial/painters/radial_gauge_painter.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/models.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/radial/models/radial_gauge_style.dart';
import 'package:gx_gauge/src/radial/utils/angle_utils.dart';

/// The [RadialGaugePainter] is used to paint the radial gauge.
///
/// The [RadialGaugePainter] class extends the [CustomPainter] class from Flutter.
///
/// The [RadialGaugePainter] class contains the following properties:
///
/// - [value]: An instance of the [GxGaugeValue] class that holds the value of the gauge.
///
/// - [style]: An instance of the [GxRadialGaugeStyle] class that holds the style properties of the gauge.
///
class RadialGaugePainter extends CustomPainter {
  RadialGaugePainter({
    required this.value,
    required this.style,
    required this.showMajorTicks,
    required this.showMinorTicks,
    required this.showLabels,
    required this.majorTickStyle,
    required this.minorTickStyle,
    required this.labelTickStyle,
    required this.interval,
    required this.minorTicksPerInterval,
    required this.startAngleInDegree,
    required this.sweepAngleInDegree,
    required this.showValueAtCenter,
    required this.showNeedle,
    required this.needleCircleInnerColor,
    this.needle,
    this.pointers,
    this.majorTickStyler,
    this.labelFormatter,
    this.labelStyler,
    this.ranges,
  });
  final GxGaugeValue value;
  final GxRadialGaugeStyle style;
  final GxRadialTickStyle majorTickStyle;
  final GxRadialTickStyle minorTickStyle;
  final GxRadialTickLabelStyle labelTickStyle;
  final int interval;
  final int minorTicksPerInterval;
  final double startAngleInDegree;
  final double sweepAngleInDegree;
  final bool showMajorTicks;
  final bool showMinorTicks;
  final bool showLabels;
  final bool showValueAtCenter;
  final bool showNeedle;
  final GxRadialNeedle? needle;
  final Color needleCircleInnerColor;
  // Marker Pointer
  final List<GxRadialPointer>? pointers;
  // Callbacks
  final GxValueLabelFormatter? labelFormatter;
  final GxValueTickStyler<GxRadialTickStyle>? majorTickStyler;
  final GxValueLabelStyler<GxRadialTickLabelStyle>? labelStyler;
  List<GxRadialRange>? ranges;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius =
        (math.min(size.width, size.height) / 2) - style.thickness / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final double startAngle = AngleUtils.degreesToRadians(startAngleInDegree);
    final double sweepAngle = AngleUtils.degreesToRadians(sweepAngleInDegree);

    // Painting logic for radial gauge
    _drawRadialGauge(canvas, size, radius, center, startAngle, sweepAngle);

    // Optionally, draw ticks and labels
    if (showMajorTicks || showLabels) {
      _drawTicksAndLabels(canvas, center, radius, startAngle, sweepAngle);
    }

    if (showValueAtCenter) {
      _drawValueAtCenter(canvas, center, size);
    }

    if (showNeedle && needle != null) {
      _drawNeedle(
        canvas: canvas,
        size: size,
        center: center,
        radius: radius,
        startAngle: startAngle,
        sweepAngle: sweepAngle,
        needleValue: value.value,
        needle: needle!,
      );
    }

    if (pointers != null && pointers!.isNotEmpty) {
      _drawPointers(
        canvas: canvas,
        size: size,
        center: center,
        radius: radius,
        startAngle: startAngle,
        sweepAngle: sweepAngle,
      );
    }

    if (ranges != null && ranges!.isNotEmpty) {
      _drawBarLabels(
        canvas: canvas,
        size: size,
        center: center,
        radius: radius,
        startAngle: startAngle,
        sweepAngle: sweepAngle,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RadialGaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.style != style;
  }

  // Draw Labels
  void _drawBarLabels({
    required Canvas canvas,
    required Size size,
    required Offset center,
    required double radius,
    required double startAngle,
    required double sweepAngle,
  }) {
    for (final GxRadialRange bar in ranges!) {
      final double startValue = bar.startValue;
      final double endValue = bar.endValue;
      final Color? color = bar.color;
      final double height = bar.height;
      final double offset = bar.offset; // Offset from the Radial Gauge Arc

      final double startBarAngle =
          startAngle + (startValue / value.max) * sweepAngle;
      final double endBarAngle =
          startAngle + (endValue / value.max) * sweepAngle;

      final double barRadius = radius + offset;

      // Draw the bar
      final Paint barPaint = Paint()
        ..color = color ?? style.color
        ..strokeWidth = height
        ..style = PaintingStyle.stroke;

      // Draw arc
      final Rect rect = Rect.fromCircle(center: center, radius: barRadius);
      canvas.drawArc(
        rect,
        startBarAngle,
        endBarAngle - startBarAngle,
        false,
        barPaint,
      );

      // Draw Label
      // final double labelAngle = (startBarAngle + endBarAngle) / 2;
      // final double labelRadius = barRadius + height / 2 + 10;

      // final double labelX = center.dx + labelRadius * math.cos(labelAngle);
      // final double labelY = center.dy + labelRadius * math.sin(labelAngle);

      // final TextPainter textPainter = TextPainter(
      //   text: TextSpan(
      //     text: labelText,
      //     style: bar.label.style,
      //   ),
      //   textAlign: TextAlign.end,
      //   textDirection: TextDirection.ltr,
      // );

      // textPainter.layout();

      // final Offset labelOffset = Offset(
      //   labelX - textPainter.width / 2,
      //   labelY - textPainter.height / 2,
      // );

      // // Rotate and align the label text with the bar
      // final double angle = AngleUtils.radiansToDegrees(labelAngle);
      // final Matrix4 matrix = Matrix4.identity()..translate(labelX, labelY);
      // // ..rotateZ(angle + math.pi / 180);

      // canvas.save();
      // canvas.transform(matrix.storage);

      // textPainter.paint(canvas, labelOffset);

      // canvas.restore();
    }
  }

  // Draw Minor Ticks
  void _drawMinorTicks({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double startAngle,
    required double sweepAngle,
    required double angle,
    required double tickLength,
    required double nextAngle,
  }) {
    final int totalMinorTicks = minorTicksPerInterval + 1; // +1 for major tick
    final double minorTickLength = minorTickStyle.length;

    for (int i = 1; i <= totalMinorTicks; i++) {
      final double minorAngle =
          angle + (i / totalMinorTicks) * (nextAngle - angle);
      // Ignore i==totalMinorTicks as it is already drawn as major tick
      if (i == totalMinorTicks) {
        continue;
      }
      double x1 = center.dx + (radius - minorTickLength) * math.cos(minorAngle);
      double y1 = center.dy + (radius - minorTickLength) * math.sin(minorAngle);
      double x2 = center.dx + (radius * math.cos(minorAngle));
      double y2 = center.dy + radius * math.sin(minorAngle);

      if (minorTickStyle.position == GxRadialElementPosition.outside) {
        x1 = center.dx + (radius + minorTickLength) * math.cos(minorAngle);
        y1 = center.dy + (radius + minorTickLength) * math.sin(minorAngle);
      } else {
        x1 = center.dx + (radius - minorTickLength) * math.cos(minorAngle);
        y1 = center.dy + (radius - minorTickLength) * math.sin(minorAngle);
      }

      // End point depends on the alignment

      if (minorTickStyle.alignment == GxRadialElementAlignment.center) {
        x2 = center.dx + (radius * math.cos(minorAngle));
        y2 = center.dy + radius * math.sin(minorAngle);
      } else if (minorTickStyle.alignment == GxRadialElementAlignment.end) {
        x1 = center.dx + (radius - style.thickness / 2) * math.cos(minorAngle);
        y1 = center.dy + (radius - style.thickness / 2) * math.sin(minorAngle);
        x2 = center.dx + (radius - minorTickLength) * math.cos(minorAngle);
        y2 = center.dy + (radius - minorTickLength) * math.sin(minorAngle);
      } else if (minorTickStyle.alignment == GxRadialElementAlignment.start) {
        x1 = center.dx + (radius + style.thickness / 2) * math.cos(minorAngle);
        y1 = center.dy + (radius + style.thickness / 2) * math.sin(minorAngle);
        x2 = center.dx + (radius + minorTickLength) * math.cos(minorAngle);
        y2 = center.dy + (radius + minorTickLength) * math.sin(minorAngle);
      }

      final Paint minorTickPaint = Paint()
        ..color = minorTickStyle.color
        ..strokeWidth = minorTickStyle.thickness
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), minorTickPaint);
    }
  }

  // Draw Needle for the Radial Gauge
  void _drawNeedle({
    required Canvas canvas,
    required Size size,
    required Offset center,
    required double radius,
    required double startAngle,
    required double sweepAngle,
    required double needleValue,
    required GxRadialNeedle needle,
  }) {
    /// Needle Value and Style

    final double needleAngle =
        startAngle + (needleValue / value.max) * sweepAngle;

    final double needleLength = needle.bottomOffset != null
        ? (-needle.bottomOffset!)
        : 1;

    // Offset the start point to avoid overlap with the circle stroke
    final GxNeedleCap needleCircle = needle.circle;
    final double needleThickness = needle.thickness;

    /// Needle Offsets
    const double startOffset = 0;
    final double topOffeset = needle.topOffest ?? 0;

    final Offset needleStart = Offset(
      center.dx + ((needleLength + startOffset - 1.5) * math.cos(needleAngle)),
      center.dy + ((needleLength + startOffset - 1.5) * math.sin(needleAngle)),
    );

    late double needleEndX;
    late double needleEndY;
    late double needleLeftX;
    late double needleLeftY;
    late double needleRightX;
    late double needleRightY;

    // Calculate the points for the needle path with constant width
    if (needle.alignment == GxRadialElementAlignment.start) {
      needleEndX =
          center.dx +
          (topOffeset + radius + style.thickness / 2) * math.cos(needleAngle);
      needleEndY =
          center.dy +
          (topOffeset + radius + style.thickness / 2) * math.sin(needleAngle);
    } else if (needle.alignment == GxRadialElementAlignment.end) {
      needleEndX =
          center.dx +
          (topOffeset + radius - style.thickness / 2) * math.cos(needleAngle);
      needleEndY =
          center.dy +
          (topOffeset + radius - style.thickness / 2) * math.sin(needleAngle);
    } else {
      needleEndX = center.dx + (radius * math.cos(needleAngle));
      needleEndY = center.dy + (radius * math.sin(needleAngle));
    }

    /// Needle Offset Path
    final Offset needleEnd = Offset(needleEndX, needleEndY);

    if (needle.shape == GxRadialNeedleShape.line) {
      final Paint needlePaint = Paint()
        ..color = needle.color
        ..strokeWidth = needleThickness
        ..style = PaintingStyle.stroke
        ..strokeCap = needle.strokeCap
        ..shader = needle.gradient?.createShader(
          Rect.fromLTWH(0, 0, size.width, needle.thickness),
        );

      canvas.drawLine(needleStart, needleEnd, needlePaint);
    } else if (needle.shape == GxRadialNeedleShape.taperedLine) {
      needleLeftX = center.dx - ((needleThickness / 2) * math.sin(needleAngle));
      needleLeftY = center.dy + ((needleThickness / 2) * math.cos(needleAngle));

      needleRightX =
          center.dx + ((needleThickness / 2) * math.sin(needleAngle));
      needleRightY =
          center.dy - ((needleThickness / 2) * math.cos(needleAngle));
      final Offset leftSide = Offset(needleLeftX, needleLeftY);
      final Offset rightSide = Offset(needleRightX, needleRightY);

      final Path needlePath = Path()
        ..moveTo(needleStart.dx, needleStart.dy)
        ..lineTo(leftSide.dx, leftSide.dy)
        ..lineTo(needleEnd.dx, needleEnd.dy)
        ..lineTo(rightSide.dx, rightSide.dy)
        ..close();

      final Paint needlePaint = Paint()
        ..color = needle.color
        ..strokeWidth = needleThickness
        ..style = PaintingStyle.fill
        ..shader = needle.gradient?.createShader(
          Rect.fromLTWH(0, 0, size.width, needle.thickness),
        );
      canvas.drawPath(needlePath, needlePaint);
    }

    final Paint needleCirclePaint = Paint()
      ..color = needleCircle.color ?? needle.color
      ..strokeWidth = needleCircle.strokeWidth
      ..style = needleCircle.paintingStyle;

    canvas.drawCircle(center, needleCircle.radius, needleCirclePaint);

    // Handle Circle Stroke Overalap Issue:
    // [Temporary Fix] by adding a small circle excluding the radius of the needle
    if (needleCircle.paintingStyle == PaintingStyle.stroke) {
      final Paint needleCircleStrokePaint = Paint()
        ..color = needleCircle.innerColor ?? needleCircleInnerColor
        ..strokeWidth = needleCircle.strokeWidth
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        center,
        needleCircle.radius - (needleCircle.strokeWidth / 2),
        needleCircleStrokePaint,
      );

      if (showValueAtCenter) {
        _drawValueAtCenter(canvas, center, size);
      }
    }
  }

  // Draw Pointers for the Radial Gauge
  void _drawPointers({
    required Canvas canvas,
    required Size size,
    required Offset center,
    required double radius,
    required double startAngle,
    required double sweepAngle,
  }) {
    for (final GxRadialPointer pointer in pointers!) {
      final double pointerValue = pointer.value;

      // Check Needle in Pointer
      if (pointer.needle != null && pointer.showNeedle) {
        _drawNeedle(
          canvas: canvas,
          size: size,
          center: center,
          radius: radius,
          startAngle: startAngle,
          sweepAngle: sweepAngle,
          needleValue: pointerValue,
          needle: pointer.needle!,
        );
      }

      if (!pointer.showPointer) {
        continue;
      }

      // Draw Pointers shape
      final double pointerAngle =
          startAngle + (pointerValue / value.max) * sweepAngle;
      final GxRadialPointerShape shape = pointer.shape;
      final Color pointerColor = pointer.style.color;
      final double pointerThickness = pointer.style.thickness;
      final PaintingStyle pointerPaintingStyle = pointer.style.paintingStyle;
      final double pointerSize = pointer.style.size;
      final GxRadialElementAlignment alignment = pointer.alignment;
      final double gaugeThickness = style.thickness;

      final Paint pointerPaint = Paint()
        ..color = pointerColor
        ..strokeWidth = pointerThickness
        ..style = pointerPaintingStyle;

      double offsetValue = 0;

      if (alignment == GxRadialElementAlignment.start) {
        offsetValue = gaugeThickness / 2;
      } else if (alignment == GxRadialElementAlignment.end) {
        offsetValue = -gaugeThickness;
      }

      if (shape == GxRadialPointerShape.circle) {
        final double x =
            center.dx + (radius + offsetValue) * math.cos(pointerAngle);
        final double y =
            center.dy + (radius + offsetValue) * math.sin(pointerAngle);

        canvas.drawCircle(Offset(x, y), pointerSize, pointerPaint);
      } else if (shape == GxRadialPointerShape.triangle) {
        final double x1 =
            center.dx + (radius + offsetValue) * math.cos(pointerAngle);
        final double y1 =
            center.dy + (radius + offsetValue) * math.sin(pointerAngle);

        final double x2 =
            center.dx +
            (radius + offsetValue + pointerSize) * math.cos(pointerAngle + 0.1);
        final double y2 =
            center.dy +
            (radius + offsetValue + pointerSize) * math.sin(pointerAngle + 0.1);

        final double x3 =
            center.dx +
            (radius + offsetValue + pointerSize) * math.cos(pointerAngle - 0.1);
        final double y3 =
            center.dy +
            (radius + offsetValue + pointerSize) * math.sin(pointerAngle - 0.1);

        final Path pointerPath = Path()
          ..moveTo(x1, y1)
          ..lineTo(x2, y2)
          ..lineTo(x3, y3)
          ..close();

        canvas.drawPath(pointerPath, pointerPaint);
        // final double x =
        //     center.dx + ((radius + offsetValue) * math.cos(pointerAngle));
        // final double y =
        //     center.dy + ((radius + offsetValue) * math.sin(pointerAngle));
        // final double halfSize = pointerSize / 2;
        // final Path path = Path()
        //   ..moveTo(x, y - halfSize)
        //   ..lineTo(x + halfSize, y + halfSize)
        //   ..lineTo(x - halfSize, y + halfSize)
        //   ..close();
        // canvas.drawPath(path, pointerPaint);
      }
    }
  }

  void _drawRadialGauge(
    Canvas canvas,
    Size size,
    double radius,
    Offset center,
    double startAngle,
    double sweepAngle,
  ) {
    // Draw graident background if gradient is provided

    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Paint backgroundPaint = Paint()
      ..color = style.backgroundColor ?? style.color.withValues(alpha: 0.2)
      ..strokeWidth = style.thickness
      ..style = style.paintingStyle
      ..strokeCap = style.strokeCap
      ..shader =
          style.backgroundGradient?.createShader(rect) ??
          style.gradient?.createShader(rect);

    final Paint foregroundPaint = Paint()
      ..color = style.color
      ..strokeWidth = style.thickness
      ..style = style.paintingStyle
      ..strokeCap = style.strokeCap
      ..shader = style.gradient?.createShader(rect);

    canvas.drawArc(rect, startAngle, sweepAngle, false, backgroundPaint);

    final double sweep = (value.value / value.max) * sweepAngle;
    canvas.drawArc(rect, startAngle, sweep, false, foregroundPaint);
  }

  void _drawTickLabels(
    Canvas canvas,
    Offset center,
    double radius,
    double angle,
    double labelValue,
    double tickLength,
    int i,
  ) {
    final GxRadialTickLabelStyle filteredLabel = labelStyler != null
        ? labelStyler!(labelValue, i)
        : labelTickStyle;
    final double labelRadius = radius - tickLength - filteredLabel.padding;
    double labelX = center.dx + labelRadius * math.cos(angle);
    double labelY = center.dy + labelRadius * math.sin(angle);

    if (filteredLabel.position == GxRadialElementPosition.outside) {
      labelX =
          center.dx +
          (radius + tickLength + filteredLabel.padding) * math.cos(angle);
      labelY =
          center.dy +
          (radius + tickLength + filteredLabel.padding) * math.sin(angle);
    }

    final String labelValueStr = labelValue.toStringAsFixed(0);

    final String labelText = labelFormatter != null
        ? labelFormatter!(labelValue, i)
        : labelValueStr;

    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: labelText, style: filteredLabel.style),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    final Offset labelOffset = Offset(
      labelX - textPainter.width / 2,
      labelY - textPainter.height / 2,
    );

    textPainter.paint(canvas, labelOffset);
  }

  void _drawTicksAndLabels(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
  ) {
    final double minValue = value.min;
    final double maxValue = value.max;
    final int totalTicks = maxValue ~/ interval;

    final double thickness = style.thickness;

    for (int i = 0; i <= totalTicks; i++) {
      final double labelValue =
          minValue + (i / totalTicks) * (maxValue - minValue);
      final GxRadialTickStyle filteredMajorTickStyle = majorTickStyler != null
          ? majorTickStyler!(labelValue, i)
          : majorTickStyle;

      final double tickLength = filteredMajorTickStyle.length;

      // final double angle = (-math.pi / 2) + (i / totalTicks) * 2 * math.pi;
      final double angle = startAngle + (i / totalTicks) * sweepAngle;

      // Define the start and end points of the tick
      double x1 = center.dx + (radius - tickLength) * math.cos(angle);
      double y1 = center.dy + (radius - tickLength) * math.sin(angle);
      double x2 = center.dx + (radius * math.cos(angle));
      double y2 = center.dy + radius * math.sin(angle);

      if (filteredMajorTickStyle.position == GxRadialElementPosition.outside) {
        x1 = center.dx + (radius + tickLength) * math.cos(angle);
        y1 = center.dy + (radius + tickLength) * math.sin(angle);
      } else {
        x1 = center.dx + (radius - tickLength) * math.cos(angle);
        y1 = center.dy + (radius - tickLength) * math.sin(angle);
      }

      // End point depends on the alignment
      if (filteredMajorTickStyle.alignment == GxRadialElementAlignment.center) {
        x2 = center.dx + (radius * math.cos(angle));
        y2 = center.dy + radius * math.sin(angle);
      } else if (filteredMajorTickStyle.alignment ==
          GxRadialElementAlignment.end) {
        x1 = center.dx + (radius - thickness / 2) * math.cos(angle);
        y1 = center.dy + (radius - thickness / 2) * math.sin(angle);
        x2 = center.dx + (radius - tickLength) * math.cos(angle);
        y2 = center.dy + (radius - tickLength) * math.sin(angle);
      } else if (filteredMajorTickStyle.alignment ==
          GxRadialElementAlignment.start) {
        x1 = center.dx + (radius + thickness / 2) * math.cos(angle);
        y1 = center.dy + (radius + thickness / 2) * math.sin(angle);
        x2 = center.dx + (radius + tickLength) * math.cos(angle);
        y2 = center.dy + (radius + tickLength) * math.sin(angle);
      }

      if (showMajorTicks) {
        // Draw tick
        final Paint tickPaint = Paint()
          ..color = filteredMajorTickStyle.color
          ..strokeWidth = filteredMajorTickStyle.thickness
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), tickPaint);
      }

      if (showMinorTicks) {
        // Draw minor ticks

        final double nextAngle =
            startAngle + ((i + 1) / totalTicks) * sweepAngle;
        _drawMinorTicks(
          canvas: canvas,
          center: center,
          radius: radius,
          startAngle: startAngle,
          sweepAngle: sweepAngle,
          angle: angle,
          tickLength: tickLength,
          nextAngle: nextAngle,
        );
      }

      if (showLabels) {
        // Draw label
        _drawTickLabels(
          canvas,
          center,
          radius,
          angle,
          labelValue,
          tickLength,
          i,
        );
      }
    }
  }

  void _drawValueAtCenter(Canvas canvas, Offset center, Size size) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: value.value.toStringAsFixed(1),
        style: const TextStyle(color: Colors.black, fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final double textWidth = textPainter.width;
    final double textHeight = textPainter.height;

    final double textX = center.dx - (textWidth / 2);
    final double textY = center.dy - (textHeight / 2);

    textPainter.paint(canvas, Offset(textX, textY));
  }
}
