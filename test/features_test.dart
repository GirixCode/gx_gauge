import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge/src/core/gauge_scale.dart';
import 'package:gx_gauge/src/linear/painters/linear_bar_painter.dart';
import 'package:gx_gauge/src/linear/painters/scale_linear_gauge_painter.dart';
import 'package:gx_gauge/src/radial/painters/radial_gauge_painter.dart';

import 'helpers/configs.dart';
import 'helpers/recording_canvas.dart';

Shader _shader(Rect bounds) =>
    const LinearGradient(colors: <Color>[Colors.red, Colors.blue])
        .createShader(bounds);

RecordingCanvas _paintScale(ScalePainterConfig config, {double value = 50}) {
  final RecordingCanvas canvas = RecordingCanvas();
  ScaleLinearGaugePainter(
    config: config,
    value: AlwaysStoppedAnimation<double>(value),
  ).paint(canvas, const Size(200, 100));
  return canvas;
}

RecordingCanvas _paintBar(BarPainterConfig config) {
  final RecordingCanvas canvas = RecordingCanvas();
  LinearBarPainter(
    config: config,
    value: const AlwaysStoppedAnimation<double>(50),
  ).paint(canvas, const Size(200, 40));
  return canvas;
}

Widget _app(Widget child) => MaterialApp(
  home: Scaffold(
    body: Center(child: SizedBox(width: 200, height: 300, child: child)),
  ),
);

