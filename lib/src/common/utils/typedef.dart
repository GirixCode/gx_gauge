import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

typedef ValueToLabelCallback = GaugeLabel Function(double value, int index);

/// Callback to format the value to be displayed as label.
///
/// The [ValueToLabelFormatCallback] is used to format the value to be displayed as label in the gauge.
///
/// The [value] argument represents the value to be formatted.
///
/// The [index] argument represents the index of the value.
///
/// ```dart
/// String valueToLabelFormat(double value, int index) {
///   return value;
/// }
/// ```
///
typedef ValueToLabelFormatCallback = String Function(double value, int index);

typedef ValueToLabelStyleCallback = TextStyle Function(double value, int index);

/// Callback to format the value to be displayed as major tick.
///
/// The [ValueToMajorTickStyleCallback] is used to format the value to be displayed as major tick in the gauge.
///
/// The [value] argument represents the value to be formatted.
///
/// The [index] argument represents the index of the value.
///
/// ```dart
/// LinearTickStyle majorTickStyle(double value, int index) {
///  return LinearTickStyle(
///   length: 20,
///   thickness: 2,
///   color: Colors.blue,
/// );
/// }
/// ```
///
typedef ValueToMajorTickStyleCallback = LinearTickStyle Function(
    double value, int index);

/// Callback to format the value to be displayed as radial tick label.
///
/// The [ValueToRadialLabelStyleCallback] is used to format the value to be displayed as radial tick label in the gauge.
typedef ValueToRadialLabelStyleCallback = RadialTickLabelStyle Function(
    double value, int index);

typedef ValueToRadialMajorTickCallback = RadialTickStyle Function(
    double value, int index);
