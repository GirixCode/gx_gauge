import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';

/// A minimal gx_gauge demo: one value drives a linear and a radial gauge.
///
/// For every gauge type and option, run the showcase instead:
/// `flutter run -t lib/showcase/main.dart`.
void main() => runApp(const GaugeDemoApp());

class GaugeDemoApp extends StatelessWidget {
  const GaugeDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'gx_gauge demo',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const GaugeDemoPage(),
    );
  }
}

class GaugeDemoPage extends StatefulWidget {
  const GaugeDemoPage({super.key});

  @override
  State<GaugeDemoPage> createState() => _GaugeDemoPageState();
}

class _GaugeDemoPageState extends State<GaugeDemoPage> {
  double _value = 65;

  @override
  Widget build(BuildContext context) {
    final GxGaugeValue value = GxGaugeValue(value: _value);

    return Scaffold(
      appBar: AppBar(title: const Text('gx_gauge')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          GxLinearProgressGauge(
            value: value,
            style: const GxLinearProgressStyle(
              color: Colors.indigo,
              thickness: 12,
            ),
          ),
          const SizedBox(height: 48),
          GxLinearScaleGauge(
            value: value,
            interval: 10,
            needle: const GxLinearNeedle(
              shape: GxNeedleShape.triangle,
              position: GxNeedlePosition.top,
              color: Colors.indigo,
            ),
            size: const Size.fromHeight(60),
          ),
          const SizedBox(height: 48),
          Center(
            child: GxRadialGauge(
              value: value,
              startAngleInDegree: 135,
              sweepAngleInDegree: 270,
              style: const GxRadialGaugeStyle(color: Colors.indigo),
              showMajorTicks: true,
              showLabels: true,
            ),
          ),
          const SizedBox(height: 24),
          Slider(
            value: _value,
            max: 100,
            label: _value.round().toString(),
            onChanged: (double v) => setState(() => _value = v),
          ),
        ],
      ),
    );
  }
}
