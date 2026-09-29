import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/common/models/gauge_label.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/linear_frame.dart';
import 'package:gx_gauge/src/core/painter_config.dart';
import 'package:gx_gauge/src/core/text_utils.dart';
import 'package:gx_gauge/src/linear/models/linear_bar_pointer.dart';
import 'package:gx_gauge/src/linear/models/linear_needle.dart';
import 'package:gx_gauge/src/linear/models/linear_scale_models.dart';
import 'package:gx_gauge/src/linear/utils/linear_bar_utils.dart';
import 'package:gx_gauge/src/linear/utils/needle_utils.dart';

/// Everything [ScaleLinearGaugePainter] draws with, with theme defaults
/// already resolved.
class ScalePainterConfig extends PainterConfig {
  /// Creates a scale painter configuration.
  const ScalePainterConfig({
    required this.scale,
    required this.interval,
    required this.axisSpaceExtent,
    required this.axisStyle,
    required this.axisColor,
    required this.majorTickStyle,
    required this.minorTickStyle,
    required this.tickColor,
    required this.minorTicksPerInterval,
    required this.labelStyle,
    required this.labelPosition,
    required this.tickPosition,
    required this.showMajorTicks,
    required this.showMinorTicks,
    required this.showAxisTrack,
    required this.showAxisLabel,
    required this.needleColor,
    required this.barColor,
    required this.barLabelStyle,
    required this.barOffset,
    required this.applyBarColorOnAxisTick,
    required this.reversed,
    required this.textDirection,
    this.labelFormatter,
    this.labelStyler,
    this.majorTickStyler,
    this.needle,
    this.needlePainter,
    this.markers = const <GxLinearMarkerPointer>[],
    this.ranges = const <GxLinearRange>[],
    this.bars = const <GxLinearBarPointer>[],
    this.barHeight,
    this.vertical = false,
  });

  /// The value range.
  final GaugeScale scale;

  /// Major tick step, or null for a tenth of the range.
  final double? interval;

  /// Horizontal inset of the axis from both edges.
  final double axisSpaceExtent;

  /// Axis line style.
  final GxLinearAxisStyle axisStyle;

  /// Resolved axis color.
  final Color axisColor;

  /// Major tick style.
  final GxLinearTickStyle majorTickStyle;

  /// Minor tick style.
  final GxLinearTickStyle minorTickStyle;

  /// Resolved fallback tick color.
  final Color tickColor;

  /// Minor ticks between two major ticks.
  final int minorTicksPerInterval;

  /// Resolved base style for tick labels.
  final TextStyle labelStyle;

  /// Labels above or below the ticks.
  final GxLabelPosition labelPosition;

  /// Tick placement relative to the axis.
  final GxElementPosition tickPosition;

  /// Whether major ticks are drawn.
  final bool showMajorTicks;

  /// Whether minor ticks are drawn.
  final bool showMinorTicks;

  /// Whether the axis line is drawn.
  final bool showAxisTrack;

  /// Whether tick labels are drawn.
  final bool showAxisLabel;

  /// Resolved needle color.
  final Color needleColor;

  /// Resolved fallback bar color.
  final Color barColor;

  /// Base style for bar labels.
  final TextStyle barLabelStyle;

  /// Gap between the axis and the bars.
  final double barOffset;

  /// Whether ticks take the color of the bar they fall on.
  final bool applyBarColorOnAxisTick;

  /// Whether the scale runs right to left.
  final bool reversed;

  /// Direction for text.
  final TextDirection textDirection;

  /// Formats tick labels.
  final GxValueLabelFormatter? labelFormatter;

  /// Styles tick labels per value.
  final GxValueLabelStyler<TextStyle>? labelStyler;

  /// Styles major ticks per value.
  final GxValueTickStyler<GxLinearTickStyle>? majorTickStyler;

  /// The value needle.
  final GxLinearNeedle? needle;

  /// Draws custom needles (the value needle and marker needles).
  final GxNeedlePainter? needlePainter;

  /// Extra needles.
  final List<GxLinearMarkerPointer> markers;

  /// Colored bands along the axis.
  final List<GxLinearRange> ranges;

  /// Bars along the axis.
  final List<GxLinearBarPointer> bars;

