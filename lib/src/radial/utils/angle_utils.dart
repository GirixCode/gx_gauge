import 'dart:math';

class AngleUtils {
  static double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  static double radiansToDegrees(double radians) {
    return radians * (180 / pi);
  }
}
