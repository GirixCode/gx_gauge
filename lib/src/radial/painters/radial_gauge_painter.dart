import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/common/models/gauge_label.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/painter_config.dart';
import 'package:gx_gauge/src/core/text_utils.dart';
import 'package:gx_gauge/src/radial/models/radial_gauge_style.dart';
import 'package:gx_gauge/src/radial/utils/angle_utils.dart';

/// Everything [RadialGaugePainter] draws with, with theme defaults already
/// resolved.
class RadialPainterConfig extends PainterConfig {
  /// Creates a radial painter configuration.
  const RadialPainterConfig({
    required this.scale,
    required this.style,
    required this.color,
    required this.trackColor,
    required this.startAngleInDegree,
    required this.sweepAngleInDegree,
    required this.interval,
    required this.minorTicksPerInterval,
    required this.showMajorTicks,
    required this.showMinorTicks,
    required this.showLabels,
    required this.majorTickStyle,
    required this.minorTickStyle,
    required this.tickColor,
    required this.labelTickStyle,
    required this.labelStyle,
    required this.showValueAtCenter,
    required this.valueStyle,
    required this.showNeedle,
    required this.needleColor,
    required this.pointerColor,
    required this.rangeColor,
    required this.capInnerColor,
    required this.textDirection,
    this.needle,
    this.pointers = const <GxRadialPointer>[],
    this.ranges = const <GxRadialRange>[],
    this.labelFormatter,
    this.labelStyler,
    this.majorTickStyler,
  });

  /// The value range.
  final GaugeScale scale;

  /// Arc style.
  final GxRadialGaugeStyle style;

  /// Resolved value-arc color.
  final Color color;

  /// Resolved track-arc color.
  final Color trackColor;

  /// Where the arc starts, in degrees clockwise from 3 o'clock.
  final double startAngleInDegree;

  /// How far the arc sweeps, in degrees.
  final double sweepAngleInDegree;

  /// Major tick step, or null for a tenth of the range.
  final double? interval;

  /// Minor ticks between two major ticks.
  final int minorTicksPerInterval;

  /// Whether major ticks are drawn.
  final bool showMajorTicks;

  /// Whether minor ticks are drawn.
  final bool showMinorTicks;

  /// Whether tick labels are drawn.
  final bool showLabels;

  /// Major tick style.
  final GxRadialTickStyle majorTickStyle;

  /// Minor tick style.
  final GxRadialTickStyle minorTickStyle;

  /// Resolved fallback tick color.
  final Color tickColor;

  /// Tick label placement.
  final GxRadialTickLabelStyle labelTickStyle;

  /// Resolved base style for tick labels.
  final TextStyle labelStyle;

  /// Whether the value is written at the center.
  final bool showValueAtCenter;

  /// Resolved style of the center value.
  final TextStyle valueStyle;

  /// Whether [needle] is drawn.
  final bool showNeedle;

  /// Resolved fallback needle color.
  final Color needleColor;

  /// Resolved fallback pointer color.
  final Color pointerColor;

  /// Resolved fallback range color.
  final Color rangeColor;

  /// Resolved fill inside an outlined needle cap.
  final Color capInnerColor;

  /// Direction for text.
  final TextDirection textDirection;

  /// The value needle.
  final GxRadialNeedle? needle;

  /// Extra markers and needles.
  final List<GxRadialPointer> pointers;

  /// Colored bands along the arc.
  final List<GxRadialRange> ranges;

  /// Formats tick labels.
  final GxValueLabelFormatter? labelFormatter;

  /// Styles tick labels per value.
  final GxValueLabelStyler<GxRadialTickLabelStyle>? labelStyler;

  /// Styles major ticks per value.
  final GxValueTickStyler<GxRadialTickStyle>? majorTickStyler;

  @override
  List<Object?> get props => <Object?>[
    scale,
    style,
    color,
    trackColor,
    startAngleInDegree,
    sweepAngleInDegree,
    interval,
    minorTicksPerInterval,
    showMajorTicks,
    showMinorTicks,
    showLabels,
    majorTickStyle,
    minorTickStyle,
    tickColor,
    labelTickStyle,
    labelStyle,
    showValueAtCenter,
    valueStyle,
    showNeedle,
    needleColor,
    pointerColor,
    rangeColor,
    capInnerColor,
    textDirection,
    needle,
    pointers,
    ranges,
    labelFormatter,
    labelStyler,
    majorTickStyler,
  ];
}

