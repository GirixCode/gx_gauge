// BarLinearGaugeStyle
import 'package:flutter/material.dart';

class LinearBarGaugeStyle {
  final Color color;
  final double thickness;
  final Radius? radius;
  final double? width;
  final double? height;
  const LinearBarGaugeStyle({
    this.width = 100.0,
    this.height = 10,
    this.color = Colors.blue,
    this.thickness = 10.0,
    this.radius = const Radius.circular(10),
  });
}

// class LinearBarPointer {
//   /// Specifies the value of the pointer.
//   ///
//   /// The value must be non-null.
//   ///
//   /// ```dart
//   /// LinearBarPointer(
//   ///  value: 50.0,
//   /// )
//   /// ```
//   ///
//   final double value;

//   /// Specifies the style of the pointer.
//   ///
//   /// The default value is [LinearBarGaugeStyle].
//   ///
//   /// ```dart
//   /// LinearBarPointer(
//   ///   style: LinearBarGaugeStyle(
//   ///     color: Colors.red,
//   ///     thickness: 10.0,
//   ///   ),
//   /// )
//   /// ```
//   final LinearBarGaugeStyle style;

//   LinearBarPointer({
//     required this.value,
//     this.style = const LinearBarGaugeStyle(),
//   });
// }
