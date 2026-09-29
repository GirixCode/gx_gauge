import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:gx_gauge/src/common/models/gauge_tooltip.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/painter_config.dart';
import 'package:gx_gauge/src/linear/models/linear_bar_pointer.dart';
import 'package:gx_gauge/src/linear/models/linear_needle.dart';
import 'package:gx_gauge/src/linear/utils/linear_bar_utils.dart';
import 'package:gx_gauge/src/linear/utils/needle_utils.dart';
import 'package:gx_gauge/src/linear/utils/tooltip_utils.dart';

/// Everything [LinearBarPainter] draws with, with theme defaults already
/// resolved.
class BarPainterConfig extends PainterConfig {
  /// Creates a bar painter configuration.
  const BarPainterConfig({
    required this.scale,
    required this.bars,
    required this.barColor,
    required this.labelStyle,
    required this.needleColor,
    required this.tooltipColor,
    required this.tooltipTextColor,
    required this.reversed,
    required this.textDirection,
    this.gap = 0,
    this.needle,
    this.needlePainter,
    this.tooltip,
  });

  /// The value range.
  final GaugeScale scale;

  /// The bars, drawn in order.
  final List<GxLinearBarPointer> bars;

  /// Fallback bar color.
  final Color barColor;

  /// Base style for bar labels.
  final TextStyle labelStyle;

  /// Resolved needle color.
  final Color needleColor;

  /// Resolved tooltip bubble color.
  final Color tooltipColor;

  /// Resolved tooltip text color.
  final Color tooltipTextColor;

  /// Whether the scale runs right to left.
  final bool reversed;

  /// Direction for text.
  final TextDirection textDirection;

  /// Pixels between adjacent bars.
  final double gap;

  /// The optional needle.
  final GxLinearNeedle? needle;

  /// Draws a custom needle.
  final GxNeedlePainter? needlePainter;

  /// The optional tooltip.
  final GxGaugeTooltip? tooltip;

  @override
  List<Object?> get props => <Object?>[
    scale,
    bars,
    barColor,
    labelStyle,
    needleColor,
    tooltipColor,
    tooltipTextColor,
    reversed,
    textDirection,
    gap,
    needle,
    needlePainter,
    tooltip,
  ];
}

/// Paints a linear bar gauge.
class LinearBarPainter extends CustomPainter {
  /// Creates a painter that repaints whenever [value] ticks.
  LinearBarPainter({required this.config, required this.value})
    : super(repaint: value);

  /// What to draw.
  final BarPainterConfig config;

  /// The current (animated) value.
  final Animation<double> value;

  @override
  void paint(Canvas canvas, Size size) {
    final LinearTrack track = LinearTrack(
      start: 0,
      end: size.width,
      reversed: config.reversed,
    );
    LinearBarUtils.drawBars(
      canvas: canvas,
      scale: config.scale,
      track: track,
      bars: config.bars,
      top: 0,
      height: size.height,
      color: config.barColor,
      labelStyle: config.labelStyle,
      textDirection: config.textDirection,
      gap: config.gap,
    );

    final double x = track.xOf(config.scale.fractionOf(value.value));
    final GxLinearNeedle? needle = config.needle;
    if (needle != null && needle.enabled) {
      NeedleUtils.drawIt(
        canvas: canvas,
        size: size,
        x: x,
        needle: needle,
        thickness: needle.offset,
        color: needle.color ?? config.needleColor,
        needlePainter: config.needlePainter,
      );
    }

    final GxGaugeTooltip? tooltip = config.tooltip;
    if (tooltip != null && tooltip.enabled) {
      final String text = formatGaugeValue(config.scale.clamp(value.value));
      TooltipUtils.drawTooltip(
        canvas: canvas,
        size: size,
        x: x,
        tooltip: tooltip,
        text: tooltip.label?.replaceAll('{value}', text) ?? text,
        color: tooltip.color ?? config.tooltipColor,
        textColor: config.tooltipTextColor,
        textDirection: config.textDirection,
      );
    }
  }

  @override
  bool shouldRepaint(covariant LinearBarPainter oldDelegate) =>
      oldDelegate.config != config || oldDelegate.value != value;
}
