import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';

void main() {
  group('GxGaugeValue', () {
    test('defaults to a 0..100 range', () {
      const GxGaugeValue value = GxGaugeValue(value: 40);
      expect(value.min, 0);
      expect(value.max, 100);
      expect(value.fraction, 0.4);
    });

    test('is equal by value, min and max', () {
      expect(
        const GxGaugeValue(value: 10, min: -5, max: 20),
        const GxGaugeValue(value: 10, min: -5, max: 20),
      );
      expect(
        const GxGaugeValue(value: 10).hashCode,
        const GxGaugeValue(value: 10).hashCode,
      );
      expect(
        const GxGaugeValue(value: 10),
        isNot(const GxGaugeValue(value: 11)),
      );
    });

    test('asserts min < max', () {
      expect(
        () => GxGaugeValue(value: 5, min: 10, max: 10),
        throwsA(isA<AssertionError>()),
      );
    });

    test('asserts value within [min, max]', () {
      expect(() => GxGaugeValue(value: 101), throwsA(isA<AssertionError>()));
      expect(() => GxGaugeValue(value: -1), throwsA(isA<AssertionError>()));
    });

    test('copyWith replaces only the given fields', () {
      const GxGaugeValue value = GxGaugeValue(value: 10, max: 50);
      expect(value.copyWith(value: 20), const GxGaugeValue(value: 20, max: 50));
      expect(value.copyWith(), value);
    });

    test('lerp interpolates and keeps the value in range', () {
      final GxGaugeValue mid = GxGaugeValue.lerp(
        const GxGaugeValue(value: 0),
        const GxGaugeValue(value: 100),
        0.5,
      );
      expect(mid.value, 50);
    });
  });
}