/// Paints a radial gauge.
class RadialGaugePainter extends CustomPainter {
  /// Creates a painter that repaints whenever [value] ticks.
  RadialGaugePainter({required this.config, required this.value})
    : super(repaint: value);

  /// What to draw.
  final RadialPainterConfig config;

  /// The current (animated) value.
  final Animation<double> value;

  @override
  void paint(Canvas canvas, Size size) {
    final RadialPainterConfig c = config;
    final _Geometry g = _Geometry(
      center: Offset(size.width / 2, size.height / 2),
      radius: math.min(size.width, size.height) / 2 - c.style.thickness / 2,
      startAngle: AngleUtils.degreesToRadians(c.startAngleInDegree),
      sweepAngle: AngleUtils.degreesToRadians(c.sweepAngleInDegree),
      scale: c.scale,
    );

    _drawArcs(canvas, g);
    _drawRanges(canvas, g);
    _drawTicksAndLabels(canvas, g);
    if (c.showValueAtCenter) {
      _drawValueAtCenter(canvas, _valueAnchor(g));
    }
    final GxRadialNeedle? needle = c.needle;
    if (c.showNeedle && needle != null) {
      _drawNeedle(canvas, size, g, value.value, needle);
    }
    _drawPointers(canvas, size, g);
  }

