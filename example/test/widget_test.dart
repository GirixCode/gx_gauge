import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/main.dart';
import 'package:gx_gauge_example/showcase/screens/features/features_screen.dart';
import 'package:gx_gauge_example/showcase/showcase_app.dart';

void main() {
  testWidgets('Demo app renders and responds to the slider', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GaugeDemoApp());
    expect(tester.takeException(), isNull);

    await tester.drag(find.byType(Slider), const Offset(-100, 0));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Showcase app builds its home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ShowcaseApp());
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(MaterialApp), findsOneWidget);

    // Unmount so periodic timers started by demo screens are cancelled.
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Features screen renders and responds to taps', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: FeaturesScreen()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.byType(GxLinearStepperGauge));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
