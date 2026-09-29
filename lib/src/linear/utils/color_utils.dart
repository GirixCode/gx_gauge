import 'package:flutter/material.dart';

class ColorUtils {
  // Get Material Color from Color

  static MaterialColor getMaterialColor(Color color) {
    final Map<int, Color> colorSwatch = <int, Color>{
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color, // Primary color
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    };

    return MaterialColor(color.toARGB32(), colorSwatch);
  }

  /// Darkens [color] towards black by [factor] (0 = unchanged, 1 = black).
  static Color shadeColor(Color color, double factor) {
    return Color.from(
      alpha: 1,
      red: color.r * (1 - factor),
      green: color.g * (1 - factor),
      blue: color.b * (1 - factor),
    );
  }

  /// Lightens [color] towards white by [factor] (0 = unchanged, 1 = white).
  static Color tintColor(Color color, double factor) {
    return Color.from(
      alpha: 1,
      red: color.r + (1 - color.r) * factor,
      green: color.g + (1 - color.g) * factor,
      blue: color.b + (1 - color.b) * factor,
    );
  }
}
