import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:gx_gauge/src/common/models/enums.dart';
import 'package:gx_gauge/src/common/models/gauge_label.dart';

/// The arc of a `GxRadialGauge`.
///
/// ```dart
/// const GxRadialGaugeStyle(color: Colors.indigo, thickness: 14)
/// ```
@immutable
class GxRadialGaugeStyle with Diagnosticable {
  /// Creates a radial gauge style.
  const GxRadialGaugeStyle({
    this.color,
    this.backgroundColor,
    this.thickness = 10.0,
    this.strokeCap = StrokeCap.round,
    this.paintingStyle = PaintingStyle.stroke,
    this.gradient,
    this.backgroundGradient,
  });

  /// The value arc's color. Null uses the theme's `primary`.
  final Color? color;

  /// The track arc's color. Null uses [color] at 20% opacity.
  final Color? backgroundColor;

  /// Arc thickness. Defaults to 10.
  final double thickness;

  /// Arc end caps. Defaults to [StrokeCap.round].
  final StrokeCap strokeCap;

  /// Painting style of both arcs. Defaults to [PaintingStyle.stroke].
  final PaintingStyle paintingStyle;

  /// A gradient for the value arc (and for the track, if
  /// [backgroundGradient] is null). Overrides [color].
  final Gradient? gradient;

  /// A gradient for the track arc. Overrides [backgroundColor].
  final Gradient? backgroundGradient;

