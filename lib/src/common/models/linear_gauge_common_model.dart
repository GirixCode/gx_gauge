import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/src/common/models/enums.dart';

/// [GaugeLabel] model
///
/// This model is used to represent the label of a gauge. It contains the label, the style, the text alignment and the offset.
///
///
class GaugeLabel {
  /// Specifies the label of the gauge. It is required.
  ///
  /// [label] String: The label of the gauge.
  /// ```dart
  /// GaugeLabel(
  ///  label: 'Label',
  /// )
  /// ```
  final String label;

  /// Specifies the style of the label. Default is TextStyle() .
  ///
  /// [style] TextStyle: The style of the label.
  /// ```dart
  /// GaugeLabel(
  ///  label: 'Label',
  ///  style: TextStyle(color: Colors.black),
  /// )
  /// ```
  final TextStyle style;

  /// Specifies the text alignment of the label. Default is TextAlign.center.
  ///
  /// [textAlign] TextAlign: The text alignment of the label.
  ///
  /// ```dart
  /// GaugeLabel(
  ///  label: 'Label',
  ///  textAlign: TextAlign.center,
  /// )
  /// ```
  ///
  final TextAlign? textAlign;

  /// Specifies the offset of the label. Default is null.
  ///
  /// [offset] Offset: The offset of the label.
  ///
  /// ```dart
  /// GaugeLabel(
  ///  label: 'Label',
  ///  offset: Offset(0, -10),
  /// )
  /// ```
  ///
  final Offset? offset;

  /// Specifies the space extent of the label. Default is 0.0.
  ///
  /// [spaceExtent] double: The space extent of the label.
  ///
  /// ```dart
  /// GaugeLabel(
  ///  label: 'Label',
  ///  spaceExtent: 0.0,
  /// )
  /// ```
  ///
  final double spaceExtent;

  const GaugeLabel({
    required this.label,
    this.textAlign = TextAlign.center,
    this.style = const TextStyle(),
    this.offset,
    this.spaceExtent = 0.0,
  });
}

class GaugeTooltip {
  final Size size;
  final bool enabled;
  final Color color;
  final Color? borderColor;
  final Radius? radius;
  final GaugeTooltipType type;
  final GaugeTooltipPosition position;
  final PaintingStyle paintingStyle;
  final double thickness;
  final double offset;
  final StrokeCap strokeCap;
  final TextStyle textStyle;
  final String? label;
  final bool showPointer;
  const GaugeTooltip({
    this.showPointer = true,
    this.enabled = true,
    this.color = Colors.grey,
    this.radius,
    this.type = GaugeTooltipType.normal,
    this.position = GaugeTooltipPosition.top,
    this.paintingStyle = PaintingStyle.fill,
    this.thickness = 2.0,
    this.offset = 10.0,
    this.strokeCap = StrokeCap.butt,
    this.size = const Size(60, 30),
    this.textStyle = const TextStyle(),
    this.borderColor,
    this.label,
  });
}

/// Gauge value model
///
/// This model is used to represent the value of a gauge. It contains the value, the minimum value and the maximum value.
///
/// [value] double: The value of the gauge. It is required.
///
/// [min] double: The minimum value of the gauge. Default is 0.0.
///
/// [max] double: The maximum value of the gauge. Default is 100.0.
///
class GaugeValue extends Equatable {
  final double value;
  final double min;
  final double max;
  const GaugeValue({
    required this.value,
    this.min = 0.0,
    this.max = 100.0,
  })  : assert(min < max, 'min must be less than max'),
        assert(
            value >= min && value <= max, 'value must be between min and max');

  @override
  List<Object?> get props => <Object?>[value, min, max];
}

/// [LinearBarPointer] model
///
/// This model is used to represent the bar pointer of a linear gauge. It contains the value, the color, the thickness, the position, the shader callback, the border color, the border width, the offset, the radius, the painting style, the stroke cap and the label.
class LinearBarPointer {
  /// Specifies the value of the bar pointer. It is required.
  ///
  /// [value] double: The value of the bar pointer. The value must be between the `minimum` and `maximum` value of the gauge.
  /// ```dart
  /// LinearBarPointer(
  ///  value: 50,
  /// )
  final double value;

