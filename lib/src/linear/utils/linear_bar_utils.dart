import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:gx_gauge/src/common/models/gauge_label.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/text_utils.dart';
import 'package:gx_gauge/src/linear/models/linear_bar_pointer.dart';

/// Draws [GxLinearBarPointer]s along a [LinearTrack].
abstract final class LinearBarUtils {
  /// Draws each bar from `x(start)` to `x(end)`, [height] tall with its top
  /// at [top].
  ///
  /// Bars are shrunk by `gap / 2` on every side that doesn't touch the end of
  /// the track, which leaves a [gap]-pixel space between adjacent bars.
  /// [color] is the fallback for bars without a color, and [labelStyle] the
  /// base style that bar labels merge onto.
  static void drawBars({
    required Canvas canvas,
    required GaugeScale scale,
    required LinearTrack track,
    required List<GxLinearBarPointer> bars,
    required double top,
    required double height,
    required Color color,
    required TextStyle labelStyle,
    required TextDirection textDirection,
    double gap = 0,
  }) {
    const double epsilon = 1e-6;
    for (final GxLinearBarPointer bar in bars) {
      final double x1 = track.xOf(scale.fractionOf(bar.start));
      final double x2 = track.xOf(scale.fractionOf(bar.end));
      double left = math.min(x1, x2);
      double right = math.max(x1, x2);
      if (gap > 0) {
        if (left > track.start + epsilon) {
          left += gap / 2;
        }
        if (right < track.end - epsilon) {
          right -= gap / 2;
        }
      }
      if (right <= left) {
        continue;
      }

      final Rect rect = Rect.fromLTRB(left, top, right, top + height);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, bar.radius ?? Radius.zero),
        Paint()
          ..color = bar.color ?? color
          ..strokeWidth = bar.thickness
          ..strokeCap = bar.strokeCap
          ..style = bar.paintingStyle,
      );

      final GxGaugeLabel? label = bar.label;
      if (label != null) {
        _drawLabel(canvas, rect, label, labelStyle, textDirection);
      }
    }
  }

  static void _drawLabel(
    Canvas canvas,
    Rect rect,
    GxGaugeLabel label,
    TextStyle baseStyle,
    TextDirection textDirection,
  ) {
    paintText(
      canvas,
      text: label.label,
      style: baseStyle.merge(label.style),
      textDirection: textDirection,
      position: (Size size) {
        double x;
        switch (resolveTextAlign(label.textAlign, textDirection)) {
          case TextAlign.left:
            x = rect.left + label.spaceExtent;
          case TextAlign.right:
            x = rect.right - size.width - label.spaceExtent;
          case TextAlign.center:
          case TextAlign.justify:
          case TextAlign.start:
          case TextAlign.end:
            x = rect.center.dx - size.width / 2;
        }
        final Offset offset = label.offset ?? Offset.zero;
        return Offset(x, rect.center.dy - size.height / 2) + offset;
      },
    );
  }
}