  /// Returns a copy with the given fields replaced.
  GxRadialGaugeStyle copyWith({
    Color? color,
    Color? backgroundColor,
    double? thickness,
    StrokeCap? strokeCap,
    PaintingStyle? paintingStyle,
    Gradient? gradient,
    Gradient? backgroundGradient,
  }) {
    return GxRadialGaugeStyle(
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      thickness: thickness ?? this.thickness,
      strokeCap: strokeCap ?? this.strokeCap,
      paintingStyle: paintingStyle ?? this.paintingStyle,
      gradient: gradient ?? this.gradient,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxRadialGaugeStyle &&
      other.color == color &&
      other.backgroundColor == backgroundColor &&
      other.thickness == thickness &&
      other.strokeCap == strokeCap &&
      other.paintingStyle == paintingStyle &&
      other.gradient == gradient &&
      other.backgroundGradient == backgroundGradient;

  @override
  int get hashCode => Object.hash(
    color,
    backgroundColor,
    thickness,
    strokeCap,
    paintingStyle,
    gradient,
    backgroundGradient,
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
      ..add(
        DiagnosticsProperty<Gradient>('gradient', gradient, defaultValue: null),
      );
  }
}

/// The hub at the center of a radial needle.
@immutable
class GxNeedleCap with Diagnosticable {
  /// Creates a needle cap.
  const GxNeedleCap({
    this.color,
    this.radius = 5,
    this.strokeWidth = 1.0,
    this.paintingStyle = PaintingStyle.fill,
    this.innerColor,
  });

  /// The cap color. Null uses the needle's color.
  final Color? color;

  /// The cap radius. Defaults to 5.
  final double radius;

  /// Outline width when [paintingStyle] is [PaintingStyle.stroke]. Defaults
  /// to 1.
  final double strokeWidth;

  /// Filled or outlined cap. Defaults to [PaintingStyle.fill].
  final PaintingStyle paintingStyle;

  /// Fill inside an outlined cap, which hides the needle's base. Null uses
  /// the surrounding `Material`'s color, or the theme's `surface`.
  final Color? innerColor;

  /// Returns a copy with the given fields replaced.
  GxNeedleCap copyWith({
    Color? color,
    double? radius,
    double? strokeWidth,
    PaintingStyle? paintingStyle,
    Color? innerColor,
  }) {
    return GxNeedleCap(
      color: color ?? this.color,
      radius: radius ?? this.radius,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      paintingStyle: paintingStyle ?? this.paintingStyle,
      innerColor: innerColor ?? this.innerColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxNeedleCap &&
      other.color == color &&
      other.radius == radius &&
      other.strokeWidth == strokeWidth &&
      other.paintingStyle == paintingStyle &&
      other.innerColor == innerColor;

  @override
  int get hashCode =>
      Object.hash(color, radius, strokeWidth, paintingStyle, innerColor);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(DoubleProperty('radius', radius, defaultValue: 5.0));
  }
}

/// A colored band covering the values [start]..[end] of a radial gauge.
///
/// ```dart
/// const GxRadialRange(
///   start: 0,
///   end: 60,
///   color: Colors.green,
///   label: GxGaugeLabel(label: 'Normal'),
/// )
/// ```
@immutable
class GxRadialRange with Diagnosticable {
  /// Creates a range from [start] to [end] (in gauge values).
  const GxRadialRange({
    required this.start,
    required this.end,
    required this.label,
    this.color,
    this.height = 10,
    this.offset = 0,
  });

  /// The value where the band begins.
  final double start;

  /// The value where the band ends.
  final double end;

  /// The band's label. Not drawn yet (docs/PLAN.md Phase 3).
  final GxGaugeLabel label;

  /// The band color. Null uses the gauge arc's color.
  final Color? color;

  /// The band's thickness. Defaults to 10.
  final double height;

  /// Radial shift of the band from the arc's center line; positive moves it
  /// outwards. Defaults to 0.
  final double offset;

  /// Returns a copy with the given fields replaced.
  GxRadialRange copyWith({
    double? start,
    double? end,
    GxGaugeLabel? label,
    Color? color,
    double? height,
    double? offset,
  }) {
    return GxRadialRange(
      start: start ?? this.start,
      end: end ?? this.end,
      label: label ?? this.label,
      color: color ?? this.color,
      height: height ?? this.height,
      offset: offset ?? this.offset,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxRadialRange &&
      other.start == start &&
      other.end == end &&
      other.label == label &&
      other.color == color &&
      other.height == height &&
      other.offset == offset;

  @override
  int get hashCode => Object.hash(start, end, label, color, height, offset);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('start', start))
      ..add(DoubleProperty('end', end))
      ..add(ColorProperty('color', color, defaultValue: null));
  }
}

/// The needle of a radial gauge or radial pointer.
@immutable
class GxRadialNeedle with Diagnosticable {
  /// Creates a radial needle.
  const GxRadialNeedle({
    this.color,
    this.topOffset,
    this.bottomOffset,
    this.alignment = GxRadialElementAlignment.center,
    this.cap = const GxNeedleCap(),
    this.thickness = 10.0,
    this.shape = GxRadialNeedleShape.taperedLine,
    this.strokeCap = StrokeCap.round,
    this.gradient,
  });

  /// The needle color. Null uses the theme's `onSurface`.
  final Color? color;

  /// Extends (positive) or shortens (negative) the tip when [alignment] is
  /// start or end. Null means 0.
  final double? topOffset;

  /// Extends the needle backwards past the center by this length. Null means
  /// it starts at the center.
  final double? bottomOffset;

  /// Where the tip ends across the arc's thickness. Defaults to
  /// [GxRadialElementAlignment.center].
  final GxRadialElementAlignment alignment;

  /// The hub at the center.
  final GxNeedleCap cap;

  /// Needle width. Defaults to 10.
  final double thickness;

  /// Line or tapered shape. Defaults to [GxRadialNeedleShape.taperedLine].
  final GxRadialNeedleShape shape;

  /// Cap of a [GxRadialNeedleShape.line] needle. Defaults to
  /// [StrokeCap.round].
  final StrokeCap strokeCap;

  /// A gradient that overrides [color].
  final Gradient? gradient;

  /// Returns a copy with the given fields replaced.
  GxRadialNeedle copyWith({
    Color? color,
    double? topOffset,
    double? bottomOffset,
    GxRadialElementAlignment? alignment,
    GxNeedleCap? cap,
    double? thickness,
    GxRadialNeedleShape? shape,
    StrokeCap? strokeCap,
    Gradient? gradient,
  }) {
    return GxRadialNeedle(
      color: color ?? this.color,
      topOffset: topOffset ?? this.topOffset,
      bottomOffset: bottomOffset ?? this.bottomOffset,
      alignment: alignment ?? this.alignment,
      cap: cap ?? this.cap,
      thickness: thickness ?? this.thickness,
      shape: shape ?? this.shape,
      strokeCap: strokeCap ?? this.strokeCap,
      gradient: gradient ?? this.gradient,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxRadialNeedle &&
      other.color == color &&
      other.topOffset == topOffset &&
      other.bottomOffset == bottomOffset &&
      other.alignment == alignment &&
      other.cap == cap &&
      other.thickness == thickness &&
      other.shape == shape &&
      other.strokeCap == strokeCap &&
      other.gradient == gradient;

  @override
  int get hashCode => Object.hash(
    color,
    topOffset,
    bottomOffset,
    alignment,
    cap,
    thickness,
    shape,
    strokeCap,
    gradient,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(EnumProperty<GxRadialNeedleShape>('shape', shape))
      ..add(DoubleProperty('thickness', thickness, defaultValue: 10.0));
  }
}

/// An extra marker (and optional needle) at [value] on a radial gauge.
@immutable
class GxRadialPointer with Diagnosticable {
  /// Creates a radial pointer at [value].
  const GxRadialPointer({
    required this.value,
    this.style = const GxRadialPointerStyle(),
    this.needle,
    this.alignment = GxRadialElementAlignment.center,
    this.shape = GxRadialPointerShape.circle,
    this.showNeedle = true,
    this.showPointer = true,
  });

  /// The marked value.
  final double value;

  /// The marker's look.
  final GxRadialPointerStyle style;

  /// A needle drawn to [value] when [showNeedle] is true.
  final GxRadialNeedle? needle;

  /// Where the marker sits across the arc. Defaults to
  /// [GxRadialElementAlignment.center].
  final GxRadialElementAlignment alignment;

  /// The marker shape. Defaults to [GxRadialPointerShape.circle].
  final GxRadialPointerShape shape;

  /// Whether [needle] is drawn. Defaults to true.
  final bool showNeedle;

  /// Whether the marker is drawn. Defaults to true.
  final bool showPointer;

  /// Returns a copy with the given fields replaced.
  GxRadialPointer copyWith({
    double? value,
    GxRadialPointerStyle? style,
    GxRadialNeedle? needle,
    GxRadialElementAlignment? alignment,
    GxRadialPointerShape? shape,
    bool? showNeedle,
    bool? showPointer,
  }) {
    return GxRadialPointer(
      value: value ?? this.value,
      style: style ?? this.style,
      needle: needle ?? this.needle,
      alignment: alignment ?? this.alignment,
      shape: shape ?? this.shape,
      showNeedle: showNeedle ?? this.showNeedle,
      showPointer: showPointer ?? this.showPointer,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxRadialPointer &&
      other.value == value &&
      other.style == style &&
      other.needle == needle &&
      other.alignment == alignment &&
      other.shape == shape &&
      other.showNeedle == showNeedle &&
      other.showPointer == showPointer;

  @override
  int get hashCode => Object.hash(
    value,
    style,
    needle,
    alignment,
    shape,
    showNeedle,
    showPointer,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('value', value))
      ..add(EnumProperty<GxRadialPointerShape>('shape', shape));
  }
}

/// The look of a [GxRadialPointer] marker.
@immutable
class GxRadialPointerStyle with Diagnosticable {
  /// Creates a pointer style.
  const GxRadialPointerStyle({
    this.color,
    this.thickness = 10.0,
    this.paintingStyle = PaintingStyle.fill,
    this.size = 10.0,
  });

  /// Marker color. Null uses the theme's `tertiary`.
  final Color? color;

  /// Outline width when [paintingStyle] is [PaintingStyle.stroke]. Defaults
  /// to 10.
  final double thickness;

  /// Filled or outlined marker. Defaults to [PaintingStyle.fill].
  final PaintingStyle paintingStyle;

  /// Marker size (circle radius, or triangle height). Defaults to 10.
  final double size;

  /// Returns a copy with the given fields replaced.
  GxRadialPointerStyle copyWith({
    Color? color,
    double? thickness,
    PaintingStyle? paintingStyle,
    double? size,
  }) {
    return GxRadialPointerStyle(
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
      paintingStyle: paintingStyle ?? this.paintingStyle,
      size: size ?? this.size,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxRadialPointerStyle &&
      other.color == color &&
      other.thickness == thickness &&
      other.paintingStyle == paintingStyle &&
      other.size == size;

  @override
  int get hashCode => Object.hash(color, thickness, paintingStyle, size);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(DoubleProperty('size', size, defaultValue: 10.0));
  }
}

/// The tick labels of a radial gauge.
@immutable
class GxRadialTickLabelStyle with Diagnosticable {
  /// Creates a tick label style.
  const GxRadialTickLabelStyle({
    this.style = const TextStyle(),
    this.position = GxRadialElementPosition.inside,
    this.padding = 20,
  });

  /// Merged onto the theme's label style.
  final TextStyle style;

  /// Inside or outside the arc. Defaults to
  /// [GxRadialElementPosition.inside].
  final GxRadialElementPosition position;

  /// Distance between the tick and the label. Defaults to 20.
  final double padding;

  /// Returns a copy with the given fields replaced.
  GxRadialTickLabelStyle copyWith({
    TextStyle? style,
    GxRadialElementPosition? position,
    double? padding,
  }) {
    return GxRadialTickLabelStyle(
      style: style ?? this.style,
      position: position ?? this.position,
      padding: padding ?? this.padding,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxRadialTickLabelStyle &&
      other.style == style &&
      other.position == position &&
      other.padding == padding;

  @override
  int get hashCode => Object.hash(style, position, padding);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<GxRadialElementPosition>('position', position))
      ..add(DoubleProperty('padding', padding, defaultValue: 20.0));
  }
}

/// The major or minor ticks of a radial gauge.
@immutable
class GxRadialTickStyle with Diagnosticable {
  /// Creates a tick style.
  const GxRadialTickStyle({
    this.length = 8.0,
    this.thickness = 1.0,
    this.color,
    this.alignment = GxRadialElementAlignment.center,
    this.position = GxRadialElementPosition.inside,
  });

  /// Tick length. Defaults to 8.
  final double length;

  /// Tick stroke width. Defaults to 1.
  final double thickness;

  /// Tick color. Null uses the theme's `outline`.
  final Color? color;

  /// Where the tick sits across the arc's thickness. Defaults to
  /// [GxRadialElementAlignment.center].
  final GxRadialElementAlignment alignment;

  /// Which side of the arc the tick extends to when [alignment] is
  /// [GxRadialElementAlignment.center]. Defaults to
  /// [GxRadialElementPosition.inside].
  final GxRadialElementPosition position;

  /// Returns a copy with the given fields replaced.
  GxRadialTickStyle copyWith({
    double? length,
    double? thickness,
    Color? color,
    GxRadialElementAlignment? alignment,
    GxRadialElementPosition? position,
  }) {
    return GxRadialTickStyle(
      length: length ?? this.length,
      thickness: thickness ?? this.thickness,
      color: color ?? this.color,
      alignment: alignment ?? this.alignment,
      position: position ?? this.position,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxRadialTickStyle &&
      other.length == length &&
      other.thickness == thickness &&
      other.color == color &&
      other.alignment == alignment &&
      other.position == position;

  @override
  int get hashCode =>
      Object.hash(length, thickness, color, alignment, position);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('length', length, defaultValue: 8.0))
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(EnumProperty<GxRadialElementAlignment>('alignment', alignment))
      ..add(EnumProperty<GxRadialElementPosition>('position', position));
  }
}
