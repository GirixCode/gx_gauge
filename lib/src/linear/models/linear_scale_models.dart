import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
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

/// A colored stretch of the axis between [start] and [end].
///
/// ```dart
/// const GxLinearFillArea(start: 0, end: 40, color: Colors.green)
/// ```
@immutable
class GxLinearFillArea with Diagnosticable {
  /// Creates a fill area from [start] to [end] (in gauge values).
  const GxLinearFillArea({
    required this.start,
    required this.end,
    required this.color,
    this.thickness = 5.0,
    this.position = GxElementPosition.cross,
    this.shaderCallback,
    this.borderColor,
    this.borderWidth = 5.0,
    this.offset = 0.0,
  });

  /// The value where the area begins.
  final double start;

  /// The value where the area ends.
  final double end;

  /// The fill color.
  final Color color;

  /// Line thickness. Defaults to 5.
  final double thickness;

  /// Not applied yet (docs/PLAN.md Phase 3).
  final GxElementPosition position;

  /// Not applied yet (docs/PLAN.md Phase 3).
  final ShaderCallback? shaderCallback;

  /// Not applied yet (docs/PLAN.md Phase 3).
  final Color? borderColor;

  /// Not applied yet (docs/PLAN.md Phase 3).
  final double borderWidth;

  /// Not applied yet (docs/PLAN.md Phase 3).
  final double offset;

  /// Returns a copy with the given fields replaced.
  GxLinearFillArea copyWith({
    double? start,
    double? end,
    Color? color,
    double? thickness,
    GxElementPosition? position,
    ShaderCallback? shaderCallback,
    Color? borderColor,
    double? borderWidth,
    double? offset,
  }) {
    return GxLinearFillArea(
      start: start ?? this.start,
      end: end ?? this.end,
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
      position: position ?? this.position,
      shaderCallback: shaderCallback ?? this.shaderCallback,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      offset: offset ?? this.offset,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxLinearFillArea &&
      other.start == start &&
      other.end == end &&
      other.color == color &&
      other.thickness == thickness &&
      other.position == position &&
      other.shaderCallback == shaderCallback &&
      other.borderColor == borderColor &&
      other.borderWidth == borderWidth &&
      other.offset == offset;

  @override
  int get hashCode => Object.hash(
    start,
    end,
    color,
    thickness,
    position,
    shaderCallback,
    borderColor,
    borderWidth,
    offset,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('start', start))
      ..add(DoubleProperty('end', end))
      ..add(ColorProperty('color', color));
  }
}

/// An extra needle marking [value] on a `GxLinearScaleGauge`.
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

  /// Not drawn yet (docs/PLAN.md Phase 3).
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