  /// The value under [position] in a gauge of [size], found from the angle
  /// around the center. Points outside the arc's sweep snap to the nearer
  /// end.
  static double valueAt(
    RadialPainterConfig config,
    Size size,
    Offset position,
  ) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Offset d = position - center;
    final double start = AngleUtils.degreesToRadians(config.startAngleInDegree);
    final double sweep = AngleUtils.degreesToRadians(config.sweepAngleInDegree);
    if (sweep == 0 || d == Offset.zero) {
      return config.scale.min;
    }
    const double tau = 2 * math.pi;
    // Angle past the start, measured in the sweep's direction, in [0, 2π).
    final double raw = (math.atan2(d.dy, d.dx) - start) * sweep.sign;
    final double past = ((raw % tau) + tau) % tau;
    final double span = sweep.abs();
    double fraction;
    if (past <= span) {
      fraction = past / span;
    } else {
      // In the gap: snap to whichever end is angularly closer.
      fraction = (past - span) < (tau - past) ? 1 : 0;
    }
    return config.scale.valueAt(fraction);
  }

  @override
  bool shouldRepaint(covariant RadialGaugePainter oldDelegate) =>
      oldDelegate.config != config || oldDelegate.value != value;

  void _drawArcs(Canvas canvas, _Geometry g) {
    final GxRadialGaugeStyle style = config.style;
    final Rect rect = Rect.fromCircle(center: g.center, radius: g.radius);
    final Paint track = Paint()
      ..color = config.trackColor
      ..strokeWidth = style.thickness
      ..style = style.paintingStyle
      ..strokeCap = style.strokeCap
      ..shader = (style.backgroundGradient ?? style.gradient)?.createShader(
        rect,
      );
    final Paint arc = Paint()
      ..color = config.color
      ..strokeWidth = style.thickness
      ..style = style.paintingStyle
      ..strokeCap = style.strokeCap
      ..shader = style.gradient?.createShader(rect);
    final double fraction = config.scale.fractionOf(value.value);
    canvas
      ..drawArc(rect, g.startAngle, g.sweepAngle, false, track)
      ..drawArc(rect, g.startAngle, fraction * g.sweepAngle, false, arc);
  }

  void _drawRanges(Canvas canvas, _Geometry g) {
    for (final GxRadialRange range in config.ranges) {
      final double start = g.angleOf(range.start);
      final double end = g.angleOf(range.end);
      final double radius = g.radius + range.offset;
      final Rect rect = Rect.fromCircle(center: g.center, radius: radius);
      canvas.drawArc(
        rect,
        start,
        end - start,
        false,
        Paint()
          ..color = range.color ?? config.rangeColor
          ..strokeWidth = range.height
          ..style = PaintingStyle.stroke
          ..shader = range.shaderCallback?.call(rect.inflate(range.height / 2)),
      );

      final GxGaugeLabel? label = range.label;
      if (label != null) {
        final double middle = (start + end) / 2;
        paintText(
          canvas,
          text: label.label,
          style: config.labelStyle.merge(label.style),
          textDirection: config.textDirection,
          position: (Size text) {
            // Beside the band, on the side away from the gauge arc (inside
            // for bands shifted inwards), far enough that the text's corner
            // clears it at any angle.
            final double clearance =
                range.height / 2 + 4 + text.longestSide / 2;
            final double distance = range.offset < 0
                ? radius - clearance
                : radius + clearance;
            final Offset anchor =
                g.pointAt(middle, distance) + (label.offset ?? Offset.zero);
            return anchor - Offset(text.width / 2, text.height / 2);
          },
        );
      }
    }
  }

  void _drawTicksAndLabels(Canvas canvas, _Geometry g) {
    final RadialPainterConfig c = config;
    if (!c.showMajorTicks && !c.showMinorTicks && !c.showLabels) {
      return;
    }
    final List<double> ticks = c.scale.ticks(c.interval);
    for (int i = 0; i < ticks.length; i++) {
      final double tick = ticks[i];
      final double angle = g.angleOf(tick);
      final GxRadialTickStyle major =
          c.majorTickStyler?.call(tick, i) ?? c.majorTickStyle;

      if (c.showMajorTicks) {
        _drawTick(canvas, g, angle, major);
      }
      if (c.showMinorTicks && i < ticks.length - 1) {
        final double next = g.angleOf(ticks[i + 1]);
        final int count = c.minorTicksPerInterval;
        for (int j = 1; j <= count; j++) {
          _drawTick(
            canvas,
            g,
            angle + (next - angle) * j / (count + 1),
            c.minorTickStyle,
          );
        }
      }
      if (c.showLabels) {
        _drawTickLabel(canvas, g, angle, tick, major.length, i);
      }
    }
  }

  void _drawTick(
    Canvas canvas,
    _Geometry g,
    double angle,
    GxRadialTickStyle style,
  ) {
    final double half = config.style.thickness / 2;
    final double length = style.length;
    final (double from, double to) = switch (style.alignment) {
      GxRadialElementAlignment.end => (g.radius - half, g.radius - length),
      GxRadialElementAlignment.start => (g.radius + half, g.radius + length),
      GxRadialElementAlignment.center =>
        style.position == GxRadialElementPosition.outside
            ? (g.radius + length, g.radius)
            : (g.radius - length, g.radius),
    };
    canvas.drawLine(
      g.pointAt(angle, from),
      g.pointAt(angle, to),
      Paint()
        ..color = style.color ?? config.tickColor
        ..strokeWidth = style.thickness
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawTickLabel(
    Canvas canvas,
    _Geometry g,
    double angle,
    double value,
    double tickLength,
    int index,
  ) {
    final GxRadialTickLabelStyle label =
        config.labelStyler?.call(value, index) ?? config.labelTickStyle;
    final double distance = label.position == GxRadialElementPosition.outside
        ? g.radius + tickLength + label.padding
        : g.radius - tickLength - label.padding;
    final Offset anchor = g.pointAt(angle, distance);
    paintText(
      canvas,
      text:
          config.labelFormatter?.call(value, index) ?? formatGaugeValue(value),
      style: config.labelStyle.merge(label.style),
      textDirection: config.textDirection,
      position: (Size text) => anchor - Offset(text.width / 2, text.height / 2),
    );
  }

  /// Where the value text is centered: the gauge's center, or below the
  /// needle's hub when a needle is drawn, so the needle doesn't cover it.
  Offset _valueAnchor(_Geometry g) => config.showNeedle && config.needle != null
      ? g.center + Offset(0, g.radius * 0.45)
      : g.center;

  void _drawValueAtCenter(Canvas canvas, Offset center) {
    paintText(
      canvas,
      text: formatGaugeValue(config.scale.clamp(value.value)),
      style: config.valueStyle,
      textDirection: config.textDirection,
      position: (Size text) => center - Offset(text.width / 2, text.height / 2),
    );
  }

  void _drawNeedle(
    Canvas canvas,
    Size size,
    _Geometry g,
    double needleValue,
    GxRadialNeedle needle,
  ) {
    final double angle = g.angleOf(needleValue);
    final Color color = needle.color ?? config.needleColor;
    final double half = config.style.thickness / 2;
    final double top = needle.topOffset ?? 0;
    final double tipDistance = switch (needle.alignment) {
      GxRadialElementAlignment.start => top + g.radius + half,
      GxRadialElementAlignment.end => top + g.radius - half,
      GxRadialElementAlignment.center => g.radius,
    };
    final double baseDistance =
        (needle.bottomOffset != null ? -needle.bottomOffset! : 1) - 1.5;
    final Offset base = g.pointAt(angle, baseDistance);
    final Offset tip = g.pointAt(angle, tipDistance);
    final Shader? shader = needle.gradient?.createShader(
      Rect.fromLTWH(0, 0, size.width, needle.thickness),
    );

    switch (needle.shape) {
      case GxRadialNeedleShape.line:
        canvas.drawLine(
          base,
          tip,
          Paint()
            ..color = color
            ..strokeWidth = needle.thickness
            ..style = PaintingStyle.stroke
            ..strokeCap = needle.strokeCap
            ..shader = shader,
        );
      case GxRadialNeedleShape.taperedLine:
        final Offset side = Offset(
          -math.sin(angle) * needle.thickness / 2,
          math.cos(angle) * needle.thickness / 2,
        );
        canvas.drawPath(
          Path()
            ..moveTo(base.dx, base.dy)
            ..lineTo(g.center.dx + side.dx, g.center.dy + side.dy)
            ..lineTo(tip.dx, tip.dy)
            ..lineTo(g.center.dx - side.dx, g.center.dy - side.dy)
            ..close(),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill
            ..shader = shader,
        );
    }

    final GxNeedleCap cap = needle.cap;
    canvas.drawCircle(
      g.center,
      cap.radius,
      Paint()
        ..color = cap.color ?? color
        ..strokeWidth = cap.strokeWidth
        ..style = cap.paintingStyle,
    );
    // An outlined cap is filled so the needle's base doesn't show through.
    if (cap.paintingStyle == PaintingStyle.stroke) {
      canvas.drawCircle(
        g.center,
        cap.radius - cap.strokeWidth / 2,
        Paint()
          ..color = cap.innerColor ?? config.capInnerColor
          ..style = PaintingStyle.fill,
      );
      if (config.showValueAtCenter) {
        _drawValueAtCenter(canvas, _valueAnchor(g));
      }
    }
  }

  void _drawPointers(Canvas canvas, Size size, _Geometry g) {
    final double thickness = config.style.thickness;
    for (final GxRadialPointer pointer in config.pointers) {
      final GxRadialNeedle? needle = pointer.needle;
      if (needle != null && pointer.showNeedle) {
        _drawNeedle(canvas, size, g, pointer.value, needle);
      }
      if (!pointer.showPointer) {
        continue;
      }

      final double angle = g.angleOf(pointer.value);
      final double distance =
          g.radius +
          switch (pointer.alignment) {
            GxRadialElementAlignment.start => thickness / 2,
            GxRadialElementAlignment.end => -thickness,
            GxRadialElementAlignment.center => 0,
          };
      final GxRadialPointerStyle style = pointer.style;
      final Paint paint = Paint()
        ..color = style.color ?? config.pointerColor
        ..strokeWidth = style.thickness
        ..style = style.paintingStyle;

      switch (pointer.shape) {
        case GxRadialPointerShape.circle:
          canvas.drawCircle(g.pointAt(angle, distance), style.size, paint);
        case GxRadialPointerShape.triangle:
          final Offset p1 = g.pointAt(angle, distance);
          final Offset p2 = g.pointAt(angle + 0.1, distance + style.size);
          final Offset p3 = g.pointAt(angle - 0.1, distance + style.size);
          canvas.drawPath(
            Path()
              ..moveTo(p1.dx, p1.dy)
              ..lineTo(p2.dx, p2.dy)
              ..lineTo(p3.dx, p3.dy)
              ..close(),
            paint,
          );
      }
    }
  }
}

/// Center, radius and the value→angle mapping for one paint pass.
class _Geometry {
  const _Geometry({
    required this.center,
    required this.radius,
    required this.startAngle,
    required this.sweepAngle,
    required this.scale,
  });

  final Offset center;
  final double radius;
  final double startAngle;
  final double sweepAngle;
  final GaugeScale scale;

  double angleOf(double value) =>
      startAngle + scale.fractionOf(value) * sweepAngle;

  Offset pointAt(double angle, double distance) =>
      center + Offset(math.cos(angle), math.sin(angle)) * distance;
}
