/// Customizable linear and radial gauges for Flutter.
///
/// Widgets: `GxLinearProgressGauge`, `GxLinearStepperGauge`,
/// `GxLinearScaleGauge`, `GxLinearBarGauge` and `GxRadialGauge`.
///
/// Everything under `lib/src/` that isn't exported here, such as painters and
/// geometry helpers, is an implementation detail and may change at any time.
library;

// Shared models.
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
export 'src/common/models/gauge_label.dart' show GxGaugeLabel;
export 'src/common/models/gauge_tooltip.dart' show GxGaugeTooltip;
export 'src/common/models/gauge_value.dart' show GxGaugeValue;
export 'src/common/utils/typedef.dart'
    show
        GxNeedlePainter,
        GxValueLabelFormatter,
        GxValueLabelStyler,
        GxValueTickStyler;
export 'src/core/semantics.dart' show GxSemanticValueFormatter;
// Linear gauges.
export 'src/linear/models/linear_bar_pointer.dart' show GxLinearBarPointer;
export 'src/linear/models/linear_needle.dart'
    show GxLinearNeedle, GxNeedleLabel;
export 'src/linear/models/linear_progress_style.dart'
    show GxLinearProgressStyle;
export 'src/linear/models/linear_scale_models.dart'
    show
        GxLinearAxisStyle,
        GxLinearMarkerPointer,
        GxLinearRange,
        GxLinearTickStyle;
export 'src/linear/models/stepper_step.dart' show GxStepperStep;
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