  /// Specifies the color of the bar pointer. Default is Colors.blue.
  ///
  /// [color] Color: The color of the bar pointer.
  /// ```dart
  /// LinearBarPointer(
  ///  value: 50,
  ///  color: Colors.blue,
  /// )
  /// ```
  ///
  final Color color;

  /// Specifies the thickness of the bar pointer. Default is 5.0.
  ///
  /// [thickness] double: The thickness of the bar pointer.
  ///
  /// ```dart
  /// LinearBarPointer(
  ///  value: 50,
  ///  thickness: 5.0,
  /// )
  /// ```
  final double thickness;

  /// Specifies the position of the bar pointer when the Gauge is Scale. Default is LinearElementPosition.cross.
  ///
  /// [position] LinearElementPosition: The position of the bar pointer.
  ///
  /// ```dart
  /// LinearBarPointer(
  ///  value: 50,
  ///  position: LinearElementPosition.cross,
  /// )
  /// ```
  final LinearElementPosition position;

  /// Specifies the shader callback of the bar pointer. Default is null.
  ///
  /// [shaderCallback] Shader Function(Rect): The shader callback of the bar pointer.
  ///
  /// ```dart
  /// LinearBarPointer(
  ///  value: 50,
  ///  shaderCallback: (Rect rect) {
  ///    return LinearGradient(
  ///      colors: [Colors.blue, Colors.green],
  ///      begin: Alignment.topCenter,
  ///      end: Alignment.bottomCenter,
  ///  ).createShader(rect);
  /// }
  /// ```
  ///
  Shader Function(Rect)? shaderCallback;

  /// Specifies the offset of the bar pointer. Default is 0.0.
  ///
  /// [offset] double: The offset of the bar pointer.
  ///
  /// ```dart
  /// LinearBarPointer(
  ///  value: 50,
  ///  offset: 0.0,
  /// )
  /// ```
  ///
  final double offset;

  /// Specifies the radius of the bar pointer. Default is null.
  ///
  /// [radius] Radius: The radius of the bar pointer.
  ///
  /// ```dart
  /// LinearBarPointer(
  ///  value: 50,
  ///  radius: Radius.circular(10),
  /// )
  /// ```
  ///
  final Radius? radius;

  /// Specifies the painting style of the bar pointer. Default is PaintingStyle.fill.
  ///
  /// [paintingStyle] PaintingStyle: The painting style of the bar pointer.
  ///
  /// ```dart
  /// LinearBarPointer(
  ///  value: 50,
  ///  paintingStyle: PaintingStyle.fill,
  /// )
  /// ```
  ///
  final PaintingStyle paintingStyle;

  /// Specifies the stroke cap of the bar pointer. Default is StrokeCap.butt.
  ///
  /// [strokeCap] StrokeCap: The stroke cap of the bar pointer.
  ///
  /// ```dart
  /// LinearBarPointer(
  ///  value: 50,
  ///  strokeCap: StrokeCap.butt,
  /// )
  /// ```
  ///
  final StrokeCap strokeCap;

  /// Specifies the label of the bar pointer. Default is null.
  ///
  /// [label] GaugeLabel: The label of the bar pointer.
  ///
  /// ```dart
  /// LinearBarPointer(
  ///  value: 50,
  ///  label: GaugeLabel(
  ///    label: 'Label',
  ///    style: TextStyle(color: Colors.black),
  ///    textAlign: TextAlign.center,
  ///  ),
  /// )
  /// ```
  ///
  final GaugeLabel? label;

  LinearBarPointer({
    required this.value,
    this.color = Colors.blue,
    this.thickness = 5.0,
    this.position = LinearElementPosition.cross,
    this.shaderCallback,
    this.radius,
    this.offset = 0.0,
    this.paintingStyle = PaintingStyle.fill,
    this.strokeCap = StrokeCap.butt,
    this.label,
  });
}

// Directional Linear Gauge