  /// Bar height, or null for half the gauge's height.
  final double? barHeight;

  /// Whether the gauge is drawn bottom-to-top.
  final bool vertical;

  @override
  List<Object?> get props => <Object?>[
    scale,
    interval,
    axisSpaceExtent,
    axisStyle,
    axisColor,
    majorTickStyle,
    minorTickStyle,
    tickColor,
    minorTicksPerInterval,
    labelStyle,
    labelPosition,
    tickPosition,
    showMajorTicks,
    showMinorTicks,
    showAxisTrack,
    showAxisLabel,
    needleColor,
    barColor,
    barLabelStyle,
    barOffset,
    applyBarColorOnAxisTick,
    reversed,
    textDirection,
    labelFormatter,
    labelStyler,
    majorTickStyler,
    needle,
    needlePainter,
    markers,
    ranges,
    bars,
    barHeight,
    vertical,
  ];
}

/// Paints a linear scale gauge.
class ScaleLinearGaugePainter extends CustomPainter {
  /// Creates a painter that repaints whenever [value] ticks.
  ScaleLinearGaugePainter({required this.config, required this.value})
    : super(repaint: value);

  /// What to draw.
  final ScalePainterConfig config;

  /// The current (animated) value.
  final Animation<double> value;

  /// The axis track for a gauge of logical [size].
  static LinearTrack trackFor(ScalePainterConfig config, Size size) =>
      LinearTrack(
        start: config.axisSpaceExtent,
        end: size.width - config.axisSpaceExtent,
        reversed: config.reversed,
      );

  @override
  void paint(Canvas canvas, Size screenSize) {
    final ScalePainterConfig c = config;
    final LinearFrame frame = LinearFrame(screenSize, vertical: c.vertical);
    final Size size = frame.logicalSize;
    canvas.save();
    frame.apply(canvas);

    final double centerY = size.height / 2;
    final LinearTrack track = trackFor(c, size);
    if (c.showAxisTrack && !c.applyBarColorOnAxisTick) {
      canvas.drawLine(
        Offset(track.start, centerY),
        Offset(track.end, centerY),
        Paint()
          ..color = c.axisStyle.color ?? c.axisColor
          ..strokeWidth = c.axisStyle.thickness
          ..style = c.axisStyle.paintingStyle
          ..strokeCap = c.axisStyle.strokeCap,
      );
    }
    _drawRanges(canvas, track, centerY);
    _drawBars(canvas, size, track, centerY);
    _drawTicksAndLabels(canvas, track, centerY);
    _drawMarkers(canvas, size, track);
    _drawNeedle(canvas, size, track);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ScaleLinearGaugePainter oldDelegate) =>
      oldDelegate.config != config || oldDelegate.value != value;

  double _x(LinearTrack track, double value) =>
      track.xOf(config.scale.fractionOf(value));

  void _drawRanges(Canvas canvas, LinearTrack track, double centerY) {
    final ScalePainterConfig c = config;
    final double axisHalf = c.axisStyle.thickness / 2;
    for (final GxLinearRange range in c.ranges) {
      final double x1 = _x(track, range.start);
      final double x2 = _x(track, range.end);
      final double thickness = range.thickness ?? c.axisStyle.thickness;
      final double top = switch (range.position) {
        GxElementPosition.inside => centerY + axisHalf + range.offset,
        GxElementPosition.outside =>
          centerY - axisHalf - range.offset - thickness,
        _ => centerY - thickness / 2,
      };
      final Rect rect = Rect.fromLTRB(
        math.min(x1, x2),
        top,
        math.max(x1, x2),
        top + thickness,
      );
      if (rect.width <= 0) {
        continue;
      }
      LinearBarUtils.paintBand(
        canvas,
        rect: rect,
        color: range.color ?? c.barColor,
        radius: range.radius,
        shaderCallback: range.shaderCallback,
        borderColor: range.borderColor,
        borderWidth: range.borderWidth,
      );

      final GxGaugeLabel? label = range.label;
      if (label != null) {
        final bool below = range.position == GxElementPosition.inside;
        paintText(
          canvas,
          text: label.label,
          style: c.barLabelStyle.merge(label.style),
          textDirection: c.textDirection,
          upright: c.vertical,
          position: (Size text) =>
              Offset(
                rect.center.dx - text.width / 2,
                below ? rect.bottom + 2 : rect.top - 2 - text.height,
              ) +
              (label.offset ?? Offset.zero),
        );
      }
    }
  }

