// lib/src/common/animations/animation_utils.dart

import 'package:flutter/animation.dart';

class AnimationUtils {
  ///
  /// Create a tween animation with the given parameters
  ///
  /// [vsync] TickerProvider: The TickerProvider to use for the AnimationController.
  ///
  /// [begin] double: The initial value of the animation.
  ///
  /// [end] double: The final value of the animation.
  ///
  /// [duration] Duration: The duration of the animation.
  ///
  static Animation<double> createTween({
    required TickerProvider vsync,
    required double begin,
    required double end,
    required Duration duration,
  }) {
    final AnimationController controller =
        AnimationController(vsync: vsync, duration: duration);
    final Animation<double> animation =
        Tween<double>(begin: begin, end: end).animate(controller);
    controller.forward();
    return animation;
  }
}
