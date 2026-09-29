import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

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
  testWidgets('GxProgressLinearGauge (dense, needle, label)', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      const GxProgressLinearGauge(
        value: GaugeValue(value: 40),
        needle: LinearNeedle(),
        showLabel: true,
        label: GaugeLabel(label: '{value}%'),
      ),
    );
  });

  testWidgets('GxProgressLinearGauge (not dense, reversed)', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      const GxProgressLinearGauge(
        value: GaugeValue(value: 70, min: 50),
        style: ProgressLinearStyle(dense: false),
        height: 20,
        reverse: true,
      ),
    );
  });

  testWidgets('GxAnimatedProgressLinearGauge animates to its value', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      const GxAnimatedProgressLinearGauge(
        value: 60,
        style: ProgressLinearStyle(),
        duration: Duration(milliseconds: 100),
      ),
    );
  });

  testWidgets('GxStepperLinearGauge', (WidgetTester tester) async {
    await _pump(
      tester,
      const GxStepperLinearGauge(
        value: GaugeValue(value: 2, max: 4),
        stepperPointers: <StepperPointer>[
          StepperPointer(label: GaugeLabel(label: 'One')),
          StepperPointer(label: GaugeLabel(label: 'Two')),
          StepperPointer(label: GaugeLabel(label: 'Three')),
        ],
      ),
    );
  });

  testWidgets('GxScaleLinearGauge (ticks, labels, needle)', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      const GxScaleLinearGauge(
        value: 30,
        interval: 10,
        needle: LinearNeedle(),
        size: Size(300, 60),
      ),
    );
  });

  testWidgets('GxScaleLinearGauge (bar pointers inside)', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      GxScaleLinearGauge(
        interval: 20,
        tickPosition: LinearElementPosition.inside,
        barHeight: 10,
        barPointers: <LinearBarPointer>[
          LinearBarPointer(value: 30, color: Colors.green),
          LinearBarPointer(value: 40, color: Colors.orange),
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
        value: const GaugeValue(value: 45),
        size: const Size(300, 20),
        needle: const LinearNeedle(),
        tooltip: const GaugeTooltip(),
        barPointers: <LinearBarPointer>[
          LinearBarPointer(value: 30, color: Colors.green),
          LinearBarPointer(value: 30, color: Colors.orange),
          LinearBarPointer(value: 40, color: Colors.red),
        ],
      ),
    );
  });

  testWidgets('GxRadialGauge (default)', (WidgetTester tester) async {
    await _pump(tester, const GxRadialGauge(value: GaugeValue(value: 30)));
  });

  testWidgets('GxRadialGauge (ticks, labels, needle, 270° sweep)', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      const GxRadialGauge(
        value: GaugeValue(value: 65),
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
