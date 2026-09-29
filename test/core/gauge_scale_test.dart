import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';

void main() {
  group('GaugeScale.fractionOf', () {
    test('normalises with (value - min) / (max - min)', () {
      const GaugeScale scale = GaugeScale(-50, 50);
      expect(scale.fractionOf(-50), 0);
      expect(scale.fractionOf(0), 0.5);
      expect(scale.fractionOf(50), 1);
    });

    test('clamps out-of-range values and maps NaN to 0', () {
      const GaugeScale scale = GaugeScale(20, 120);
      expect(scale.fractionOf(-1000), 0);
      expect(scale.fractionOf(1000), 1);
      expect(scale.fractionOf(double.nan), 0);
    });

    test('valueAt is the inverse of fractionOf', () {
      const GaugeScale scale = GaugeScale(10, 30);
      for (final double v in <double>[10, 12.5, 20, 30]) {
        expect(scale.valueAt(scale.fractionOf(v)), closeTo(v, 1e-12));
      }
    });
  });

  group('GaugeScale.ticks', () {
    test('steps by interval from min to max', () {
      expect(const GaugeScale(0, 100).ticks(25), <double>[0, 25, 50, 75, 100]);
      expect(const GaugeScale(50, 100).ticks(10), hasLength(6));
    });

    test('defaults to a tenth of the range', () {
      expect(const GaugeScale(0, 1).ticks(null), hasLength(11));
    });

    test('falls back to a tenth of the range for 0, negative or NaN', () {
      for (final double interval in <double>[0, -5, double.nan]) {
        expect(const GaugeScale(0, 100).ticks(interval), hasLength(11));
      }
    });

    test('returns [min, max] when the interval covers the range', () {
      expect(const GaugeScale(0, 1).ticks(10), <double>[0, 1]);
      expect(const GaugeScale(0, 100).ticks(100), <double>[0, 100]);
    });

    test('stops at the last multiple below max', () {
      expect(const GaugeScale(0, 100).ticks(30), <double>[0, 30, 60, 90]);
    });

    test('is robust to floating-point drift', () {
      final List<double> ticks = const GaugeScale(0, 0.3).ticks(0.1);
      expect(ticks, hasLength(4));
      expect(ticks.last, closeTo(0.3, 1e-12));
    });

    test('caps the number of ticks', () {
      expect(const GaugeScale(0, 1e9).ticks(1), hasLength(GaugeScale.maxTicks));
    });

    test('never produces NaN or infinity', () {
      final List<double> ticks = <double>[
        ...const GaugeScale(-1, 1).ticks(0.25),
        ...const GaugeScale(0, 1).ticks(3),
        ...const GaugeScale(0, 100).ticks(1e-300),
      ];
      expect(ticks.every((double t) => t.isFinite), isTrue);
    });
  });

  group('LinearTrack', () {
    test('maps fractions left to right', () {
      const LinearTrack track = LinearTrack(start: 10, end: 110);
      expect(track.xOf(0), 10);
      expect(track.xOf(0.5), 60);
      expect(track.xOf(1), 110);
    });

    test('maps fractions right to left when reversed', () {
      const LinearTrack track = LinearTrack(
        start: 10,
        end: 110,
        reversed: true,
      );
      expect(track.xOf(0), 110);
      expect(track.xOf(1), 10);
    });
  });

  group('formatGaugeValue', () {
    test('drops trailing zeros', () {
      expect(formatGaugeValue(40), '40');
      expect(formatGaugeValue(12.5), '12.5');
      expect(formatGaugeValue(12.54), '12.5');
      expect(formatGaugeValue(-0.01), '0');
      expect(formatGaugeValue(3.14159, fractionDigits: 3), '3.142');
    });
  });
}
