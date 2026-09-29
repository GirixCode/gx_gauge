import 'dart:math';

/// Degree/radian conversion.
abstract final class AngleUtils {
  /// Converts [degrees] to radians.
  static double degreesToRadians(double degrees) => degrees * (pi / 180);

  /// Converts [radians] to degrees.
  static double radiansToDegrees(double radians) => radians * (180 / pi);
}
