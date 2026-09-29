import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/common/models/linear_gauge_common_model.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/linear/models/linear_needle_model.dart';
import 'package:gx_gauge/src/linear/models/scale_linear_gauge_model.dart';
import 'package:gx_gauge/src/linear/utils/linear_bar_utils.dart';
import 'package:gx_gauge/src/linear/utils/needle_utils.dart';

class ScaleLinearGaugePainter extends CustomPainter {
  ScaleLinearGaugePainter({
    required this.minimum,
    required this.maximum,
    required this.value,
    required this.interval,
    required this.axisSpaceExtent,
    required this.axisLabelStyle,
    required this.axisTrackStyle,
    required this.minorTicksPerInterval,
    required this.majorTickStyle,
    required this.minorTickStyle,
    required this.labelPosition,
    required this.tickPosition,
    required this.showMajorTicks,
    required this.showMinorTicks,
    required this.showAxisTrack,
    required this.showAxisLabel,
    this.bars,
    this.barHeight,
    this.markers,
    this.labelFormatter,
    this.majorTickStyler,
    this.needle,
    this.fillAreas,
    this.labelStyler,
    this.barOffset = 0.5,
    this.applyBarColorOnAxisTick = false,
  });
  final double minimum;
  final double maximum;
  final double value;
  final double? interval;
  final double axisSpaceExtent;
  final TextStyle? axisLabelStyle;
  final GxLinearAxisStyle axisTrackStyle;
  final int minorTicksPerInterval;
  final GxLinearTickStyle majorTickStyle;
  final GxLinearTickStyle minorTickStyle;
  final List<GxLinearBarPointer>? bars;
  final List<GxLinearMarkerPointer>? markers;
  final GxValueLabelFormatter? labelFormatter;
  final GxLabelPosition labelPosition;
  final GxElementPosition tickPosition;
  final bool showMajorTicks;
  final bool showMinorTicks;
  final bool showAxisTrack;
  final bool showAxisLabel;
  final GxValueTickStyler<GxLinearTickStyle>? majorTickStyler;
  final GxLinearNeedle? needle;
  final double? barHeight;
  final List<GxLinearFillArea>? fillAreas;
  final GxValueLabelStyler<TextStyle>? labelStyler;
  final double barOffset;
  final bool applyBarColorOnAxisTick;

  @override
  void paint(Canvas canvas, Size size) {
    _drawDefaultGauge(canvas, size);
  }

  @override
  bool shouldRepaint(covariant ScaleLinearGaugePainter oldDelegate) {
    return minimum != oldDelegate.minimum ||
        maximum != oldDelegate.maximum ||
        interval != oldDelegate.interval ||
        axisSpaceExtent != oldDelegate.axisSpaceExtent ||
        axisLabelStyle != oldDelegate.axisLabelStyle ||
        axisTrackStyle != oldDelegate.axisTrackStyle ||
        minorTicksPerInterval != oldDelegate.minorTicksPerInterval ||
        majorTickStyle != oldDelegate.majorTickStyle ||
        minorTickStyle != oldDelegate.minorTickStyle ||
        bars != oldDelegate.bars ||
        markers != oldDelegate.markers ||
        labelFormatter != oldDelegate.labelFormatter ||
        labelPosition != oldDelegate.labelPosition ||
        tickPosition != oldDelegate.tickPosition ||
        showMajorTicks != oldDelegate.showMajorTicks ||
        showMinorTicks != oldDelegate.showMinorTicks ||
        showAxisTrack != oldDelegate.showAxisTrack ||
        showAxisLabel != oldDelegate.showAxisLabel ||
        majorTickStyler != oldDelegate.majorTickStyler ||
        value != oldDelegate.value ||
        needle != oldDelegate.needle ||
        fillAreas != oldDelegate.fillAreas ||
        labelStyler != oldDelegate.labelStyler ||
        barHeight != oldDelegate.barHeight ||
        barOffset != oldDelegate.barOffset ||
        applyBarColorOnAxisTick != oldDelegate.applyBarColorOnAxisTick;
  }

  void _drawBars(Canvas canvas, Size size) {
    final List<GxElementPosition> allowedTickPosition = <GxElementPosition>[
      GxElementPosition.inside,
      GxElementPosition.outside,
    ];
    if (!allowedTickPosition.contains(tickPosition)) {
      return;
    }
    if (bars == null) {
      return;
    }

    if (bars!.isEmpty) {
      return;
    }

    double height = size.height / 2;
    if (barHeight != null) {
      height = barHeight!;
    }

    double barFromTop = height / 2;

    final double offset = applyBarColorOnAxisTick ? -1 : barOffset;

    if (tickPosition == GxElementPosition.inside) {
      barFromTop = ((size.height / 2) - height) - offset;
    } else if (tickPosition == GxElementPosition.outside) {
      barFromTop = size.height / 2 + offset;
    }

    final Size barSize = Size(size.width, height);

    LinearBarUtils.drawBars(
      canvas: canvas,
      size: barSize,
      bars: bars!,
      barOffset: barFromTop,
      value: value,
      gapBetweenBars: 0,
      minValue: minimum,
      maxValue: maximum,
    );
  }

