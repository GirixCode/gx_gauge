import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge/src/linear/painters/progress_linear_painter.dart';

Widget _app(Widget child, {TextDirection direction = TextDirection.ltr}) {
  return MaterialApp(
    home: Directionality(
      textDirection: direction,
      child: Scaffold(
        body: Center(child: SizedBox(width: 200, child: child)),
      ),
    ),
  );
}

ProgressLinearPainter _progressPainter(WidgetTester tester) =>
    tester
            .widget<CustomPaint>(
              find.descendant(
                of: find.byType(GxLinearProgressGauge),
                matching: find.byType(CustomPaint),
              ),
            )
            .painter!
        as ProgressLinearPainter;

GxLinearProgressGauge _gauge(
  double value, {
  Duration duration = const Duration(milliseconds: 200),
  Curve curve = Curves.linear,
}) => GxLinearProgressGauge(
  value: GxGaugeValue(value: value),
  duration: duration,
  curve: curve,
  semanticLabel: 'Progress',
);

void main() {
  group('Implicit animation', () {
    testWidgets('animates from the old value to the new one', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(_gauge(0)));
      await tester.pumpWidget(_app(_gauge(100)));
      await tester.pump(const Duration(milliseconds: 100));
      expect(_progressPainter(tester).value.value, closeTo(50, 1));
      await tester.pumpAndSettle();
      expect(_progressPainter(tester).value.value, 100);
    });

    testWidgets('an interrupted animation continues from the current value', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(_gauge(0)));
      await tester.pumpWidget(_app(_gauge(100)));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpWidget(_app(_gauge(0)));
      await tester.pump();
      expect(_progressPainter(tester).value.value, closeTo(50, 1));
    });

    testWidgets('an overshooting curve near max does not assert', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(_gauge(0, curve: Curves.elasticOut)));
      await tester.pumpWidget(_app(_gauge(100, curve: Curves.elasticOut)));
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 10));
        expect(tester.takeException(), isNull);
      }
      await tester.pumpAndSettle();
    });

    testWidgets('settles without scheduling further frames', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(_gauge(0)));
      for (final double v in <double>[20, 60, 10, 90]) {
        await tester.pumpWidget(_app(_gauge(v)));
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('is off by default', (WidgetTester tester) async {
      await tester.pumpWidget(_app(_gauge(0, duration: Duration.zero)));
      await tester.pumpWidget(_app(_gauge(80, duration: Duration.zero)));
      await tester.pump();
      expect(_progressPainter(tester).value.value, 80);
    });
  });

  testWidgets('exposes label and value to semantics', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        GxRadialGauge(
          value: const GxGaugeValue(value: 42),
          semanticLabel: 'Speed',
          semanticValueFormatter: (double v) => '${v.toInt()} km/h',
        ),
      ),
    );
    expect(
      tester.getSemantics(find.byType(GxRadialGauge)),
      matchesSemantics(label: 'Speed', value: '42 km/h'),
    );
    handle.dispose();
  });

  testWidgets('linear gauges mirror in right-to-left', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _app(_gauge(10, duration: Duration.zero), direction: TextDirection.rtl),
    );
    expect(_progressPainter(tester).config.reversed, isTrue);

    await tester.pumpWidget(
      _app(
        const GxLinearProgressGauge(
          value: GxGaugeValue(value: 10),
          reverse: true,
        ),
        direction: TextDirection.rtl,
      ),
    );
    expect(_progressPainter(tester).config.reversed, isFalse);
  });

  testWidgets('defaults follow the theme', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorSchemeSeed: Colors.teal),
        home: const Scaffold(
          body: GxLinearProgressGauge(value: GxGaugeValue(value: 10)),
        ),
      ),
    );
    final ThemeData theme = Theme.of(
      tester.element(find.byType(GxLinearProgressGauge)),
    );
    expect(_progressPainter(tester).config.color, theme.colorScheme.primary);
  });

  group('Sizing', () {
    testWidgets('linear gauges fill the width', (WidgetTester tester) async {
      await tester.pumpWidget(_app(_gauge(10)));
      expect(
        tester.getSize(find.byType(CustomPaint).last),
        const Size(200, 10),
      );
    });

    testWidgets('linear gauges fall back to 200 wide when unbounded', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(children: <Widget>[UnconstrainedBox(child: _gauge(10))]),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(GxLinearProgressGauge)).width, 200);
    });

    testWidgets('radial gauges take the shortest bounded side', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _app(const GxRadialGauge(value: GxGaugeValue(value: 10))),
      );
      expect(tester.getSize(find.byType(GxRadialGauge)), const Size(200, 200));
    });

    testWidgets('radial gauges honour an explicit diameter', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const Center(
            child: GxRadialGauge(value: GxGaugeValue(value: 10), diameter: 80),
          ),
        ),
      );
      expect(tester.getSize(find.byType(GxRadialGauge)), const Size(80, 80));
    });
  });
}
