import 'package:flutter_test/flutter_test.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

void main() {
  group('GaugeValue', () {
    test('defaults to a 0..100 range', () {
      const GaugeValue value = GaugeValue(value: 40);
      expect(value.min, 0);
      expect(value.max, 100);
    });

    test('is equal by value, min and max', () {
      expect(
        const GaugeValue(value: 10, min: -5, max: 20),
        const GaugeValue(value: 10, min: -5, max: 20),
      );
      expect(const GaugeValue(value: 10), isNot(const GaugeValue(value: 11)));
    });

    test('asserts min < max', () {
      expect(
        () => GaugeValue(value: 5, min: 10, max: 10),
        throwsA(isA<AssertionError>()),
      );
    });

    test('asserts value within [min, max]', () {
      expect(() => GaugeValue(value: 101), throwsA(isA<AssertionError>()));
      expect(() => GaugeValue(value: -1), throwsA(isA<AssertionError>()));
    });
  });
}
