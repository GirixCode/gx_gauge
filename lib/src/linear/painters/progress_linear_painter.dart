import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:gx_gauge/src/common/models/gauge_label.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/linear_frame.dart';
import 'package:gx_gauge/src/core/painter_config.dart';
import 'package:gx_gauge/src/core/text_utils.dart';
import 'package:gx_gauge/src/linear/models/linear_needle.dart';
import 'package:gx_gauge/src/linear/models/linear_progress_style.dart';
import 'package:gx_gauge/src/linear/utils/needle_utils.dart';

/// Everything [ProgressLinearPainter] draws with, with theme defaults
/// already resolved.
class ProgressPainterConfig extends PainterConfig {
  /// Creates a progress painter configuration.
  const ProgressPainterConfig({
    required this.scale,
    required this.style,
    required this.color,
    required this.backgroundColor,
    required this.reversed,
    required this.textDirection,
    required this.labelStyle,
    required this.needleColor,
    this.needle,
    this.needlePainter,
    this.label,
    this.showLabel = false,
    this.vertical = false,
  });

  /// The value range.
  final GaugeScale scale;

  /// Track shape and sizing.
  final GxLinearProgressStyle style;

  /// Resolved progress color.
  final Color color;

  /// Resolved track color.
  final Color backgroundColor;

  /// Whether progress fills from the right.
  final bool reversed;

  /// Direction for text and `start`/`end` alignment.
  final TextDirection textDirection;

  /// Base style that the label's style merges onto.
  final TextStyle labelStyle;

  /// Resolved needle color.
  final Color needleColor;

  /// The optional needle.
  final GxLinearNeedle? needle;

  /// Draws a custom needle.
  final GxNeedlePainter? needlePainter;

  /// The optional label.
  final GxGaugeLabel? label;

  /// Whether [label] is drawn.
  final bool showLabel;

  /// Whether the gauge is drawn bottom-to-top.
  final bool vertical;

  @override
  List<Object?> get props => <Object?>[
    scale,
    style,
    color,
    backgroundColor,
    reversed,
    textDirection,
    labelStyle,
    needleColor,
    needle,
    needlePainter,
    label,
    showLabel,
    vertical,
  ];
}

/// Paints a linear progress gauge.
class ProgressLinearPainter extends CustomPainter {
  /// Creates a painter that repaints whenever [value] ticks.
  ProgressLinearPainter({required this.config, required this.value})
    : super(repaint: value);

  /// What to draw.
  final ProgressPainterConfig config;

  /// The current (animated) value.
  final Animation<double> value;

  @override
  void paint(Canvas canvas, Size screenSize) {
    final LinearFrame frame = LinearFrame(
      screenSize,
      vertical: config.vertical,
    );
    final Size size = frame.logicalSize;
    canvas.save();
    frame.apply(canvas);
    final double fraction = config.scale.fractionOf(value.value);
    final LinearTrack track = LinearTrack(
      start: 0,
      end: size.width,
      reversed: config.reversed,
    );
    _drawGauge(canvas, size, track, fraction);
    _drawNeedle(canvas, size, track.xOf(fraction));
    _drawLabel(canvas, size);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ProgressLinearPainter oldDelegate) =>
      oldDelegate.config != config || oldDelegate.value != value;

  void _drawGauge(
    Canvas canvas,
    Size size,
    LinearTrack track,
    double fraction,
  ) {
    final GxLinearProgressStyle style = config.style;
    final Paint background = Paint()
      ..color = config.backgroundColor
      ..style = style.paintingStyle
      ..strokeWidth = style.thickness
      ..strokeCap = style.strokeCap;
    final Paint foreground = Paint()
      ..color = config.color
      ..style = PaintingStyle.fill
      ..strokeWidth = style.thickness
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = style.strokeCap;

    final double centerY = size.height / 2;
    final double x0 = track.xOf(0);
    final double x = track.xOf(fraction);

    if (style.dense) {
      canvas
        ..drawLine(Offset(0, centerY), Offset(size.width, centerY), background)
        ..drawLine(Offset(x0, centerY), Offset(x, centerY), foreground);
      return;
    }

    final Radius radius = style.radius ?? Radius.zero;
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(Offset.zero & size, radius),
        background,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(x0 < x ? x0 : x, 0, x0 < x ? x : x0, size.height),
          radius,
        ),
        foreground,
      );
  }

  void _drawNeedle(Canvas canvas, Size size, double x) {
    final GxLinearNeedle? needle = config.needle;
    if (needle == null || !needle.enabled) {
      return;
    }
    NeedleUtils.drawIt(
      canvas: canvas,
      size: size,
      x: x,
      needle: needle,
      thickness: config.style.thickness,
      color: needle.color ?? config.needleColor,
      dense: config.style.dense,
      needlePainter: config.needlePainter,
      valueText: formatGaugeValue(config.scale.clamp(value.value)),
      labelStyle: config.labelStyle,
      textDirection: config.textDirection,
      upright: config.vertical,
    );
  }

  void _drawLabel(Canvas canvas, Size size) {
    final GxGaugeLabel? label = config.label;
    if (label == null || !config.showLabel) {
      return;
    }
    final String value = formatGaugeValue(config.scale.clamp(this.value.value));
    final TextAlign align = resolveTextAlign(
      label.textAlign,
      config.textDirection,
    );
    paintText(
      canvas,
      text: label.label.replaceAll('{value}', value),
      style: config.labelStyle.merge(label.style),
      textDirection: config.textDirection,
      textAlign: align,
      upright: config.vertical,
      position: (Size text) {
        final Offset offset = label.offset ?? Offset.zero;
        final double x = switch (align) {
          TextAlign.right =>
            size.width - text.width + offset.dx - label.spaceExtent,
          TextAlign.left => offset.dx + label.spaceExtent,
          _ => size.width / 2 - text.width / 2 + offset.dx,
        };
        return Offset(x, size.height / 2 - text.height / 2 + offset.dy);
      },
    );
  }
}
