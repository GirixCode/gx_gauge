import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Colors and shape of a linear progress (or stepper) gauge's track.
///
/// ```dart
/// const GxLinearProgressStyle(color: Colors.teal, thickness: 8, dense: false)
/// ```
@immutable
class GxLinearProgressStyle with Diagnosticable {
  /// Creates a progress style.
  const GxLinearProgressStyle({
    this.color,
    this.backgroundColor,
    this.thickness = 10.0,
    this.dense = true,
    this.radius = const Radius.circular(10),
    this.strokeCap = StrokeCap.butt,
    this.paintingStyle = PaintingStyle.fill,
  });

  /// The progress color. Null uses the theme's `primary`.
  final Color? color;

  /// The track color. Null uses [color] at 20% opacity.
  final Color? backgroundColor;

  /// The line thickness in dense mode, and the gauge's default height.
  /// Defaults to 10.
  final double thickness;

  /// Whether the gauge is drawn as a line of [thickness] (true) or as a
  /// rounded bar filling the gauge's height (false). Defaults to true.
  final bool dense;

  /// Corner radius of the bar when [dense] is false. Defaults to 10.
  final Radius? radius;

  /// Cap of the dense line. Defaults to [StrokeCap.butt].
  final StrokeCap strokeCap;

  /// Filled or outlined track when [dense] is false. Defaults to
  /// [PaintingStyle.fill].
  final PaintingStyle paintingStyle;

  /// Returns a copy with the given fields replaced.
  GxLinearProgressStyle copyWith({
    Color? color,
    Color? backgroundColor,
    double? thickness,
    bool? dense,
    Radius? radius,
    StrokeCap? strokeCap,
    PaintingStyle? paintingStyle,
  }) {
    return GxLinearProgressStyle(
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      thickness: thickness ?? this.thickness,
      dense: dense ?? this.dense,
      radius: radius ?? this.radius,
      strokeCap: strokeCap ?? this.strokeCap,
      paintingStyle: paintingStyle ?? this.paintingStyle,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxLinearProgressStyle &&
      other.color == color &&
      other.backgroundColor == backgroundColor &&
      other.thickness == thickness &&
      other.dense == dense &&
      other.radius == radius &&
      other.strokeCap == strokeCap &&
      other.paintingStyle == paintingStyle;

  @override
  int get hashCode => Object.hash(
    color,
    backgroundColor,
    thickness,
    dense,
    radius,
    strokeCap,
    paintingStyle,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(
        ColorProperty('backgroundColor', backgroundColor, defaultValue: null),
      )
      ..add(DoubleProperty('thickness', thickness, defaultValue: 10.0))
      ..add(FlagProperty('dense', value: dense, ifFalse: 'bar'));
  }
}
