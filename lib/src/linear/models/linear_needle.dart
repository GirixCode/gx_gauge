import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:gx_gauge/src/common/models/enums.dart';

/// The needle that marks a value on a linear gauge.
///
/// ```dart
/// const GxLinearNeedle(
///   shape: GxNeedleShape.triangle,
///   position: GxNeedlePosition.top,
///   size: Size(14, 14),
/// )
/// ```
@immutable
class GxLinearNeedle with Diagnosticable {
  /// Creates a needle.
  const GxLinearNeedle({
    this.shape = GxNeedleShape.rectangle,
    this.position = GxNeedlePosition.center,
    this.size = const Size(10, 10),
    this.color,
    this.enabled = true,
    this.label,
    this.offset = 2,
    this.strokeCap = StrokeCap.square,
    this.paintingStyle = PaintingStyle.fill,
    this.strokeWidth = 2.0,
  });

  /// The needle's shape. [GxNeedleShape.custom] delegates drawing to the
  /// gauge's `needlePainter`. Defaults to [GxNeedleShape.rectangle].
  final GxNeedleShape shape;

  /// Above, below or centered on the track. Defaults to
  /// [GxNeedlePosition.center].
  final GxNeedlePosition position;

  /// The needle's width and height. Defaults to 10×10.
  final Size size;

  /// The needle color. Null uses the theme's `onSurface`.
  final Color? color;

  /// Whether the needle is drawn. Defaults to true.
  final bool enabled;

  /// Text drawn beyond the needle: above it, or below it for
  /// [GxNeedlePosition.bottom].
  final GxNeedleLabel? label;

  /// Spacing used by the bar gauge and marker pointers when positioning the
  /// needle above or below the track. Defaults to 2.
  final double offset;

  /// Stroke cap when [paintingStyle] is [PaintingStyle.stroke]. Defaults to
  /// [StrokeCap.square].
  final StrokeCap strokeCap;

  /// Filled or outlined shape. Defaults to [PaintingStyle.fill].
  final PaintingStyle paintingStyle;

  /// Outline width when [paintingStyle] is [PaintingStyle.stroke]. Defaults
  /// to 2.
  final double strokeWidth;

  /// Returns a copy with the given fields replaced.
  GxLinearNeedle copyWith({
    GxNeedleShape? shape,
    GxNeedlePosition? position,
    Size? size,
    Color? color,
    bool? enabled,
    GxNeedleLabel? label,
    double? offset,
    StrokeCap? strokeCap,
    PaintingStyle? paintingStyle,
    double? strokeWidth,
  }) {
    return GxLinearNeedle(
      shape: shape ?? this.shape,
      position: position ?? this.position,
      size: size ?? this.size,
      color: color ?? this.color,
      enabled: enabled ?? this.enabled,
      label: label ?? this.label,
      offset: offset ?? this.offset,
      strokeCap: strokeCap ?? this.strokeCap,
      paintingStyle: paintingStyle ?? this.paintingStyle,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxLinearNeedle &&
      other.shape == shape &&
      other.position == position &&
      other.size == size &&
      other.color == color &&
      other.enabled == enabled &&
      other.label == label &&
      other.offset == offset &&
      other.strokeCap == strokeCap &&
      other.paintingStyle == paintingStyle &&
      other.strokeWidth == strokeWidth;

  @override
  int get hashCode => Object.hash(
    shape,
    position,
    size,
    color,
    enabled,
    label,
    offset,
    strokeCap,
    paintingStyle,
    strokeWidth,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<GxNeedleShape>('shape', shape))
      ..add(EnumProperty<GxNeedlePosition>('position', position))
      ..add(DiagnosticsProperty<Size>('size', size))
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
  }
}

/// A text label attached to a [GxLinearNeedle].
@immutable
class GxNeedleLabel with Diagnosticable {
  /// Creates a needle label.
  const GxNeedleLabel({required this.label, this.textStyle, this.offset = 0});

  /// The text. `{value}` is replaced with the value the needle points at.
  final String label;

  /// The text style. Null uses the theme's label style.
  final TextStyle? textStyle;

  /// Extra distance between the needle and the text. Defaults to 0.
  final double offset;

  /// Returns a copy with the given fields replaced.
  GxNeedleLabel copyWith({
    String? label,
    TextStyle? textStyle,
    double? offset,
  }) {
    return GxNeedleLabel(
      label: label ?? this.label,
      textStyle: textStyle ?? this.textStyle,
      offset: offset ?? this.offset,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GxNeedleLabel &&
      other.label == label &&
      other.textStyle == textStyle &&
      other.offset == offset;

  @override
  int get hashCode => Object.hash(label, textStyle, offset);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(DoubleProperty('offset', offset, defaultValue: 0.0));
  }
}
