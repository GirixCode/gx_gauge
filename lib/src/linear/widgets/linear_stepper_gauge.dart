import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/core/gauge_defaults.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/gauge_widgets.dart';
import 'package:gx_gauge/src/core/linear_frame.dart';
import 'package:gx_gauge/src/linear/models/linear_progress_style.dart';
import 'package:gx_gauge/src/linear/models/stepper_step.dart';
import 'package:gx_gauge/src/linear/painters/stepper_linear_painter.dart';
import 'package:gx_gauge/src/linear/utils/color_utils.dart';

/// A track of evenly spaced steps, with a progress line up to
/// [currentStep].
///
/// Takes the full available width (or height, when vertical).
///
/// ```dart
/// GxLinearStepperGauge(
///   currentStep: 1,
///   steps: const <GxStepperStep>[
///     GxStepperStep(label: GxGaugeLabel(label: 'Ordered')),
///     GxStepperStep(label: GxGaugeLabel(label: 'Shipped')),
///     GxStepperStep(label: GxGaugeLabel(label: 'Delivered')),
///   ],
///   onStepTapped: (int step) => setState(() => _step = step),
/// )
/// ```
class GxLinearStepperGauge extends ImplicitlyAnimatedWidget {
  /// Creates a linear stepper gauge.
  const GxLinearStepperGauge({
    super.key,
    required this.currentStep,
    required this.steps,
    this.style = const GxLinearProgressStyle(thickness: 5),
    this.height = 50,
    this.shape = GxStepperShape.circle,
    this.shapeSize = 20,
    this.offset = 10,
    this.activeStyle,
    this.inactiveStyle,
    this.reverse = false,
    this.direction = Axis.horizontal,
    this.onStepTapped,
    this.semanticLabel,
    super.duration = Duration.zero,
    super.curve = Curves.easeInOut,
    super.onEnd,
  });

  /// The 0-based index of the current step. Steps up to and including it are
  /// drawn as reached. Values below 0 mean no step is reached; values past
  /// the last step clamp to it.
  final int currentStep;

  /// The steps, from first to last.
  final List<GxStepperStep> steps;

  /// Line color and thickness. `style.backgroundColor` colors the track and
  /// the steps not yet reached.
  final GxLinearProgressStyle style;

  /// The gauge's thickness across the track, including the labels (its
  /// height when horizontal). Defaults to 50.
  final double height;

  /// The step marker shape. Defaults to [GxStepperShape.circle].
  final GxStepperShape shape;

  /// The step marker size. Defaults to 20.
  final double shapeSize;

  /// Distance between the track and the step labels. Defaults to 10.
  final double offset;

  /// Style of the markers' text in reached steps, merged onto the theme's
  /// label style in `onPrimary`.
  final TextStyle? activeStyle;

  /// Style of the markers' text in steps not yet reached, merged onto the
  /// theme's label style in `onSurface`.
  final TextStyle? inactiveStyle;

  /// Runs from the end instead of the start. In a right-to-left locale a
  /// horizontal gauge already runs from the right, and [reverse] flips it
  /// back.
  final bool reverse;

  /// The track's direction. Vertical steppers run bottom to top. Defaults to
  /// [Axis.horizontal].
  final Axis direction;

  /// Called with the index of the step nearest to a tap or drag. Null (the default)
  /// keeps the gauge read-only.
  final ValueChanged<int>? onStepTapped;

  /// Describes the gauge to screen readers. The value is announced as
  /// "Step N of M".
  final String? semanticLabel;

  @override
  AnimatedGaugeState<GxLinearStepperGauge> createState() =>
      _GxLinearStepperGaugeState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('currentStep', currentStep))
      ..add(IntProperty('steps', steps.length))
      ..add(EnumProperty<GxStepperShape>('shape', shape))
      ..add(FlagProperty('reverse', value: reverse, ifTrue: 'reversed'))
      ..add(
        EnumProperty<Axis>(
          'direction',
          direction,
          defaultValue: Axis.horizontal,
        ),
      )
      ..add(
        ObjectFlagProperty<ValueChanged<int>>.has('onStepTapped', onStepTapped),
      )
      ..add(StringProperty('semanticLabel', semanticLabel, defaultValue: null));
  }
}

class _GxLinearStepperGaugeState
    extends AnimatedGaugeState<GxLinearStepperGauge> {
  int get _clampedStep => widget.steps.isEmpty
      ? -1
      : widget.currentStep.clamp(-1, widget.steps.length - 1);

  @override
  double get targetValue => _clampedStep.toDouble();

  @override
  Widget build(BuildContext context) {
    final GxLinearStepperGauge w = widget;
    final GaugeDefaults defaults = GaugeDefaults.of(context);
    final TextDirection direction =
        Directionality.maybeOf(context) ?? TextDirection.ltr;
    final Color color = w.style.color ?? defaults.primary;
    final bool vertical = w.direction == Axis.vertical;

    final StepperPainterConfig config = StepperPainterConfig(
      steps: w.steps,
      style: w.style,
      color: color,
      trackColor: w.style.backgroundColor ?? color.withValues(alpha: 0.2),
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
      reversed: linearReversed(context, w.direction, w.reverse),
      textDirection: direction,
      vertical: vertical,
    );

    final int count = w.steps.length;
    final ValueChanged<int>? onStepTapped = w.onStepTapped;
    return gaugeSemantics(
      label: w.semanticLabel,
      value: count == 0 ? '' : 'Step ${_clampedStep + 1} of $count',
      child: LinearGaugeBox(
        direction: w.direction,
        thickness: w.height,
        child: GaugeInteraction(
          dragAxis: w.direction,
          onChanged: onStepTapped == null || count == 0
              ? null
              : (double step) => onStepTapped(step.round()),
          valueAt: (Offset position, Size size) {
            final LinearFrame frame = LinearFrame(size, vertical: vertical);
            final LinearTrack track = StepperLinearPainter.trackFor(
              config,
              frame.logicalSize,
            );
            final double fraction = track.fractionAt(
              frame.toLogical(position).dx,
            );
            return count > 1 ? fraction * (count - 1) : 0;
          },
          child: CustomPaint(
            painter: StepperLinearPainter(
              value: valueAnimation,
              config: config,
            ),
          ),
        ),
      ),
    );
  }
}
