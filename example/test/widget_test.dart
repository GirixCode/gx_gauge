import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/main.dart';
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

  for (final (String device, Size size, double ratio)
      in <(String, Size, double)>[
        ('tablet', const Size(1200, 2600), 2),
        ('phone', const Size(1170, 2532), 3),
      ]) {
    group('Showcase on $device', () {
      setUp(() {
        final TestWidgetsFlutterBinding binding =
            TestWidgetsFlutterBinding.ensureInitialized();
        binding.platformDispatcher.views.first
          ..physicalSize = size
          ..devicePixelRatio = ratio;
      });
      tearDown(() {
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
            .reset();
      });

      const List<String> screens = <String>[
        'Linear progress',
        'Linear stepper',
        'Linear scale',
        'Linear bar',
        'Radial',
        'Playground',
      ];

      for (final String screen in screens) {
        testWidgets('$screen: every tab renders without errors', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(const ShowcaseApp());
          await tester.pumpAndSettle();

          await tester.scrollUntilVisible(find.text(screen), 200);
          await tester.tap(find.text(screen));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);

          final Finder tabs = find.byType(Tab);
          final int count = tabs.evaluate().length;
          for (int i = 0; i < count; i++) {
            await tester.tap(tabs.at(i));
            // The clock ticks every second, so settle with a bounded pump.
            await tester.pump(const Duration(milliseconds: 600));
            await tester.pump(const Duration(milliseconds: 600));
            expect(tester.takeException(), isNull, reason: '$screen tab $i');
          }

          // Unmount so timers (the clock) are cancelled.
          await tester.pumpWidget(const SizedBox.shrink());
        });
      }

      testWidgets('dark theme and right-to-left toggles apply app-wide', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(const ShowcaseApp());
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip('Dark theme'));
        await tester.tap(find.byTooltip('Right-to-left'));
        await tester.pumpAndSettle();

        final BuildContext context = tester.element(
          find.byType(GxLinearProgressGauge).first,
        );
        expect(Theme.of(context).brightness, Brightness.dark);
        expect(Directionality.of(context), TextDirection.rtl);
        expect(tester.takeException(), isNull);
      });
    });
  }
}
