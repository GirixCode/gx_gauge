import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';

/// Characterisation tests: every public gauge builds and paints its common
/// configurations without throwing. They guard the Phase 1 rename and the
/// Phase 2 refactors (see docs/PLAN.md).
Future<void> _pump(WidgetTester tester, Widget gauge) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(child: SizedBox(width: 300, child: gauge)),
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  expect(find.byType(CustomPaint), findsWidgets);
}

void main() {
  testWidgets('GxLinearProgressGauge (dense, needle, label)', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      const GxLinearProgressGauge(
        value: GxGaugeValue(value: 40),
        needle: GxLinearNeedle(),
        showLabel: true,
        label: GxGaugeLabel(label: '{value}%'),
      ),
    );
  });

  testWidgets('GxLinearProgressGauge (not dense, reversed)', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      const GxLinearProgressGauge(
        value: GxGaugeValue(value: 70, min: 50),
        style: GxLinearProgressStyle(dense: false),
        height: 20,
        reverse: true,
      ),
    );
  });

  testWidgets('GxAnimatedLinearProgressGauge animates to its value', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      const GxAnimatedLinearProgressGauge(
        value: 60,
        style: GxLinearProgressStyle(),
        duration: Duration(milliseconds: 100),
      ),
    );
  });

  testWidgets('GxLinearStepperGauge', (WidgetTester tester) async {
    await _pump(
      tester,
      const GxLinearStepperGauge(
        value: GxGaugeValue(value: 2, max: 4),
        steps: <GxStepperStep>[
          GxStepperStep(label: GxGaugeLabel(label: 'One')),
          GxStepperStep(label: GxGaugeLabel(label: 'Two')),
          GxStepperStep(label: GxGaugeLabel(label: 'Three')),
        ],
      ),
    );
  });

  testWidgets('GxLinearScaleGauge (ticks, labels, needle)', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      const GxLinearScaleGauge(
        value: GxGaugeValue(value: 30),
        interval: 10,
        needle: GxLinearNeedle(),
        size: Size(300, 60),
      ),
    );
  });

  testWidgets('GxLinearScaleGauge (bar pointers inside)', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      GxLinearScaleGauge(
        interval: 20,
        tickPosition: GxElementPosition.inside,
        barHeight: 10,
        bars: <GxLinearBarPointer>[
          GxLinearBarPointer(value: 30, color: Colors.green),
          GxLinearBarPointer(value: 40, color: Colors.orange),
        ],
        size: const Size(300, 60),
      ),
    );
  });

  testWidgets('GxLinearBarGauge (needle, tooltip)', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      GxLinearBarGauge(
        value: const GxGaugeValue(value: 45),
        size: const Size(300, 20),
        needle: const GxLinearNeedle(),
        tooltip: const GxGaugeTooltip(),
        bars: <GxLinearBarPointer>[
          GxLinearBarPointer(value: 30, color: Colors.green),
          GxLinearBarPointer(value: 30, color: Colors.orange),
          GxLinearBarPointer(value: 40, color: Colors.red),
        ],
      ),
    );
  });

  testWidgets('GxRadialGauge (default)', (WidgetTester tester) async {
    await _pump(tester, const GxRadialGauge(value: GxGaugeValue(value: 30)));
  });

  testWidgets('GxRadialGauge (ticks, labels, needle, 270° sweep)', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      const GxRadialGauge(
        value: GxGaugeValue(value: 65),
        startAngleInDegree: 135,
        sweepAngleInDegree: 270,
        showMajorTicks: true,
        showMinorTicks: true,
        showLabels: true,
        showNeedle: true,
      ),
    );
  });
}