  // Implement drawing methods for each gauge type
  void _drawDefaultGauge(Canvas canvas, Size size) {
    final double startX = axisSpaceExtent;
    final double endX = size.width - axisSpaceExtent;
    if (showAxisTrack && !applyBarColorOnAxisTick) {
      final Paint trackPaint = Paint()
        ..color = axisTrackStyle.color
        ..strokeWidth = axisTrackStyle.thickness
        ..style = axisTrackStyle.paintingStyle
        ..strokeCap = axisTrackStyle.strokeCap;

      // Draw the axis line
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(endX, size.height / 2),
        trackPaint,
      );
    }

    // Draw ticks and labels
    _drawTicksAndLabels(canvas, size, startX, endX);

    // Draw Needle
    _drawNeedle(canvas, size);

    // Draw Marker Pointer
    _drawLinearMarkerPointer(canvas, size);

    // Draw the filled area between two ticks
    _drawFilledArea(canvas, size);

    // Draw the bars
    _drawBars(canvas, size);
  }

  void _drawFilledArea(Canvas canvas, Size size) {
    if (fillAreas == null) {
      return;
    }

    for (final GxLinearFillArea fillAreaPointer in fillAreas!) {
      final double startFillValue = fillAreaPointer.startValue;
      final double endFillValue = fillAreaPointer.endValue;
      final Color fillColor = fillAreaPointer.color;
      final double axisThickness = fillAreaPointer.thickness;
      final double totalRange = maximum - minimum;
      final double startRatio = (startFillValue - minimum) / totalRange;
      final double endRatio = (endFillValue - minimum) / totalRange;

      final double startX = startRatio * size.width;
      final double endX = endRatio * size.width;

      final Paint fillPaint = Paint()
        ..color = fillColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt
        ..strokeWidth = axisThickness;

      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(endX, size.height / 2),
        fillPaint,
      );
    }
  }

  void _drawLinearMarkerPointer(Canvas canvas, Size size) {
    if (markers != null && markers!.isNotEmpty) {
      for (final GxLinearMarkerPointer markerPointer in markers!) {
        // final double markerX = size.width / 2;
        // final double markerY = size.height / 2;

        // Check Needle is enabled
        if (markerPointer.needle != null && markerPointer.needle!.enabled) {
          // Draw the needle
          NeedleUtils.drawIt(
            canvas: canvas,
            size: size,
            maxValue: maximum,
            minValue: minimum,
            value: markerPointer.value,
            needle: markerPointer.needle!,
            thickness: markerPointer.needle!.offset,
            dense: true,
          );
        }
      }
    }
  }

  void _drawNeedle(Canvas canvas, Size size) {
    if (needle != null) {
      // Draw the needle if enabled
      if (needle!.enabled) {
        // Calculate thickness by needle height and width

        // Draw the needle
        NeedleUtils.drawIt(
          canvas: canvas,
          size: size,
          maxValue: maximum,
          minValue: minimum,
          value: value,
          needle: needle!,
          thickness: _getThickness(needle!.size.width, needle!.size.height),
        );
      }
    }
  }

  void _drawTicksAndLabels(
    Canvas canvas,
    Size size,
    double startX,
    double endX,
  ) {
    // Get the total interval from the minimum and maximum values
    final double totalInterval = maximum - minimum;

    // Calculate the actual interval from the total interval and the interval value
    final double actualInterval = interval ?? totalInterval / 10;

    // Calculate the number of divisions based on the actual interval and the total interval
    final int divisions = (totalInterval / actualInterval).floor();

    // Calculate the tick spacing based on the start and end x values and the number of divisions
    final double tickSpacing = (endX - startX) / divisions;

    for (int i = 0; i <= divisions; i++) {
      // Determine if the current tick is odd or even
      final bool isOdd = (minimum + i) % 2 != 0;

      final double x = startX + (tickSpacing * i);

      // P1: Start Point and Vertical Up Line from X Axis
      // P2: End Point and Vertical Down Line from X Axis

      // Default cross
      Offset majorTickP1 = Offset(
        x,
        size.height / 2 - majorTickStyle.length / 2,
      );
      Offset majorTickP2 = Offset(
        x,
        size.height / 2 + majorTickStyle.length / 2,
      );
      double minorP1dY = size.height / 2 - minorTickStyle.length / 2;
      double minorP2dY = size.height / 2 + minorTickStyle.length / 2;

      if (tickPosition == GxElementPosition.inside) {
        // Horizontal: Start From Bottom
        majorTickP1 = Offset(
          x,
          size.height / 2 + (axisTrackStyle.thickness / 2),
        );

        minorP1dY = size.height / 2 + axisTrackStyle.thickness / 2;
      } else if (tickPosition == GxElementPosition.outside) {
        // Horizontal: Start From Top and Hide Bottom
        majorTickP2 = Offset(
          x,
          size.height / 2 - (axisTrackStyle.thickness / 2),
        );

        minorP2dY = size.height / 2 - axisTrackStyle.thickness / 2;
      } else if (tickPosition == GxElementPosition.outAndIn) {
        // Determine if the current tick should go up or down
        if (isOdd) {
          // Horizontal: Start From Bottom
          majorTickP1 = Offset(
            x,
            size.height / 2 + (axisTrackStyle.thickness / 2),
          );
        } else {
          majorTickP2 = Offset(
            x,
            size.height / 2 - (axisTrackStyle.thickness / 2),
          );
        }
      } else if (tickPosition == GxElementPosition.inAndOut) {
        // Determine if the current tick should go up or down
        if (isOdd) {
          // Horizontal: Start From Top and Hide Bottom
          majorTickP2 = Offset(
            x,
            size.height / 2 - (axisTrackStyle.thickness / 2),
          );
        } else {
          majorTickP1 = Offset(
            x,
            size.height / 2 + (axisTrackStyle.thickness / 2),
          );
        }
      }

      final double tickValue = minimum + actualInterval * i;

      // Filter Major Tick Style based on the value and index
      GxLinearTickStyle filterMajorTickStyle = majorTickStyle;

      // Check whether to apply the bar color on the axis tick
      final bool allowFilterStyle =
          applyBarColorOnAxisTick && bars != null && bars!.isNotEmpty;

      if (allowFilterStyle) {
        filterMajorTickStyle = _getFilteredTickStyle(majorTickStyle, tickValue);
      } else if (majorTickStyler != null) {
        filterMajorTickStyle = majorTickStyler!(tickValue, i);
      } else {
        filterMajorTickStyle = majorTickStyle;
      }

      // Draw major tick
      canvas.drawLine(
        majorTickP1,
        majorTickP2,
        Paint()
          ..color = filterMajorTickStyle.color
          ..strokeWidth = filterMajorTickStyle.thickness,
      );

      // Draw minor ticks
      if (showMinorTicks) {
        if (minorTicksPerInterval > 0 && i < divisions) {
          final double minorTickSpacing =
              tickSpacing / (minorTicksPerInterval + 1);
          for (int j = 1; j <= minorTicksPerInterval; j++) {
            final double minorX = x + (minorTickSpacing * j);
            final double minorTickValue = minimum + actualInterval * i + j;

            final GxLinearTickStyle filterMinorTickStyle = allowFilterStyle
                ? _getFilteredTickStyle(minorTickStyle, minorTickValue)
                : minorTickStyle;
            canvas.drawLine(
              Offset(minorX, minorP1dY),
              Offset(minorX, minorP2dY),
              Paint()
                ..color = filterMinorTickStyle.color
                ..strokeWidth = filterMinorTickStyle.thickness,
            );
          }
        }
      }

      // Draw labels
      if (showAxisLabel) {
        final TextStyle labelStyle = labelStyler != null
            ? labelStyler!(minimum + actualInterval * i, i)
            : axisLabelStyle ??
                  const TextStyle(color: Colors.black, fontSize: 12);
        // Check Tick Position is InAndOut
        final bool isTickPositionInOutAndTickIsOdd =
            tickPosition == GxElementPosition.inAndOut && isOdd;
        final bool isTickPositionOutInAndTickIsEven =
            tickPosition == GxElementPosition.outAndIn && !isOdd;

        final bool isLabelPositionTopCenter =
            labelPosition == GxLabelPosition.topCenter;

        final bool showLabelOnTop =
            isTickPositionInOutAndTickIsOdd ||
            isLabelPositionTopCenter ||
            isTickPositionOutInAndTickIsEven;

        final TextPainter textPainter = TextPainter(
          textAlign: TextAlign.left,
          textDirection: TextDirection.rtl,
          textWidthBasis: TextWidthBasis.longestLine,
        );

        final double actualValue = minimum + actualInterval * i;
        final String label = actualValue.toStringAsFixed(0);
        textPainter
          ..text = TextSpan(
            text: labelFormatter != null
                ? labelFormatter!(actualValue, i)
                : label,
            style: labelStyle,
          )
          ..layout();

        if (showLabelOnTop) {
          textPainter.paint(
            canvas,
            Offset(
              x - textPainter.width / 2,
              size.height / 2 -
                  majorTickStyle.length / 2 -
                  4 -
                  textPainter.height,
            ),
          );
        } else {
          textPainter.paint(
            canvas,
            Offset(
              x - textPainter.width / 2,
              size.height / 2 + majorTickStyle.length / 2 + 4,
            ),
          );
        }
      }
    }
  }

  // Helper method to get Tick Style color
  GxLinearTickStyle _getFilteredTickStyle(
    GxLinearTickStyle tickStyle,
    double tickValue,
  ) {
    GxLinearTickStyle localStyle = tickStyle;
    double startBarValue = minimum;
    for (final GxLinearBarPointer barPointer in bars!) {
      final double endBarValue = startBarValue + barPointer.value;
      if (tickValue >= startBarValue && tickValue <= endBarValue) {
        localStyle = localStyle.copyWith(color: barPointer.color);
        break;
      }
      startBarValue = endBarValue;
    }

    return localStyle;
  }

  double _getThickness(double width, double height) {
    return math.sqrt(math.pow(width, 2) + math.pow(height, 2));
  }
}
