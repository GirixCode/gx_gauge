import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/core/text_utils.dart';
import 'package:gx_gauge/src/linear/painters/progress_linear_painter.dart';
import 'package:gx_gauge/src/radial/painters/radial_gauge_painter.dart';

import '../helpers/recording_canvas.dart';

Widget _app(
  Widget child, {
  bool disableAnimations = false,
  TextScaler textScaler = TextScaler.noScaling,
}) {
  return MaterialApp(
    builder: (BuildContext context, Widget? home) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(disableAnimations: disableAnimations, textScaler: textScaler),
      child: home!,
    ),
    home: Scaffold(
      body: Center(child: SizedBox(width: 200, height: 200, child: child)),
    ),
  );
}

GxLinearProgressGauge _progress(double value) => GxLinearProgressGauge(
  value: GxGaugeValue(value: value),
  duration: const Duration(milliseconds: 200),
  curve: Curves.linear,
);

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

RadialGaugePainter _radialPainter(WidgetTester tester) =>
    tester
            .widget<CustomPaint>(
              find.descendant(
                of: find.byType(GxRadialGauge),
                matching: find.byType(CustomPaint),
              ),
            )
            .painter!
        as RadialGaugePainter;

void main() {
  group('Reduce motion', () {
    testWidgets('jumps to the new value when animations are disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(_progress(0), disableAnimations: true));
      await tester.pumpWidget(_app(_progress(100), disableAnimations: true));
      await tester.pump();
      expect(_progressPainter(tester).value.value, 100);
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('still animates when animations are enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(_progress(0)));
      await tester.pumpWidget(_app(_progress(100)));
      await tester.pump(const Duration(milliseconds: 100));
      expect(_progressPainter(tester).value.value, closeTo(50, 1));
      await tester.pumpAndSettle();
    });

    testWidgets('finishes a running animation when the setting turns on', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(_progress(0)));
      await tester.pumpWidget(_app(_progress(100)));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpWidget(_app(_progress(100), disableAnimations: true));
      await tester.pump();
      expect(_progressPainter(tester).value.value, 100);
    });
  });

  group('Text scaling', () {
    test('paintText grows with the text scaler', () {
      Size measure(TextScaler scaler) => paintText(
        RecordingCanvas(),
        text: '42',
        style: const TextStyle(fontSize: 10),
        textDirection: TextDirection.ltr,
        textScaler: scaler,
        position: (Size text) => Offset.zero,
      );
      final Size plain = measure(TextScaler.noScaling);
      final Size doubled = measure(const TextScaler.linear(2));
      expect(doubled.height, closeTo(plain.height * 2, 0.5));
      expect(doubled.width, greaterThan(plain.width));
    });

    testWidgets('every gauge hands the system scaler to its painter', (
      WidgetTester tester,
    ) async {
      const TextScaler scaler = TextScaler.linear(1.5);
      await tester.pumpWidget(_app(_progress(40), textScaler: scaler));
      expect(_progressPainter(tester).config.textScaler, scaler);

      await tester.pumpWidget(
        _app(
          const GxRadialGauge(value: GxGaugeValue(value: 40)),
          textScaler: scaler,
        ),
      );
      expect(_radialPainter(tester).config.textScaler, scaler);
    });

    testWidgets('a change of scaler repaints the gauge', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(_progress(40)));
      final ProgressLinearPainter before = _progressPainter(tester);
      await tester.pumpWidget(
        _app(_progress(40), textScaler: const TextScaler.linear(2)),
      );
      expect(_progressPainter(tester).shouldRepaint(before), isTrue);
    });
  });

  group('Radial center value', () {
    testWidgets('valueFormatter and valueStyle reach the painter', (
      WidgetTester tester,
    ) async {
      String format(double v) => '${v.round()} km/h';
      const TextStyle style = TextStyle(fontSize: 31, color: Colors.red);
      await tester.pumpWidget(
        _app(
          GxRadialGauge(
            value: const GxGaugeValue(value: 40),
            valueFormatter: format,
            valueStyle: style,
          ),
        ),
      );
      final RadialPainterConfig config = _radialPainter(tester).config;
      expect(config.valueFormatter!(40.4), '40 km/h');
      expect(config.valueStyle.fontSize, 31);
      expect(config.valueStyle.color, Colors.red);
      expect(config.showValueAtCenter, isTrue);
    });

    testWidgets('centerBuilder replaces the painted value', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _app(
          GxRadialGauge(
            value: const GxGaugeValue(value: 40),
            centerBuilder: (BuildContext context, double value) =>
                Text('v=${value.round()}', key: const Key('center')),
          ),
        ),
      );
      expect(find.text('v=40'), findsOneWidget);
      final RadialPainterConfig config = _radialPainter(tester).config;
      expect(config.showValueAtCenter, isFalse);

      final Offset gauge = tester.getCenter(find.byType(GxRadialGauge));
      expect(
        tester.getCenter(find.byKey(const Key('center'))).dx,
        closeTo(gauge.dx, 0.5),
      );
      expect(
        tester.getCenter(find.byKey(const Key('center'))).dy,
        closeTo(gauge.dy, 0.5),
      );
    });

    testWidgets('centerBuilder follows the animated value', (
      WidgetTester tester,
    ) async {
      Widget gauge(double v) => _app(
        GxRadialGauge(
          value: GxGaugeValue(value: v),
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
          centerBuilder: (BuildContext context, double value) =>
              Text('v=${value.round()}'),
        ),
      );
      await tester.pumpWidget(gauge(0));
      await tester.pumpWidget(gauge(100));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('v=50'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('v=100'), findsOneWidget);
    });

    testWidgets('centerBuilder sits below the hub when a needle is drawn', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _app(
          GxRadialGauge(
            value: const GxGaugeValue(value: 40),
            showNeedle: true,
            needle: const GxRadialNeedle(),
            centerBuilder: (BuildContext context, double value) =>
                const SizedBox(key: Key('center'), width: 10, height: 10),
          ),
        ),
      );
      final Offset gauge = tester.getCenter(find.byType(GxRadialGauge));
      expect(
        tester.getCenter(find.byKey(const Key('center'))).dy,
        greaterThan(gauge.dy + 10),
      );
    });

    test('centerAnchor is the middle without a needle', () {
      final RadialPainterConfig config = _plainRadialConfig();
      expect(
        RadialGaugePainter.centerAnchor(config, const Size(200, 200)),
        const Offset(100, 100),
      );
    });
  });
}

RadialPainterConfig _plainRadialConfig() => const RadialPainterConfig(
  scale: GaugeScale(0, 100),
  style: GxRadialGaugeStyle(),
  color: Colors.blue,
  trackColor: Colors.green,
  startAngleInDegree: 0,
  sweepAngleInDegree: 360,
  interval: 10,
  minorTicksPerInterval: 0,
  showMajorTicks: false,
  showMinorTicks: false,
  showLabels: false,
  majorTickStyle: GxRadialTickStyle(),
  minorTickStyle: GxRadialTickStyle(),
  tickColor: Colors.grey,
  labelTickStyle: GxRadialTickLabelStyle(),
  labelStyle: TextStyle(),
  showValueAtCenter: true,
  valueStyle: TextStyle(),
  showNeedle: false,
  needleColor: Colors.black,
  pointerColor: Colors.blue,
  rangeColor: Colors.blue,
  capInnerColor: Colors.white,
  textDirection: TextDirection.ltr,
);
