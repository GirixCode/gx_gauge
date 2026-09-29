import 'dart:math' as math;

import 'package:flutter/painting.dart';

/// Maps a linear gauge's horizontal *logical* drawing space onto the widget.
///
/// Linear painters always draw as if the gauge were horizontal: the track runs
/// along x and the cross axis along y. For a vertical gauge, [apply] rotates
/// the canvas a quarter turn counter-clockwise, so logical x runs bottom to top
/// and logical y (top → bottom) runs left → right on screen.
class LinearFrame {
  /// Creates a frame for a widget of [size].
  const LinearFrame(this.size, {required this.vertical});

  /// The widget's size on screen.
  final Size size;

  /// Whether the gauge is drawn vertically.
  final bool vertical;

  /// The size painters draw into: [size], or [size] flipped when [vertical].
  Size get logicalSize => vertical ? size.flipped : size;

  /// Transforms [canvas] so logical coordinates land in the right place.
  /// Call inside `canvas.save()`/`canvas.restore()`.
  void apply(Canvas canvas) {
    if (vertical) {
      canvas
        ..translate(0, size.height)
        ..rotate(-math.pi / 2);
    }
  }

  /// Converts a logical point to widget coordinates.
  Offset toScreen(Offset logical) =>
      vertical ? Offset(logical.dy, size.height - logical.dx) : logical;

  /// Converts a point in widget coordinates to logical coordinates.
  Offset toLogical(Offset screen) =>
      vertical ? Offset(size.height - screen.dy, screen.dx) : screen;
}