void main() {
  group('Linear ranges', () {
    test('draw a band per range, with border and label', () {
      final RecordingCanvas canvas = _paintScale(
        scaleConfig(
          showMajorTicks: false,
          ranges: const <GxLinearRange>[
            GxLinearRange(
              start: 0,
              end: 50,
              thickness: 8,
              borderColor: Colors.black,
              label: GxGaugeLabel(label: 'Low'),
            ),
          ],
        ),
      );
      final List<Invocation> rrects = canvas.callsTo('drawRRect').toList();
      expect(rrects, hasLength(2)); // fill + border
      expect(
        (rrects.first.positionalArguments[0] as RRect).outerRect,
        const Rect.fromLTRB(0, 46, 100, 54),
      );
      expect(canvas.callsTo('drawParagraph'), hasLength(1));
    });

    test('apply a shader', () {
      final Paint paint =
          _paintScale(
                scaleConfig(
                  ranges: const <GxLinearRange>[
                    GxLinearRange(start: 0, end: 50, shaderCallback: _shader),
                  ],
                ),
              ).callsTo('drawRRect').first.positionalArguments[1]
              as Paint;
      expect(paint.shader, isNotNull);
    });
  });

  group('Bar pointer placement', () {
    List<Rect> rects(List<GxLinearBarPointer> bars) =>
        _paintBar(barConfig(bars: bars))
            .callsTo('drawRRect')
            .map(
              (Invocation i) => (i.positionalArguments[0] as RRect).outerRect,
            )
            .toList();

    test('thickness sets the cross-axis size, centered by default', () {
      expect(
        rects(const <GxLinearBarPointer>[
          GxLinearBarPointer(start: 0, end: 100, thickness: 10),
        ]).single,
        const Rect.fromLTRB(0, 15, 200, 25),
      );
    });

    test('inside and outside place bars below and above the center line', () {
      expect(
        rects(const <GxLinearBarPointer>[
          GxLinearBarPointer(
            start: 0,
            end: 50,
            position: GxElementPosition.inside,
            offset: 2,
          ),
          GxLinearBarPointer(
            start: 50,
            end: 100,
            position: GxElementPosition.outside,
          ),
        ]),
        const <Rect>[
          Rect.fromLTRB(0, 22, 100, 42),
          Rect.fromLTRB(100, 0, 200, 20),
        ],
      );
    });

    test('borders and shaders are painted', () {
      final List<Invocation> calls = _paintBar(
        barConfig(
          bars: const <GxLinearBarPointer>[
            GxLinearBarPointer(
              start: 0,
              end: 100,
              shaderCallback: _shader,
              borderColor: Colors.black,
              borderWidth: 2,
            ),
          ],
        ),
      ).callsTo('drawRRect').toList();
      expect(calls, hasLength(2));
      expect((calls[0].positionalArguments[1] as Paint).shader, isNotNull);
      expect(
        (calls[1].positionalArguments[1] as Paint).style,
        PaintingStyle.stroke,
      );
    });
  });

  group('Needles', () {
    test('the scale gauge uses needlePainter for the needle and markers', () {
      final List<double> anchors = <double>[];
      _paintScale(
        scaleConfig(
          linearNeedle: const GxLinearNeedle(shape: GxNeedleShape.custom),
          markers: const <GxLinearMarkerPointer>[
            GxLinearMarkerPointer(
              value: 75,
              needle: GxLinearNeedle(shape: GxNeedleShape.custom),
            ),
          ],
          needlePainter: (Canvas c, Offset anchor, GxLinearNeedle n) =>
              anchors.add(anchor.dx),
        ),
      );
      expect(anchors, unorderedEquals(<double>[100, 150]));
    });

    test('needle labels are drawn', () {
      final RecordingCanvas canvas = _paintScale(
        scaleConfig(
          linearNeedle: const GxLinearNeedle(
            label: GxNeedleLabel(label: '{value}'),
          ),
        ),
      );
      expect(canvas.callsTo('drawParagraph'), hasLength(1));
    });
  });

  group('Vertical orientation', () {
    test('rotates the canvas a quarter turn', () {
      final RecordingCanvas canvas = _paintScale(scaleConfig(vertical: true));
      expect(canvas.callsTo('rotate'), isNotEmpty);
      expect(canvas.callsTo('save').length, canvas.callsTo('restore').length);
    });

    testWidgets('vertical gauges fill the height', (WidgetTester tester) async {
      await tester.pumpWidget(
        _app(
          const Align(
            alignment: Alignment.topLeft,
            child: GxLinearProgressGauge(
              value: GxGaugeValue(value: 40),
              direction: Axis.vertical,
              height: 12,
            ),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(GxLinearProgressGauge)),
        const Size(12, 300),
      );
    });

    testWidgets('every linear gauge renders vertically', (
      WidgetTester tester,
    ) async {
      for (final Widget gauge in <Widget>[
        const GxLinearScaleGauge(
          value: GxGaugeValue(value: 40),
          direction: Axis.vertical,
          needle: GxLinearNeedle(label: GxNeedleLabel(label: '{value}')),
          ranges: <GxLinearRange>[
            GxLinearRange(start: 0, end: 40, label: GxGaugeLabel(label: 'Lo')),
          ],
        ),
        const GxLinearBarGauge(
          value: GxGaugeValue(value: 40),
          direction: Axis.vertical,
          bars: <GxLinearBarPointer>[GxLinearBarPointer(start: 0, end: 100)],
          tooltip: GxGaugeTooltip(),
        ),
        const GxLinearStepperGauge(
          currentStep: 1,
          direction: Axis.vertical,
          steps: <GxStepperStep>[
            GxStepperStep(label: GxGaugeLabel(label: 'A')),
            GxStepperStep(label: GxGaugeLabel(label: 'B')),
          ],
        ),
      ]) {
        await tester.pumpWidget(_app(Align(child: gauge)));
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('Radial ranges', () {
    test('draw their label and shader', () {
      final RecordingCanvas canvas = RecordingCanvas();
      RadialGaugePainter(
        config: radialConfig(
          ranges: const <GxRadialRange>[
            GxRadialRange(
              start: 0,
              end: 50,
              shaderCallback: _shader,
              label: GxGaugeLabel(label: 'Half'),
            ),
          ],
        ),
        value: const AlwaysStoppedAnimation<double>(10),
      ).paint(canvas, const Size(200, 200));
      final Paint band =
          canvas.callsTo('drawArc').elementAt(2).positionalArguments[4]
              as Paint;
      expect(band.shader, isNotNull);
      expect(canvas.callsTo('drawParagraph'), hasLength(1));
    });
  });

  group('RadialGaugePainter.valueAt', () {
    final RadialPainterConfig config = radialConfig(
      startAngleInDegree: 135,
      sweepAngleInDegree: 270,
    );
    const Size size = Size(200, 200);

    test('maps angles within the sweep to values', () {
      // 135° + 135° = 270° → straight up is the middle of the scale.
      expect(
        RadialGaugePainter.valueAt(config, size, const Offset(100, 0)),
        closeTo(50, 1e-9),
      );
    });

    test('snaps points in the gap to the nearer end', () {
      // Just right of straight down (≈ 80°) is nearer the end (45°).
      expect(
        RadialGaugePainter.valueAt(config, size, const Offset(110, 200)),
        100,
      );
      expect(
        RadialGaugePainter.valueAt(config, size, const Offset(90, 200)),
        0,
      );
    });

    test('respects a non-zero min', () {
      expect(
        RadialGaugePainter.valueAt(
          radialConfig(scale: const GaugeScale(-50, 50)),
          size,
          const Offset(0, 100), // 180° on a full circle from 0°
        ),
        closeTo(0, 1e-9),
      );
    });
  });

  group('Interaction', () {
    testWidgets('tapping a linear gauge reports the value under the pointer', (
      WidgetTester tester,
    ) async {
      final List<double> values = <double>[];
      double? end;
      await tester.pumpWidget(
        _app(
          Align(
            child: GxLinearProgressGauge(
              value: const GxGaugeValue(value: 10),
              height: 20,
              onChanged: values.add,
              onChangeEnd: (double v) => end = v,
            ),
          ),
        ),
      );
      final Rect box = tester.getRect(find.byType(GxLinearProgressGauge));
      await tester.tapAt(box.centerLeft + Offset(box.width * 0.25, 0));
      expect(values.single, closeTo(25, 0.5));
      expect(end, values.single);
    });

    testWidgets('dragging reports a stream of values', (
      WidgetTester tester,
    ) async {
      final List<double> values = <double>[];
      await tester.pumpWidget(
        _app(
          Align(
            child: GxLinearScaleGauge(
              value: const GxGaugeValue(value: 10),
              height: 60,
              onChanged: values.add,
            ),
          ),
        ),
      );
      final Rect box = tester.getRect(find.byType(GxLinearScaleGauge));
      await tester.dragFrom(
        box.centerLeft + const Offset(20, 0),
        const Offset(100, 0),
      );
      expect(values.length, greaterThan(1));
      expect(values.last, greaterThan(values.first));
    });

    testWidgets('read-only gauges have no gesture detector', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _app(const GxLinearProgressGauge(value: GxGaugeValue(value: 10))),
      );
      expect(
        find.descendant(
          of: find.byType(GxLinearProgressGauge),
          matching: find.byType(GestureDetector),
        ),
        findsNothing,
      );
    });

    testWidgets('tapping a stepper reports the nearest step', (
      WidgetTester tester,
    ) async {
      int? tapped;
      await tester.pumpWidget(
        _app(
          Align(
            child: GxLinearStepperGauge(
              currentStep: 0,
              steps: const <GxStepperStep>[
                GxStepperStep(label: GxGaugeLabel(label: 'A')),
                GxStepperStep(label: GxGaugeLabel(label: 'B')),
                GxStepperStep(label: GxGaugeLabel(label: 'C')),
              ],
              onStepTapped: (int i) => tapped = i,
            ),
          ),
        ),
      );
      final Rect box = tester.getRect(find.byType(GxLinearStepperGauge));
      await tester.tapAt(box.centerRight - const Offset(12, 0));
      expect(tapped, 2);
    });

    testWidgets('screen readers can adjust an interactive gauge', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      double? changed;
      await tester.pumpWidget(
        _app(
          GxRadialGauge(
            value: const GxGaugeValue(value: 50),
            onChanged: (double v) => changed = v,
          ),
        ),
      );
      final SemanticsNode node = tester.getSemantics(
        find.byType(GxRadialGauge),
      );
      expect(
        node.getSemanticsData().hasAction(SemanticsAction.increase),
        isTrue,
      );
      tester.semantics.performAction(
        find.semantics.byValue('50'),
        SemanticsAction.increase,
      );
      expect(changed, 55);
      handle.dispose();
    });
  });

  testWidgets('marker widgets are drawn on the axis', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const Align(
          child: GxLinearScaleGauge(
            value: GxGaugeValue(value: 10),
            height: 80,
            markers: <GxLinearMarkerPointer>[
              GxLinearMarkerPointer(
                value: 50,
                marker: SizedBox(key: Key('marker'), width: 10, height: 10),
              ),
            ],
          ),
        ),
      ),
    );
    final Rect gauge = tester.getRect(find.byType(GxLinearScaleGauge));
    expect(tester.getCenter(find.byKey(const Key('marker'))), gauge.center);
  });
}
