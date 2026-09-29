import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/common/models/gauge_value.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/core/gauge_defaults.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/gauge_widgets.dart';
import 'package:gx_gauge/src/core/linear_frame.dart';
import 'package:gx_gauge/src/core/semantics.dart';
import 'package:gx_gauge/src/linear/models/linear_bar_pointer.dart';
import 'package:gx_gauge/src/linear/models/linear_needle.dart';
import 'package:gx_gauge/src/linear/models/linear_scale_models.dart';
import 'package:gx_gauge/src/linear/painters/scale_linear_gauge_painter.dart';

/// A scale with an axis, major and minor ticks, labels, and optional
/// needle, marker pointers, ranges and bars.
///
/// Takes the full available width (or height, when vertical).
///
/// ```dart
/// GxLinearScaleGauge(
///   value: const GxGaugeValue(value: 40),
///   interval: 10,
///   needle: const GxLinearNeedle(shape: GxNeedleShape.triangle),
///   ranges: const <GxLinearRange>[
///     GxLinearRange(start: 0, end: 60, color: Colors.green),
///     GxLinearRange(start: 60, end: 100, color: Colors.red),
///   ],
/// )
/// ```
class GxLinearScaleGauge extends ImplicitlyAnimatedWidget {
  /// Creates a linear scale gauge.
  const GxLinearScaleGauge({
    super.key,
    this.value = const GxGaugeValue(value: 0),
    this.interval,
    this.minorTicksPerInterval = 1,
    this.height = 100,
    this.axisSpaceExtent = 0.0,
    this.axisTrackStyle = const GxLinearAxisStyle(),
    this.axisLabelStyle,
    this.majorTickStyle = const GxLinearTickStyle(),
    this.minorTickStyle = const GxLinearTickStyle(),
    this.labelPosition = GxLabelPosition.bottomCenter,
    this.tickPosition = GxElementPosition.cross,
    this.showMajorTicks = true,
    this.showMinorTicks = true,
    this.showAxisTrack = true,
    this.showAxisLabel = true,
    this.labelFormatter,
    this.labelStyler,
    this.majorTickStyler,
    this.needle,
    this.needlePainter,
    this.markers = const <GxLinearMarkerPointer>[],
    this.ranges = const <GxLinearRange>[],
    this.bars = const <GxLinearBarPointer>[],
    this.barHeight,
    this.barOffset = 0.5,
    this.applyBarColorOnAxisTick = false,
    this.reverse = false,
    this.direction = Axis.horizontal,
    this.onChanged,
    this.onChangeEnd,
    this.semanticLabel,
    this.semanticValueFormatter,
    super.duration = Duration.zero,
    super.curve = Curves.easeInOut,
    super.onEnd,
  });

  /// The needle's value and the axis range (`value.min` to `value.max`).
  /// Defaults to 0 on a 0..100 axis.
  final GxGaugeValue value;

  /// The step between major ticks. Null uses a tenth of the range. When the
  /// range isn't a multiple of it, the last tick is the last multiple below
  /// `value.max`.
  final double? interval;

  /// Minor ticks between two major ticks. Defaults to 1.
  final int minorTicksPerInterval;

  /// The gauge's thickness across the axis, including labels and needle
  /// (its height when horizontal). Defaults to 100.
  final double height;

  /// Horizontal inset of the axis from both edges, leaving room for the first
  /// and last labels. Defaults to 0.
  final double axisSpaceExtent;

  /// The axis line.
  final GxLinearAxisStyle axisTrackStyle;

  /// Tick label style, merged onto the theme's label style.
  final TextStyle? axisLabelStyle;

  /// Major ticks.
  final GxLinearTickStyle majorTickStyle;

  /// Minor ticks.
  final GxLinearTickStyle minorTickStyle;

  /// Labels above or below the axis. Defaults to
  /// [GxLabelPosition.bottomCenter].
  final GxLabelPosition labelPosition;

  /// Where ticks sit relative to the axis. Defaults to
  /// [GxElementPosition.cross].
  final GxElementPosition tickPosition;

  /// Whether major ticks are drawn. Defaults to true.
  final bool showMajorTicks;

  /// Whether minor ticks are drawn. Defaults to true.
  final bool showMinorTicks;

  /// Whether the axis line is drawn. Defaults to true.
  final bool showAxisTrack;

  /// Whether tick labels are drawn. Defaults to true.
  final bool showAxisLabel;

  /// Formats each tick label, e.g. `(v, i) => '${v.toInt()}°'`.
  final GxValueLabelFormatter? labelFormatter;

  /// Styles each tick label; the result merges onto [axisLabelStyle].
  final GxValueLabelStyler<TextStyle>? labelStyler;

  /// Styles each major tick, replacing [majorTickStyle].
  final GxValueTickStyler<GxLinearTickStyle>? majorTickStyler;

  /// An optional needle at `value.value`.
  final GxLinearNeedle? needle;

  /// Draws custom needles (for [needle] and marker needles) whose shape is
  /// `GxNeedleShape.custom`. Pass a stable (top-level or static) function.
  final GxNeedlePainter? needlePainter;

  /// Extra needles and/or widgets at fixed values.
  final List<GxLinearMarkerPointer> markers;

  /// Colored bands along the axis, drawn beneath bars, ticks and needles.
  final List<GxLinearRange> ranges;

  /// Bars along the axis, drawn on the opposite side from the ticks (or
  /// centered on the axis for [GxElementPosition.cross]).
  final List<GxLinearBarPointer> bars;

  /// Bar height. Null uses half the gauge's height.
  final double? barHeight;

  /// Gap between the axis and the bars. Defaults to 0.5.
  final double barOffset;

