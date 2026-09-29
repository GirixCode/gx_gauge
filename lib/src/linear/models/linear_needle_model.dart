import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:girix_code_gauge/src/common/models/enums.dart';

class LinearNeedle extends Equatable {
  final LinearGaugeNeedleType needleType;
  final LinearGaugeNeedlePosition position;
  final Size size;
  final Color color;
  final bool enabled;
  final LinearNeedleLabel? label;
  final double offset;
  const LinearNeedle({
    this.needleType = LinearGaugeNeedleType.rectangle,
    this.position = LinearGaugeNeedlePosition.center,
    this.size = const Size(10, 10),
    this.color = const Color(0xFF000000),
    this.enabled = true,
    this.label,
    this.offset = 2,
  });

  @override
  List<Object?> get props =>
      <Object?>[needleType, position, size, color, enabled, label, offset];
}

// Needle Label
class LinearNeedleLabel extends Equatable {
  /// [label] is the text that will be displayed on the needle such as the value of the gauge.

  final String label;

  /// [textStyle] is the style of the text that will be displayed on the needle.
  final TextStyle? textStyle;

  /// [offset] is the offset of the text from the needle in pixels (default is 0).
  final double offset;

  const LinearNeedleLabel({
    required this.label,
    this.textStyle,
    this.offset = 0,
  });

  @override
  List<Object?> get props => <Object?>[label, textStyle, offset];
}
