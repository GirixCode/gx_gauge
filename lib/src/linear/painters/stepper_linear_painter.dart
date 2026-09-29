import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/painter_config.dart';
import 'package:gx_gauge/src/core/text_utils.dart';
import 'package:gx_gauge/src/linear/models/linear_progress_style.dart';
import 'package:gx_gauge/src/linear/models/stepper_step.dart';

/// Everything [StepperLinearPainter] draws with, with theme defaults
/// already resolved.
class StepperPainterConfig extends PainterConfig {
  /// Creates a stepper painter configuration.
  const StepperPainterConfig({
    required this.scale,
    required this.steps,
    required this.style,
    required this.color,
    required this.trackColor,
    required this.inactiveColor,
    required this.shape,
    required this.shapeSize,
    required this.offset,
    required this.activeStyle,
    required this.inactiveStyle,
    required this.labelStyle,
    required this.reversed,
    required this.textDirection,
  });

  /// The value range.
  final GaugeScale scale;

  /// The steps, evenly spaced along the track.
  final List<GxStepperStep> steps;

  /// Line thickness and caps.
  final GxLinearProgressStyle style;

  /// Resolved color of the progress line and reached steps.
  final Color color;

  /// Resolved color of the track line.
  final Color trackColor;

  /// Resolved color of steps not yet reached.
  final Color inactiveColor;

  /// Step marker shape.
  final GxStepperShape shape;

  /// Step marker size.
  final double shapeSize;

  /// Distance from the track to the step labels.
  final double offset;

  /// Resolved text style of reached step numbers.
  final TextStyle activeStyle;

  /// Resolved text style of unreached step numbers.
  final TextStyle inactiveStyle;

  /// Base style that step labels merge onto.
  final TextStyle labelStyle;

  /// Whether steps run right to left.
  final bool reversed;

  /// Direction for text.
  final TextDirection textDirection;

  @override
  List<Object?> get props => <Object?>[
    scale,
    steps,
    style,
    color,
    trackColor,
    inactiveColor,
    shape,
    shapeSize,
    offset,
    activeStyle,
    inactiveStyle,
    labelStyle,
    reversed,
    textDirection,
  ];
}

/// Paints a linear stepper gauge.
class StepperLinearPainter extends CustomPainter {
  /// Creates a painter that repaints whenever [value] ticks.
  StepperLinearPainter({required this.config, required this.value})
    : super(repaint: value);

  /// What to draw.
  final StepperPainterConfig config;

  /// The current (animated) value.
  final Animation<double> value;

  @override
  void paint(Canvas canvas, Size size) {
    final StepperPainterConfig c = config;
    final double half = c.shapeSize / 2;
    final double y = size.height / 2;
    final LinearTrack track = LinearTrack(
      start: half,
      end: size.width - half,
      reversed: c.reversed,
    );
    final double fraction = c.scale.fractionOf(value.value);

    Paint linePaint(Color color) => Paint()
      ..color = color
      ..strokeWidth = c.style.thickness
      ..style = c.style.paintingStyle
      ..strokeCap = c.style.strokeCap;
    canvas
      ..drawLine(
        Offset(track.start, y),
        Offset(track.end, y),
        linePaint(c.trackColor),
      )
      ..drawLine(
        Offset(track.xOf(0), y),
        Offset(track.xOf(fraction), y),
        linePaint(c.color),
      );

    final int count = c.steps.length;
    final double spacing = count > 1 ? track.length / (count - 1) : size.width;
    for (int i = 0; i < count; i++) {
      final double stepFraction = count > 1 ? i / (count - 1) : 0;
      final double x = track.xOf(stepFraction);
      final bool reached = stepFraction <= fraction + 1e-9;
      _drawMarker(canvas, Offset(x, y), reached ? c.color : c.inactiveColor);

      final GxStepperStep step = c.steps[i];
      paintText(
        canvas,
        text: (step.value?.toInt() ?? i + 1).toString(),
        style: reached ? c.activeStyle : c.inactiveStyle,
        textDirection: c.textDirection,
        maxWidth: c.shapeSize,
        position: (Size text) =>
            Offset(x - text.width / 2, y - text.height / 2),
      );
      paintText(
        canvas,
        text: step.label.label,
        style: c.labelStyle.merge(step.label.style),
        textDirection: c.textDirection,
        maxWidth: spacing,
        position: (Size text) =>
            Offset(x - text.width / 2, y + c.offset + 5) +
            (step.label.offset ?? Offset.zero),
      );
    }
  }

  void _drawMarker(Canvas canvas, Offset center, Color color) {
    final double size = config.shapeSize;
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = config.style.thickness
      ..style = config.style.paintingStyle;
    switch (config.shape) {
      case GxStepperShape.circle:
        canvas.drawCircle(center, size / 2, paint);
      case GxStepperShape.rectangle:
        canvas.drawRect(
          Rect.fromCenter(center: center, width: size, height: size),
          paint,
        );
      case GxStepperShape.diamond:
        canvas.drawPath(
          Path()
            ..moveTo(center.dx, center.dy - size / 2)
            ..lineTo(center.dx - size / 2, center.dy)
            ..lineTo(center.dx, center.dy + size / 2)
            ..lineTo(center.dx + size / 2, center.dy)
            ..close(),
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant StepperLinearPainter oldDelegate) =>
      oldDelegate.config != config || oldDelegate.value != value;
}
