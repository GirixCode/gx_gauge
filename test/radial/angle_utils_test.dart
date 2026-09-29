import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/src/radial/utils/angle_utils.dart';

void main() {
  group('AngleUtils', () {
    test('converts degrees to radians', () {
      expect(AngleUtils.degreesToRadians(0), 0);
      expect(AngleUtils.degreesToRadians(180), closeTo(math.pi, 1e-12));
      expect(AngleUtils.degreesToRadians(-90), closeTo(-math.pi / 2, 1e-12));
    });

    test('converts radians to degrees', () {
      expect(AngleUtils.radiansToDegrees(math.pi), closeTo(180, 1e-12));
    });

    test('round-trips', () {
      for (final double deg in <double>[-720, -45, 0, 33.3, 270, 360]) {
        expect(
          AngleUtils.radiansToDegrees(AngleUtils.degreesToRadians(deg)),
          closeTo(deg, 1e-9),
        );
      }
    });
  });
}