  /// Where [bar] sits across the axis. Without an explicit `position`, bars
  /// sit on the opposite side of the axis from the ticks (centered for
  /// [GxElementPosition.cross]).
  BarPlacement _placeBar(GxLinearBarPointer bar, Size size, double centerY) {
    final ScalePainterConfig c = config;
    final double height = bar.thickness ?? c.barHeight ?? size.height / 2;
    final GxElementPosition? explicit = bar.position;
    if (explicit != null) {
      final double axisHalf = c.axisStyle.thickness / 2;
      return switch (explicit) {
        GxElementPosition.inside => (
          top: centerY + axisHalf + bar.offset,
          height: height,
        ),
        GxElementPosition.outside => (
          top: centerY - axisHalf - bar.offset - height,
          height: height,
        ),
        _ => (top: centerY - height / 2, height: height),
      };
    }
    final double offset =
        (c.applyBarColorOnAxisTick ? -1 : c.barOffset) + bar.offset;
    final double top = switch (c.tickPosition) {
      GxElementPosition.inside => centerY - height - offset,
      GxElementPosition.outside => centerY + offset,
      _ => centerY - height / 2,
    };
    return (top: top, height: height);
  }

  void _drawBars(Canvas canvas, Size size, LinearTrack track, double centerY) {
    final ScalePainterConfig c = config;
    if (c.bars.isEmpty) {
      return;
    }
    LinearBarUtils.drawBars(
      canvas: canvas,
      scale: c.scale,
      track: track,
      bars: c.bars,
      place: (GxLinearBarPointer bar) => _placeBar(bar, size, centerY),
      color: c.barColor,
      labelStyle: c.barLabelStyle,
      textDirection: c.textDirection,
      upright: c.vertical,
    );
  }

  void _drawTicksAndLabels(Canvas canvas, LinearTrack track, double centerY) {
    final ScalePainterConfig c = config;
    final List<double> ticks = c.scale.ticks(c.interval);
    final double axisHalf = c.axisStyle.thickness / 2;
    final bool colorFromBars = c.applyBarColorOnAxisTick && c.bars.isNotEmpty;

    for (int i = 0; i < ticks.length; i++) {
      final double tick = ticks[i];
      final double x = _x(track, tick);

      GxLinearTickStyle major = c.majorTickStyle;
      if (colorFromBars) {
        major = _barTickStyle(major, tick);
      } else if (c.majorTickStyler != null) {
        major = c.majorTickStyler!(tick, i);
      }

      // Cross by default; one side of the axis for the other positions.
      double top = centerY - major.length / 2;
      double bottom = centerY + major.length / 2;
      final bool below = switch (c.tickPosition) {
        GxElementPosition.inside => true,
        GxElementPosition.outside => false,
        GxElementPosition.inAndOut => i.isEven,
        GxElementPosition.outAndIn => i.isOdd,
        GxElementPosition.cross => false,
      };
      if (c.tickPosition != GxElementPosition.cross) {
        if (below) {
          top = centerY + axisHalf;
        } else {
          bottom = centerY - axisHalf;
        }
      }

      if (c.showMajorTicks) {
        canvas.drawLine(
          Offset(x, top),
          Offset(x, bottom),
          Paint()
            ..color = major.color ?? c.tickColor
            ..strokeWidth = major.thickness,
        );
      }

      if (c.showMinorTicks &&
          c.minorTicksPerInterval > 0 &&
          i < ticks.length - 1) {
        _drawMinorTicks(
          canvas,
          track,
          centerY,
          tick,
          ticks[i + 1],
          colorFromBars,
        );
      }

      if (c.showAxisLabel) {
        final bool onTop =
            c.labelPosition == GxLabelPosition.topCenter ||
            (c.tickPosition == GxElementPosition.inAndOut && i.isOdd) ||
            (c.tickPosition == GxElementPosition.outAndIn && i.isEven);
        final TextStyle style = c.labelStyler == null
            ? c.labelStyle
            : c.labelStyle.merge(c.labelStyler!(tick, i));
        paintText(
          canvas,
          text: c.labelFormatter?.call(tick, i) ?? formatGaugeValue(tick),
          style: style,
          textDirection: c.textDirection,
          upright: c.vertical,
          position: (Size text) => Offset(
            x - text.width / 2,
            onTop
                ? centerY - c.majorTickStyle.length / 2 - 4 - text.height
                : centerY + c.majorTickStyle.length / 2 + 4,
          ),
        );
      }
    }
  }

