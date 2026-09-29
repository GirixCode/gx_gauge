import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/src/core/linear_frame.dart';

void main() {
  group('LinearFrame', () {
    test('is the identity when horizontal', () {
      const LinearFrame frame = LinearFrame(Size(200, 40), vertical: false);
      expect(frame.logicalSize, const Size(200, 40));
      expect(frame.toScreen(const Offset(10, 5)), const Offset(10, 5));
    });

    test('runs logical x bottom to top when vertical', () {
      const LinearFrame frame = LinearFrame(Size(40, 200), vertical: true);
      expect(frame.logicalSize, const Size(200, 40));
      expect(frame.toScreen(Offset.zero), const Offset(0, 200));
      expect(frame.toScreen(const Offset(200, 0)), Offset.zero);
      expect(frame.toScreen(const Offset(50, 40)), const Offset(40, 150));
    });

    test('toLogical inverts toScreen', () {
      const LinearFrame frame = LinearFrame(Size(40, 200), vertical: true);
      const Offset p = Offset(73, 12);
      expect(frame.toLogical(frame.toScreen(p)), p);
    });
  });
}
