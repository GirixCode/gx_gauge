import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';

/// Every gauge, fully configured, at [value] on a 0..100 scale.
List<Widget> _gauges(double value, {Axis direction = Axis.horizontal}) {
  final GxGaugeValue v = GxGaugeValue(value: value);
  const List<GxLinearBarPointer> bars = <GxLinearBarPointer>[
    GxLinearBarPointer(start: 0, end: 50, label: GxGaugeLabel(label: 'a')),
    GxLinearBarPointer(start: 50, end: 100),
  ];
  return <Widget>[
    GxLinearProgressGauge(
      value: v,
      direction: direction,
      needle: const GxLinearNeedle(label: GxNeedleLabel(label: '{value}')),
      label: const GxGaugeLabel(label: '{value}'),
      showLabel: true,
      onChanged: (_) {},
    ),
    GxLinearScaleGauge(
      value: v,
      direction: direction,
      needle: const GxLinearNeedle(),
      bars: bars,
      ranges: const <GxLinearRange>[
        GxLinearRange(start: 0, end: 30, label: GxGaugeLabel(label: 'r')),
      ],
      markers: const <GxLinearMarkerPointer>[
        GxLinearMarkerPointer(value: 20, marker: Icon(Icons.flag)),
      ],
      onChanged: (_) {},
    ),
    GxLinearBarGauge(
      value: v,
      direction: direction,
      bars: bars,
      gapBetweenBars: 4,
      needle: const GxLinearNeedle(),
      tooltip: const GxGaugeTooltip(),
      onChanged: (_) {},
    ),
    GxLinearStepperGauge(
      currentStep: value ~/ 50,
      direction: direction,
      steps: const <GxStepperStep>[
        GxStepperStep(label: GxGaugeLabel(label: 'a')),
        GxStepperStep(label: GxGaugeLabel(label: 'b')),
        GxStepperStep(label: GxGaugeLabel(label: 'c')),
      ],
      onStepTapped: (_) {},
    ),
    GxRadialGauge(
      value: v,
      showMajorTicks: true,
      showMinorTicks: true,
      showLabels: true,
      showNeedle: true,
      needle: const GxRadialNeedle(),
      pointers: const <GxRadialPointer>[GxRadialPointer(value: 40)],
      ranges: const <GxRadialRange>[
        GxRadialRange(start: 0, end: 40, label: GxGaugeLabel(label: 'r')),
      ],
      onChanged: (_) {},
    ),
  ];
}

Future<void> _expectRenders(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

void main() {
  testWidgets('value at min and at max', (WidgetTester tester) async {
    for (final double value in <double>[0, 100]) {
      for (final Widget gauge in _gauges(value)) {
        await _expectRenders(tester, Center(child: gauge));
      }
    }
  });

  testWidgets('a 0×0 box', (WidgetTester tester) async {
    for (final Widget gauge in _gauges(50)) {
      await _expectRenders(
        tester,
        Center(child: SizedBox.shrink(child: gauge)),
      );
    }
  });

  testWidgets('fully unbounded constraints fall back to 200', (
    WidgetTester tester,
  ) async {
    for (final Axis direction in Axis.values) {
      for (final Widget gauge in _gauges(50, direction: direction)) {
        await _expectRenders(
          tester,
          SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: gauge,
            ),
          ),
        );
        final Size size = tester.getSize(find.byWidget(gauge));
        expect(
          size.longestSide,
          200,
          reason: '${gauge.runtimeType} $direction',
        );
      }
    }
  });

  testWidgets('radial gauges fit a single bounded side', (
    WidgetTester tester,
  ) async {
    const Widget gauge = GxRadialGauge(value: GxGaugeValue(value: 1));
    await _expectRenders(
      tester,
      const SingleChildScrollView(child: SizedBox(width: 120, child: gauge)),
    );
    expect(tester.getSize(find.byWidget(gauge)), const Size(120, 120));

    await _expectRenders(
      tester,
      const SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(height: 90, child: gauge),
      ),
    );
    expect(tester.getSize(find.byWidget(gauge)), const Size(90, 90));
  });

  testWidgets('unmounting mid-animation leaves no ticker running', (
    WidgetTester tester,
  ) async {
    for (final Widget Function(double) build in <Widget Function(double)>[
      (double v) => GxLinearProgressGauge(
        value: GxGaugeValue(value: v),
        duration: const Duration(seconds: 1),
      ),
      (double v) => GxRadialGauge(
        value: GxGaugeValue(value: v),
        duration: const Duration(seconds: 1),
      ),
    ]) {
      await tester.pumpWidget(MaterialApp(home: build(0)));
      await tester.pumpWidget(MaterialApp(home: build(100)));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(tester.binding.hasScheduledFrame, isFalse);
    }
  });

  testWidgets('vertical gauges accept vertical drags', (
    WidgetTester tester,
  ) async {
    final List<double> values = <double>[];
    await _expectRenders(
      tester,
      Center(
        child: SizedBox(
          height: 200,
          child: GxLinearBarGauge(
            value: const GxGaugeValue(value: 10),
            direction: Axis.vertical,
            bars: const <GxLinearBarPointer>[
              GxLinearBarPointer(start: 0, end: 100),
            ],
            onChanged: values.add,
          ),
        ),
      ),
    );
    final Rect box = tester.getRect(find.byType(GxLinearBarGauge));
    // A tap 20% of the way up the track reports 20.
    await tester.tapAt(box.bottomCenter - Offset(0, box.height * 0.2));
    expect(values.single, closeTo(20, 0.5));
    values.clear();
    // Dragging upwards increases the value.
    await tester.dragFrom(
      box.bottomCenter - const Offset(0, 20),
      const Offset(0, -100),
    );
    expect(values.last, greaterThan(values.first));
  });

  testWidgets('widgets and models describe themselves for DevTools', (
    WidgetTester tester,
  ) async {
    for (final Widget gauge in _gauges(40)) {
      expect(gauge.toStringDeep(), isNotEmpty);
      await _expectRenders(tester, Center(child: gauge));
      expect(
        tester.element(find.byWidget(gauge)).toStringDeep(),
        contains('value'),
      );
    }
  });
}
