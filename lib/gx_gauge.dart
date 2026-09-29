/// Customizable linear and radial gauges for Flutter.
///
/// Widgets: `GxLinearProgressGauge`, `GxLinearStepperGauge`,
/// `GxLinearScaleGauge`, `GxLinearBarGauge` and `GxRadialGauge`.
///
/// Everything under `lib/src/` that isn't exported here, such as painters and
/// geometry helpers, is an implementation detail and may change at any time.
// The library name works around a dartdoc 9.0.x stack overflow that occurs
// when this barrel uses an unnamed `library;` directive. Remove the name once
// dartdoc is fixed (tracked in docs/PLAN.md, Phase 2).
// ignore: unnecessary_library_name
library gx_gauge;

// Shared value, label, tooltip and bar models.
export 'src/common/animations/animation_types.dart' show GxAnimationType;
export 'src/common/models/enums.dart'
    show
        GxElementPosition,
        GxLabelPosition,
        GxNeedlePosition,
        GxNeedleShape,
        GxRadialElementAlignment,
        GxRadialElementPosition,
        GxRadialNeedleShape,
        GxRadialPointerShape,
        GxStepperShape,
        GxTooltipPosition,
        GxTooltipType;
export 'src/common/models/linear_gauge_common_model.dart'
    show GxGaugeLabel, GxGaugeTooltip, GxGaugeValue, GxLinearBarPointer;
export 'src/common/utils/typedef.dart'
    show
        GxNeedlePainter,
        GxValueLabelFormatter,
        GxValueLabelStyler,
        GxValueTickStyler;
// Linear gauges.
export 'src/linear/models/linear_gauge_style.dart' show GxLinearProgressStyle;
export 'src/linear/models/linear_needle_model.dart'
    show GxLinearNeedle, GxNeedleLabel;
export 'src/linear/models/scale_linear_gauge_model.dart'
    show
        GxLinearAxisStyle,
        GxLinearFillArea,
        GxLinearMarkerPointer,
        GxLinearTickStyle;
export 'src/linear/models/stepper_linear_gauge_model.dart' show GxStepperStep;
export 'src/linear/widgets/animated_linear_progress_gauge.dart'
    show GxAnimatedLinearProgressGauge;
export 'src/linear/widgets/linear_bar_gauge.dart' show GxLinearBarGauge;
export 'src/linear/widgets/linear_progress_gauge.dart'
    show GxLinearProgressGauge;
export 'src/linear/widgets/linear_scale_gauge.dart' show GxLinearScaleGauge;
export 'src/linear/widgets/linear_stepper_gauge.dart' show GxLinearStepperGauge;
// Radial gauge.
export 'src/radial/models/radial_gauge_style.dart'
    show
        GxNeedleCap,
        GxRadialGaugeStyle,
        GxRadialNeedle,
        GxRadialPointer,
        GxRadialPointerStyle,
        GxRadialRange,
        GxRadialTickLabelStyle,
        GxRadialTickStyle;
export 'src/radial/widgets/radial_gauge.dart' show GxRadialGauge;
