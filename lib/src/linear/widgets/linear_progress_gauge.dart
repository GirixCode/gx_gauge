import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/gauge_label.dart';
import 'package:gx_gauge/src/common/models/gauge_value.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/core/gauge_defaults.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/gauge_widgets.dart';
import 'package:gx_gauge/src/core/semantics.dart';
import 'package:gx_gauge/src/linear/models/linear_needle.dart';
import 'package:gx_gauge/src/linear/models/linear_progress_style.dart';
import 'package:gx_gauge/src/linear/painters/progress_linear_painter.dart';

/// A horizontal progress bar with an optional needle and label.
///
/// Takes the full available width. Set [duration] to animate value changes.
///
/// ```dart
/// GxLinearProgressGauge(
///   value: const GxGaugeValue(value: 64),
///   style: const GxLinearProgressStyle(thickness: 8),
///   label: const GxGaugeLabel(label: '{value}%'),
///   showLabel: true,
///   duration: const Duration(milliseconds: 400),
/// )
/// ```
class GxLinearProgressGauge extends ImplicitlyAnimatedWidget {
  /// Creates a linear progress gauge.
  const GxLinearProgressGauge({
    super.key,
    required this.value,
    this.style = const GxLinearProgressStyle(),
    this.label,
    this.showLabel = false,
    this.needle,
    this.needlePainter,
    this.reverse = false,
    this.height,
    this.semanticLabel,
    this.semanticValueFormatter,
    super.duration = Duration.zero,
    super.curve = Curves.easeInOut,
    super.onEnd,
  });

  /// The value and its range.
  final GxGaugeValue value;

  /// Colors and shape of the track.
  final GxLinearProgressStyle style;

  /// Text drawn on the gauge when [showLabel] is true. `{value}` is replaced
  /// with the current value.
  final GxGaugeLabel? label;

  /// Whether [label] is drawn. Defaults to false.
  final bool showLabel;

  /// An optional needle at the current value.
  final GxLinearNeedle? needle;

  /// Draws the needle when its shape is `GxNeedleShape.custom`. Pass a
  /// stable (top-level or static) function to avoid needless repaints.
  final GxNeedlePainter? needlePainter;

  /// Fills from the end instead of the start. In a right-to-left locale the
  /// gauge already fills from the right, and [reverse] flips it back.
  final bool reverse;

  /// The gauge's height. Null uses `style.thickness`.
  final double? height;

  /// Describes the gauge to screen readers, e.g. 'Download progress'.
  final String? semanticLabel;

  /// Formats the value announced by screen readers.
  final GxSemanticValueFormatter? semanticValueFormatter;

  @override
  AnimatedGaugeState<GxLinearProgressGauge> createState() =>
      _GxLinearProgressGaugeState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<GxGaugeValue>('value', value))
      ..add(DiagnosticsProperty<GxLinearProgressStyle>('style', style))
      ..add(
        DiagnosticsProperty<GxLinearNeedle>(
          'needle',
          needle,
          defaultValue: null,
        ),
      )
      ..add(FlagProperty('reverse', value: reverse, ifTrue: 'reversed'))
      ..add(DoubleProperty('height', height, defaultValue: null))
      ..add(StringProperty('semanticLabel', semanticLabel, defaultValue: null));
  }
}

class _GxLinearProgressGaugeState
    extends AnimatedGaugeState<GxLinearProgressGauge> {
  @override
  double get targetValue => widget.value.value;

  @override
  Widget build(BuildContext context) {
    final GxLinearProgressGauge w = widget;
    final GaugeDefaults defaults = GaugeDefaults.of(context);
    final TextDirection direction =
        Directionality.maybeOf(context) ?? TextDirection.ltr;
    final Color color = w.style.color ?? defaults.primary;

    return gaugeSemantics(
      label: w.semanticLabel,
      value: semanticValue(w.semanticValueFormatter, w.value.value),
      child: LinearGaugeBox(
        height: w.height ?? w.style.thickness,
        child: CustomPaint(
          painter: ProgressLinearPainter(
            value: valueAnimation,
            config: ProgressPainterConfig(
              scale: GaugeScale(w.value.min, w.value.max),
              style: w.style,
              color: color,
              backgroundColor:
                  w.style.backgroundColor ?? color.withValues(alpha: 0.2),
              reversed: (direction == TextDirection.rtl) != w.reverse,
              textDirection: direction,
              labelStyle: defaults.labelStyle,
              needleColor: defaults.needle,
              needle: w.needle,
              needlePainter: w.needlePainter,
              label: w.label,
              showLabel: w.showLabel,
            ),
          ),
        ),
      ),
    );
  }
}
