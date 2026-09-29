// Renders the README quick-start snippets to ../doc/screenshots/.
//
// Run from example/:
//   fvm flutter test tool/screenshots_test.dart
//
// Not part of the regular test suite (it lives outside test/). Real fonts are
// loaded from the Flutter SDK so text doesn't render as boxes.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge_example/readme_snippets.dart';

const String _outDir = '../doc/screenshots';

Future<void> _loadFonts() async {
  final String root =
      Platform.environment['FLUTTER_ROOT'] ?? '../.fvm/flutter_sdk';
  final String fonts = '$root/bin/cache/artifacts/material_fonts';
  Future<ByteData> read(String file) async =>
      ByteData.sublistView(await File('$fonts/$file').readAsBytes());

  await (FontLoader('Roboto')
        ..addFont(read('Roboto-Regular.ttf'))
        ..addFont(read('Roboto-Medium.ttf')))
      .load();
  await (FontLoader(
    'MaterialIcons',
  )..addFont(read('MaterialIcons-Regular.otf'))).load();
}

Widget _frame(Widget child, {required String title}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.indigo, fontFamily: 'Roboto'),
    home: Scaffold(
      body: Center(
        child: RepaintBoundary(
          key: const Key('shot'),
          child: ColoredBox(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _shoot(
  WidgetTester tester,
  String name,
  Widget child, {
  required String title,
  double width = 420,
}) async {
  await tester.pumpWidget(
    _frame(
      SizedBox(width: width - 48, child: child),
      title: title,
    ),
  );
  await tester.pumpAndSettle();
  final RenderRepaintBoundary boundary = tester.renderObject(
    find.byKey(const Key('shot')),
  );
  await tester.runAsync(() async {
    final ui.Image image = await boundary.toImage(pixelRatio: 2);
    final ByteData? png = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    await File('$_outDir/$name.png').writeAsBytes(png!.buffer.asUint8List());
  });
}

void main() {
  testWidgets('render README screenshots', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.runAsync(_loadFonts);
    Directory(_outDir).createSync(recursive: true);

    await _shoot(
      tester,
      'linear_progress',
      linearProgress(),
      title: 'GxLinearProgressGauge',
    );
    await _shoot(
      tester,
      'linear_stepper',
      linearStepper(),
      title: 'GxLinearStepperGauge',
    );
    await _shoot(
      tester,
      'linear_scale',
      linearScale(),
      title: 'GxLinearScaleGauge',
    );
    await _shoot(tester, 'linear_bar', linearBar(), title: 'GxLinearBarGauge');
    await _shoot(
      tester,
      'radial',
      Center(child: radial()),
      title: 'GxRadialGauge',
    );
    await _shoot(
      tester,
      'radial_ranges',
      Center(child: radialRanges()),
      title: 'Radial ranges with labels',
    );
    await _shoot(tester, 'vertical', vertical(), title: 'Vertical gauges');

    // Hero: every gauge together.
    await _shoot(
      tester,
      'hero',
      width: 900,
      title: 'gx_gauge',
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                linearProgress(),
                const SizedBox(height: 36),
                linearStepper(),
                const SizedBox(height: 28),
                linearScale(),
                const SizedBox(height: 12),
                linearBar(),
              ],
            ),
          ),
          const SizedBox(width: 32),
          radial(),
        ],
      ),
    );
  });
}
