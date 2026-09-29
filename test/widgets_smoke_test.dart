import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';

/// Every public gauge builds and paints its common configurations without
/// throwing.
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

const List<GxLinearBarPointer> _bars = <GxLinearBarPointer>[
  GxLinearBarPointer(start: 0, end: 30, color: Colors.green),
  GxLinearBarPointer(start: 30, end: 60, color: Colors.orange),
  GxLinearBarPointer(start: 60, end: 100, color: Colors.red),
];

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

  testWidgets('GxLinearStepperGauge', (WidgetTester tester) async {
    await _pump(
      tester,
      const GxLinearStepperGauge(
        currentStep: 1,
        steps: <GxStepperStep>[
          GxStepperStep(label: GxGaugeLabel(label: 'One')),
          GxStepperStep(label: GxGaugeLabel(label: 'Two')),
          GxStepperStep(label: GxGaugeLabel(label: 'Three')),
        ],
      ),
    );
  });

  testWidgets('GxLinearScaleGauge (ticks, labels, needle, bars)', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      const GxLinearScaleGauge(
        value: GxGaugeValue(value: 30),
        interval: 10,
        needle: GxLinearNeedle(),
        bars: _bars,
        markers: <GxLinearMarkerPointer>[
          GxLinearMarkerPointer(value: 80, needle: GxLinearNeedle()),
        ],
        ranges: <GxLinearRange>[
          GxLinearRange(
            start: 0,
            end: 30,
            color: Colors.green,
            label: GxGaugeLabel(label: 'Low'),
          ),
        ],
      ),
    );
  });

  testWidgets('GxLinearBarGauge (needle, tooltip, gaps)', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      const GxLinearBarGauge(
        value: GxGaugeValue(value: 45),
        bars: _bars,
        gapBetweenBars: 4,
        needle: GxLinearNeedle(),
        tooltip: GxGaugeTooltip(),
      ),
    );
  });

  testWidgets('GxRadialGauge (default)', (WidgetTester tester) async {
    await _pump(tester, const GxRadialGauge(value: GxGaugeValue(value: 30)));
  });

  testWidgets('GxRadialGauge (everything on)', (WidgetTester tester) async {
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
        needle: GxRadialNeedle(
          cap: GxNeedleCap(paintingStyle: PaintingStyle.stroke),
        ),
        pointers: <GxRadialPointer>[GxRadialPointer(value: 20)],
        ranges: <GxRadialRange>[
          GxRadialRange(start: 0, end: 40, label: GxGaugeLabel(label: 'Low')),
        ],
      ),
    );
  });
}