  void _drawMinorTicks(
    Canvas canvas,
    LinearTrack track,
    double centerY,
    double from,
    double to,
    bool colorFromBars,
  ) {
    final ScalePainterConfig c = config;
    final double axisHalf = c.axisStyle.thickness / 2;
    double top = centerY - c.minorTickStyle.length / 2;
    double bottom = centerY + c.minorTickStyle.length / 2;
    if (c.tickPosition == GxElementPosition.inside) {
      top = centerY + axisHalf;
    } else if (c.tickPosition == GxElementPosition.outside) {
      bottom = centerY - axisHalf;
    }

    final int count = c.minorTicksPerInterval;
    for (int j = 1; j <= count; j++) {
      final double value = from + (to - from) * j / (count + 1);
      final double x = _x(track, value);
      final GxLinearTickStyle style = colorFromBars
          ? _barTickStyle(c.minorTickStyle, value)
          : c.minorTickStyle;
      canvas.drawLine(
        Offset(x, top),
        Offset(x, bottom),
        Paint()
          ..color = style.color ?? c.tickColor
          ..strokeWidth = style.thickness,
      );
    }
  }

  /// [style] recolored with the bar that covers [value], if any.
  GxLinearTickStyle _barTickStyle(GxLinearTickStyle style, double value) {
    for (final GxLinearBarPointer bar in config.bars) {
      if (value >= bar.start && value <= bar.end) {
        return style.copyWith(color: bar.color ?? config.barColor);
      }
    }
    return style;
  }

  /// Runs [draw] with the canvas moved to the axis band, and returns the
  /// band's size, so needle positions (top/center/bottom) are relative to
  /// the axis rather than to the whole gauge.
  void _onAxis(Canvas canvas, Size size, void Function(Size band) draw) {
    final double thickness = config.axisStyle.thickness;
    canvas
      ..save()
      ..translate(0, size.height / 2 - thickness / 2);
    draw(Size(size.width, thickness));
    canvas.restore();
  }

  void _drawMarkers(Canvas canvas, Size size, LinearTrack track) {
    _onAxis(
      canvas,
      size,
      (Size band) => _drawMarkerNeedles(canvas, band, track),
    );
  }

  void _drawMarkerNeedles(Canvas canvas, Size size, LinearTrack track) {
    for (final GxLinearMarkerPointer marker in config.markers) {
      final GxLinearNeedle? needle = marker.needle;
      if (needle == null || !needle.enabled) {
        continue;
      }
      NeedleUtils.drawIt(
        canvas: canvas,
        size: size,
        x: _x(track, marker.value),
        needle: needle,
        thickness: needle.offset,
        color: needle.color ?? config.needleColor,
        dense: true,
        needlePainter: config.needlePainter,
        valueText: formatGaugeValue(marker.value),
        labelStyle: config.labelStyle,
        textDirection: config.textDirection,
        upright: config.vertical,
      );
    }
  }

  void _drawNeedle(Canvas canvas, Size size, LinearTrack track) {
    final GxLinearNeedle? needle = config.needle;
    if (needle == null || !needle.enabled) {
      return;
    }
    _onAxis(
      canvas,
      size,
      (Size band) => NeedleUtils.drawIt(
        canvas: canvas,
        size: band,
        x: _x(track, value.value),
        needle: needle,
        thickness: math.sqrt(
          math.pow(needle.size.width, 2) + math.pow(needle.size.height, 2),
        ),
        color: needle.color ?? config.needleColor,
        needlePainter: config.needlePainter,
        valueText: formatGaugeValue(config.scale.clamp(value.value)),
        labelStyle: config.labelStyle,
        textDirection: config.textDirection,
        upright: config.vertical,
      ),
    );
  }
}
