import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/src/core/gauge_defaults.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/painter_config.dart';

class _Config extends PainterConfig {
  const _Config(this.a, this.list);
  final int a;
  final List<int> list;

  @override
  List<Object?> get props => <Object?>[a, list];
}

class _Other extends PainterConfig {
  const _Other(this.a);
  final int a;

  @override
  List<Object?> get props => <Object?>[a];
}

void main() {
  group('GaugeScale / LinearTrack value semantics', () {
    test('equality, hashCode and toString', () {
      expect(const GaugeScale(0, 1), const GaugeScale(0, 1));
      expect(const GaugeScale(0, 1).hashCode, const GaugeScale(0, 1).hashCode);
      expect(const GaugeScale(0, 1), isNot(const GaugeScale(0, 2)));
      expect(const GaugeScale(0, 1).toString(), 'GaugeScale(0.0, 1.0)');

      const LinearTrack a = LinearTrack(start: 0, end: 10);
      expect(a, const LinearTrack(start: 0, end: 10));
      expect(a.hashCode, const LinearTrack(start: 0, end: 10).hashCode);
      expect(a, isNot(const LinearTrack(start: 0, end: 10, reversed: true)));
    });

    test('clamp and fractionAt handle edge input', () {
      const GaugeScale scale = GaugeScale(10, 20);
      expect(scale.clamp(double.nan), 10);
      expect(scale.clamp(25), 20);
      expect(const LinearTrack(start: 5, end: 5).fractionAt(5), 0);
      expect(const LinearTrack(start: 0, end: 100).fractionAt(-5), 0);
      expect(
        const LinearTrack(start: 0, end: 100, reversed: true).fractionAt(25),
        0.75,
      );
    });

    test('formatGaugeValue passes non-finite values through', () {
      expect(formatGaugeValue(double.nan), 'NaN');
      expect(formatGaugeValue(double.infinity), 'Infinity');
      expect(formatGaugeValue(7, fractionDigits: 0), '7');
    });
  });

  group('PainterConfig', () {
    test('compares props, with lists element-wise', () {
      expect(const _Config(1, <int>[1, 2]), const _Config(1, <int>[1, 2]));
      expect(
        const _Config(1, <int>[1, 2]).hashCode,
        const _Config(1, <int>[1, 2]).hashCode,
      );
      expect(
        const _Config(1, <int>[1, 2]),
        isNot(const _Config(1, <int>[2, 1])),
      );
      expect(const _Config(1, <int>[]), isNot(const _Config(2, <int>[])));
    });

    test('is never equal to a different config type', () {
      expect(const _Config(1, <int>[]), isNot(const _Other(1)));
    });
  });

  testWidgets('GaugeDefaults follow the theme and compare by value', (
    WidgetTester tester,
  ) async {
    late GaugeDefaults light;
    late GaugeDefaults lightAgain;
    late GaugeDefaults dark;
    Widget probe(ThemeData theme, void Function(GaugeDefaults) out) =>
        MaterialApp(
          theme: theme,
          home: Builder(
            builder: (BuildContext context) {
              out(GaugeDefaults.of(context));
              return const SizedBox();
            },
          ),
        );

    await tester.pumpWidget(
      probe(ThemeData.light(), (GaugeDefaults d) => light = d),
    );
    await tester.pumpAndSettle();
    await tester.pumpWidget(
      probe(ThemeData.light(), (GaugeDefaults d) => lightAgain = d),
    );
    await tester.pumpAndSettle();
    await tester.pumpWidget(
      probe(ThemeData.dark(), (GaugeDefaults d) => dark = d),
    );
    await tester.pumpAndSettle();

    expect(light, lightAgain);
    expect(light.hashCode, lightAgain.hashCode);
    expect(light, isNot(dark));
    expect(dark.primary, ThemeData.dark().colorScheme.primary);
  });
}
