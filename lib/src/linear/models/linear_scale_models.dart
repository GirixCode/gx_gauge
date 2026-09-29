import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/common/models/gauge_label.dart';
import 'package:gx_gauge/src/linear/models/linear_needle.dart';

/// The axis line of a `GxLinearScaleGauge`.
@immutable
class GxLinearAxisStyle with Diagnosticable {
  /// Creates an axis style.
  const GxLinearAxisStyle({
    this.thickness = 5.0,
    this.color,
    this.strokeCap = StrokeCap.butt,
    this.paintingStyle = PaintingStyle.stroke,
  });

  /// Line thickness. Defaults to 5.
  final double thickness;

  /// Line color. Null uses the theme's `outlineVariant`.
  final Color? color;

  /// Line cap. Defaults to [StrokeCap.butt].
  final StrokeCap strokeCap;

  /// Painting style of the line. Defaults to [PaintingStyle.stroke].
  final PaintingStyle paintingStyle;

  /// Returns a copy with the given fields replaced.
  GxLinearAxisStyle copyWith({
    double? thickness,
    Color? color,
    StrokeCap? strokeCap,
    PaintingStyle? paintingStyle,
  }) {
    return GxLinearAxisStyle(
      thickness: thickness ?? this.thickness,
      color: color ?? this.color,
      strokeCap: strokeCap ?? this.strokeCap,
      paintingStyle: paintingStyle ?? this.paintingStyle,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxLinearAxisStyle &&
      other.thickness == thickness &&
      other.color == color &&
      other.strokeCap == strokeCap &&
      other.paintingStyle == paintingStyle;

  @override
  int get hashCode => Object.hash(thickness, color, strokeCap, paintingStyle);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('thickness', thickness, defaultValue: 5.0))
      ..add(ColorProperty('color', color, defaultValue: null));
  }
}

/// The major or minor ticks of a `GxLinearScaleGauge`.
@immutable
class GxLinearTickStyle with Diagnosticable {
  /// Creates a tick style.
  const GxLinearTickStyle({
    this.length = 8.0,
    this.thickness = 1.0,
    this.color,
  });

  /// Tick length. Defaults to 8.
  final double length;

  /// Tick stroke width. Defaults to 1.
  final double thickness;

  /// Tick color. Null uses the theme's `outline`.
  final Color? color;

  /// Returns a copy with the given fields replaced.
  GxLinearTickStyle copyWith({
    double? length,
    double? thickness,
    Color? color,
  }) {
    return GxLinearTickStyle(
      length: length ?? this.length,
      thickness: thickness ?? this.thickness,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxLinearTickStyle &&
      other.length == length &&
      other.thickness == thickness &&
      other.color == color;

  @override
  int get hashCode => Object.hash(length, thickness, color);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('length', length, defaultValue: 8.0))
      ..add(DoubleProperty('thickness', thickness, defaultValue: 1.0))
      ..add(ColorProperty('color', color, defaultValue: null));
  }
}

/// A colored band along a `GxLinearScaleGauge` axis from [start] to [end],
/// e.g. "normal" and "danger" zones, with an optional label.
///
/// ```dart
/// const GxLinearRange(
///   start: 80,
///   end: 100,
///   color: Colors.red,
///   label: GxGaugeLabel(label: 'Danger'),
/// )
/// ```
@immutable
class GxLinearRange with Diagnosticable {
  /// Creates a range from [start] to [end] (in gauge values).
  const GxLinearRange({
    required this.start,
    required this.end,
    this.color,
    this.thickness,
    this.position = GxElementPosition.cross,
    this.offset = 0,
    this.shaderCallback,
    this.borderColor,
    this.borderWidth = 1,
    this.radius,
    this.label,
  }) : assert(
         start <= end,
         'start ($start) must not be greater than end ($end)',
       );

  /// The value where the band begins.
  final double start;

  /// The value where the band ends.
  final double end;

  /// The band color. Null uses the theme's `primary`.
  final Color? color;

  /// The band's extent across the axis. Null uses the axis thickness.
  final double? thickness;

  /// Centered on the axis ([GxElementPosition.cross], the default), below it
  /// ([GxElementPosition.inside]) or above it ([GxElementPosition.outside]).
  final GxElementPosition position;

  /// Distance from the axis for [GxElementPosition.inside] and
  /// [GxElementPosition.outside]. Defaults to 0.
  final double offset;

  /// Paints the band with a shader (e.g. a gradient) instead of [color].
  /// Receives the band's rectangle.
  final ShaderCallback? shaderCallback;

  /// Outline color. Null draws no outline.
  final Color? borderColor;

  /// Outline width when [borderColor] is set. Defaults to 1.
  final double borderWidth;

  /// Corner radius. Null draws square corners.
  final Radius? radius;

  /// Text centered over the band, on the side away from the axis (above it
  /// for [GxElementPosition.cross]).
  final GxGaugeLabel? label;

  /// Returns a copy with the given fields replaced.
  GxLinearRange copyWith({
    double? start,
    double? end,
    Color? color,
    double? thickness,
    GxElementPosition? position,
    double? offset,
    ShaderCallback? shaderCallback,
    Color? borderColor,
    double? borderWidth,
    Radius? radius,
    GxGaugeLabel? label,
  }) {
    return GxLinearRange(
      start: start ?? this.start,
      end: end ?? this.end,
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
      position: position ?? this.position,
      offset: offset ?? this.offset,
      shaderCallback: shaderCallback ?? this.shaderCallback,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      radius: radius ?? this.radius,
      label: label ?? this.label,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxLinearRange &&
      other.start == start &&
      other.end == end &&
      other.color == color &&
      other.thickness == thickness &&
      other.position == position &&
      other.offset == offset &&
      other.shaderCallback == shaderCallback &&
      other.borderColor == borderColor &&
      other.borderWidth == borderWidth &&
      other.radius == radius &&
      other.label == label;

  @override
  int get hashCode => Object.hash(
    start,
    end,
    color,
    thickness,
    position,
    offset,
    shaderCallback,
    borderColor,
    borderWidth,
    radius,
    label,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('start', start))
      ..add(DoubleProperty('end', end))
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(
        DiagnosticsProperty<GxGaugeLabel>('label', label, defaultValue: null),
      );
  }
}

/// An extra needle and/or widget marking [value] on a `GxLinearScaleGauge`.
///
/// ```dart
/// const GxLinearMarkerPointer(
///   value: 75,
///   needle: GxLinearNeedle(shape: GxNeedleShape.triangle),
/// )
/// ```
@immutable
class GxLinearMarkerPointer with Diagnosticable {
  /// Creates a marker pointer at [value].
  const GxLinearMarkerPointer({required this.value, this.marker, this.needle});

  /// The marked value.
  final double value;

  /// A widget centered on the axis at [value], e.g. an `Icon`. Drawn above
  /// the gauge's paint.
  final Widget? marker;

  /// The needle drawn at [value].
  final GxLinearNeedle? needle;

  /// Returns a copy with the given fields replaced.
  GxLinearMarkerPointer copyWith({
    double? value,
    Widget? marker,
    GxLinearNeedle? needle,
  }) {
    return GxLinearMarkerPointer(
      value: value ?? this.value,
      marker: marker ?? this.marker,
      needle: needle ?? this.needle,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxLinearMarkerPointer &&
      other.value == value &&
      other.marker == marker &&
      other.needle == needle;

  @override
  int get hashCode => Object.hash(value, marker, needle);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('value', value))
      ..add(
        DiagnosticsProperty<GxLinearNeedle>(
          'needle',
          needle,
          defaultValue: null,
        ),
      );
  }
}
