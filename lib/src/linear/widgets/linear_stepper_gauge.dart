import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/common/models/gauge_value.dart';
import 'package:gx_gauge/src/core/gauge_defaults.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/gauge_widgets.dart';
import 'package:gx_gauge/src/core/semantics.dart';
import 'package:gx_gauge/src/linear/models/linear_progress_style.dart';
import 'package:gx_gauge/src/linear/models/stepper_step.dart';
import 'package:gx_gauge/src/linear/painters/stepper_linear_painter.dart';
import 'package:gx_gauge/src/linear/utils/color_utils.dart';

/// A horizontal track of evenly spaced steps with a progress line.
///
/// A step counts as reached once the progress line gets to it. Takes the full
/// available width.
///
/// ```dart
/// GxLinearStepperGauge(
///   value: const GxGaugeValue(value: 50),
///   steps: const <GxStepperStep>[
///     GxStepperStep(label: GxGaugeLabel(label: 'Ordered')),
///     GxStepperStep(label: GxGaugeLabel(label: 'Shipped')),
///     GxStepperStep(label: GxGaugeLabel(label: 'Delivered')),
///   ],
/// )
/// ```
class GxLinearStepperGauge extends ImplicitlyAnimatedWidget {
  /// Creates a linear stepper gauge.
  const GxLinearStepperGauge({
    super.key,
    required this.value,
    required this.steps,
    this.style = const GxLinearProgressStyle(thickness: 5),
    this.height = 50,
    this.shape = GxStepperShape.circle,
    this.shapeSize = 20,
    this.offset = 10,
    this.activeStyle,
    this.inactiveStyle,
    this.reverse = false,
    this.semanticLabel,
    this.semanticValueFormatter,
    super.duration = Duration.zero,
    super.curve = Curves.easeInOut,
    super.onEnd,
  });

  /// The progress and its range.
  final GxGaugeValue value;

  /// The steps, from first to last.
  final List<GxStepperStep> steps;

  /// Line color and thickness. `style.backgroundColor` colors the track and
  /// the steps not yet reached.
  final GxLinearProgressStyle style;

  /// The gauge's height, including the labels. Defaults to 50.
  final double height;

  /// The step marker shape. Defaults to [GxStepperShape.circle].
  final GxStepperShape shape;

  /// The step marker size. Defaults to 20.
  final double shapeSize;

  /// Distance between the track and the step labels. Defaults to 10.
  final double offset;

  /// Style of the numbers in reached steps, merged onto the theme's label
  /// style in `onPrimary`.
  final TextStyle? activeStyle;

  /// Style of the numbers in steps not yet reached, merged onto the theme's
  /// label style in `onSurface`.
  final TextStyle? inactiveStyle;

  /// Runs from the end instead of the start. In a right-to-left locale the
  /// gauge already runs from the right, and [reverse] flips it back.
  final bool reverse;

  /// Describes the gauge to screen readers.
  final String? semanticLabel;

  /// Formats the value announced by screen readers.
  final GxSemanticValueFormatter? semanticValueFormatter;

  @override
  AnimatedGaugeState<GxLinearStepperGauge> createState() =>
      _GxLinearStepperGaugeState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<GxGaugeValue>('value', value))
      ..add(IntProperty('steps', steps.length))
      ..add(EnumProperty<GxStepperShape>('shape', shape))
      ..add(FlagProperty('reverse', value: reverse, ifTrue: 'reversed'))
      ..add(StringProperty('semanticLabel', semanticLabel, defaultValue: null));
  }
}

class _GxLinearStepperGaugeState
    extends AnimatedGaugeState<GxLinearStepperGauge> {
  @override
  double get targetValue => widget.value.value;

  @override
  Widget build(BuildContext context) {
    final GxLinearStepperGauge w = widget;
    final GaugeDefaults defaults = GaugeDefaults.of(context);
    final TextDirection direction =
        Directionality.maybeOf(context) ?? TextDirection.ltr;
    final Color color = w.style.color ?? defaults.primary;

    return gaugeSemantics(
      label: w.semanticLabel,
      value: semanticValue(w.semanticValueFormatter, w.value.value),
      child: LinearGaugeBox(
        height: w.height,
        child: CustomPaint(
          painter: StepperLinearPainter(
            value: valueAnimation,
            config: StepperPainterConfig(
              scale: GaugeScale(w.value.min, w.value.max),
              steps: w.steps,
              style: w.style,
              color: color,
              trackColor:
                  w.style.backgroundColor ?? color.withValues(alpha: 0.2),
              inactiveColor:
                  w.style.backgroundColor ??
                  ColorUtils.getMaterialColor(color).shade100,
              shape: w.shape,
              shapeSize: w.shapeSize,
              offset: w.offset,
              activeStyle: defaults.labelStyle
                  .copyWith(color: defaults.onPrimary)
                  .merge(w.activeStyle),
              inactiveStyle: defaults.labelStyle
                  .copyWith(color: defaults.onSurface)
                  .merge(w.inactiveStyle),
              labelStyle: defaults.labelStyle,
              reversed: (direction == TextDirection.rtl) != w.reverse,
              textDirection: direction,
            ),
          ),
        ),
      ),
    );
  }
}
