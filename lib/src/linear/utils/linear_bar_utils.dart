import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:gx_gauge/src/common/models/gauge_label.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/text_utils.dart';
import 'package:gx_gauge/src/linear/models/linear_bar_pointer.dart';

/// Where a bar sits across the track: its `top` edge and `height`.
typedef BarPlacement = ({double top, double height});

/// Draws [GxLinearBarPointer]s along a [LinearTrack].
abstract final class LinearBarUtils {
  /// Draws each bar from `x(start)` to `x(end)`, placed across the track by
  /// [place].
  ///
  /// Bars are shrunk by `gap / 2` on every side that doesn't touch the end of
  /// the track, which leaves a [gap]-pixel space between adjacent bars.
  /// [color] is the fallback fill, and [labelStyle] the base style that bar
  /// labels merge onto.
  static void drawBars({
    required Canvas canvas,
    required GaugeScale scale,
    required LinearTrack track,
    required List<GxLinearBarPointer> bars,
    required BarPlacement Function(GxLinearBarPointer bar) place,
    required Color color,
    required TextStyle labelStyle,
    required TextDirection textDirection,
    double gap = 0,
    bool upright = false,
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

      final BarPlacement placement = place(bar);
      final Rect rect = Rect.fromLTWH(
        left,
        placement.top,
        right - left,
        placement.height,
      );
      paintBand(
        canvas,
        rect: rect,
        radius: bar.radius,
        color: bar.color ?? color,
        shaderCallback: bar.shaderCallback,
        borderColor: bar.borderColor,
        borderWidth: bar.borderWidth,
      );

      final GxGaugeLabel? label = bar.label;
      if (label != null) {
        _drawLabel(canvas, rect, label, labelStyle, textDirection, upright);
      }
    }
  }

  /// Fills [rect] with [color] (or the [shaderCallback] shader) and outlines
  /// it with [borderColor] when set.
  static void paintBand(
    Canvas canvas, {
    required Rect rect,
    required Color color,
    Radius? radius,
    ShaderCallback? shaderCallback,
    Color? borderColor,
    double borderWidth = 1,
  }) {
    final RRect rrect = RRect.fromRectAndRadius(rect, radius ?? Radius.zero);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color
        ..shader = shaderCallback?.call(rect),
    );
    if (borderColor != null && borderWidth > 0) {
      canvas.drawRRect(
        rrect.deflate(borderWidth / 2),
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth,
      );
    }
  }

  static void _drawLabel(
    Canvas canvas,
    Rect rect,
    GxGaugeLabel label,
    TextStyle baseStyle,
    TextDirection textDirection,
    bool upright,
  ) {
    paintText(
      canvas,
      text: label.label,
      style: baseStyle.merge(label.style),
      textDirection: textDirection,
      upright: upright,
      position: (Size size) {
        final double x = switch (resolveTextAlign(
          label.textAlign,
          textDirection,
        )) {
          TextAlign.left => rect.left + label.spaceExtent,
          TextAlign.right => rect.right - size.width - label.spaceExtent,
          _ => rect.center.dx - size.width / 2,
        };
        final Offset offset = label.offset ?? Offset.zero;
        return Offset(x, rect.center.dy - size.height / 2) + offset;
      },
    );
  }
}