  /// Whether ticks take the color of the bar they fall on. Hides the axis
  /// line and ignores [barOffset]. Defaults to false.
  final bool applyBarColorOnAxisTick;

  /// Runs from the end instead of the start. In a right-to-left locale the
  /// scale already runs from the right, and [reverse] flips it back.
  final bool reverse;

  /// The axis direction. Vertical scales run bottom to top, with labels to
  /// the right of the axis for [GxLabelPosition.bottomCenter]. Defaults to
  /// [Axis.horizontal].
  final Axis direction;

  /// Makes the gauge interactive: called with the value under the pointer on
  /// every tap and drag. Null (the default) keeps the gauge read-only.
  final ValueChanged<double>? onChanged;

  /// Called with the final value when a tap or drag ends.
  final ValueChanged<double>? onChangeEnd;

  /// Describes the gauge to screen readers.
  final String? semanticLabel;

  /// Formats the value announced by screen readers.
  final GxSemanticValueFormatter? semanticValueFormatter;

  @override
  AnimatedGaugeState<GxLinearScaleGauge> createState() =>
      _GxLinearScaleGaugeState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<GxGaugeValue>('value', value))
      ..add(DoubleProperty('interval', interval, defaultValue: null))
      ..add(DoubleProperty('height', height, defaultValue: 100.0))
      ..add(EnumProperty<GxElementPosition>('tickPosition', tickPosition))
      ..add(
        DiagnosticsProperty<GxLinearNeedle>(
          'needle',
          needle,
          defaultValue: null,
        ),
      )
      ..add(FlagProperty('reverse', value: reverse, ifTrue: 'reversed'))
      ..add(
        EnumProperty<Axis>(
          'direction',
          direction,
          defaultValue: Axis.horizontal,
        ),
      )
      ..add(
        ObjectFlagProperty<ValueChanged<double>>.has('onChanged', onChanged),
      )
      ..add(StringProperty('semanticLabel', semanticLabel, defaultValue: null));
  }
}

class _GxLinearScaleGaugeState extends AnimatedGaugeState<GxLinearScaleGauge> {
  @override
  double get targetValue => widget.value.value;

  @override
  Widget build(BuildContext context) {
    final GxLinearScaleGauge w = widget;
    final GaugeDefaults defaults = GaugeDefaults.of(context);
    final TextDirection direction =
        Directionality.maybeOf(context) ?? TextDirection.ltr;
    final GaugeScale scale = GaugeScale(w.value.min, w.value.max);
    final bool vertical = w.direction == Axis.vertical;

    final ScalePainterConfig config = ScalePainterConfig(
      scale: scale,
      interval: w.interval,
      axisSpaceExtent: w.axisSpaceExtent,
      axisStyle: w.axisTrackStyle,
      axisColor: defaults.track,
      majorTickStyle: w.majorTickStyle,
      minorTickStyle: w.minorTickStyle,
      tickColor: defaults.tick,
      minorTicksPerInterval: w.minorTicksPerInterval,
      labelStyle: defaults.labelStyle.merge(w.axisLabelStyle),
      labelPosition: w.labelPosition,
      tickPosition: w.tickPosition,
      showMajorTicks: w.showMajorTicks,
      showMinorTicks: w.showMinorTicks,
      showAxisTrack: w.showAxisTrack,
      showAxisLabel: w.showAxisLabel,
      needleColor: defaults.needle,
      barColor: defaults.primary,
      barLabelStyle: defaults.labelStyle,
      barOffset: w.barOffset,
      applyBarColorOnAxisTick: w.applyBarColorOnAxisTick,
      reversed: linearReversed(context, w.direction, w.reverse),
      textDirection: direction,
      labelFormatter: w.labelFormatter,
      labelStyler: w.labelStyler,
      majorTickStyler: w.majorTickStyler,
      needle: w.needle,
      needlePainter: w.needlePainter,
      markers: w.markers,
      ranges: w.ranges,
      bars: w.bars,
      barHeight: w.barHeight,
      vertical: vertical,
    );

    Widget paint = CustomPaint(
      painter: ScaleLinearGaugePainter(value: valueAnimation, config: config),
    );
    final List<GxLinearMarkerPointer> widgetMarkers = <GxLinearMarkerPointer>[
      for (final GxLinearMarkerPointer m in w.markers)
        if (m.marker != null) m,
    ];
    if (widgetMarkers.isNotEmpty) {
      paint = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(child: paint),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final LinearFrame frame = LinearFrame(
                  constraints.biggest,
                  vertical: vertical,
                );
                final Size logical = frame.logicalSize;
                final LinearTrack track = ScaleLinearGaugePainter.trackFor(
                  config,
                  logical,
                );
                return Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    for (final GxLinearMarkerPointer marker in widgetMarkers)
                      _positioned(
                        frame.toScreen(
                          Offset(
                            track.xOf(scale.fractionOf(marker.value)),
                            logical.height / 2,
                          ),
                        ),
                        marker.marker!,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      );
    }

    return linearGaugeShell(
      direction: w.direction,
      thickness: w.height,
      scale: scale,
      value: w.value.value,
      semanticLabel: w.semanticLabel,
      semanticValueFormatter: w.semanticValueFormatter,
      onChanged: w.onChanged,
      onChangeEnd: w.onChangeEnd,
      trackFor: (Size size) => ScaleLinearGaugePainter.trackFor(config, size),
      paint: paint,
    );
  }

  /// Centers [child] on [center].
  static Widget _positioned(Offset center, Widget child) => Positioned(
    left: center.dx,
    top: center.dy,
    child: FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: child,
    ),
  );
}
