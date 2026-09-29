import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/item_card.dart';

/// Demonstrates vertical gauges, ranges, labels, markers, custom needles,
/// gradients and interaction.
class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

/// A top-level needle painter: stable across rebuilds, so it doesn't force
/// repaints.
void _pinNeedle(Canvas canvas, Offset anchor, GxLinearNeedle needle) {
  final Paint paint = Paint()..color = needle.color ?? Colors.black;
  canvas
    ..drawCircle(anchor.translate(0, -needle.size.height), 6, paint)
    ..drawLine(
      anchor.translate(0, -needle.size.height),
      anchor,
      paint..strokeWidth = 2,
    );
}

Shader _heat(Rect bounds) => const LinearGradient(
  colors: <Color>[Colors.green, Colors.amber, Colors.red],
).createShader(bounds);

class _FeaturesScreenState extends State<FeaturesScreen> {
  double _level = 40;
  double _knob = 65;
  int _step = 1;

  @override
  Widget build(BuildContext context) {
    final GxGaugeValue level = GxGaugeValue(value: _level);
    return Scaffold(
      appBar: AppBar(title: const Text('Features')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          ItemCard(
            title: 'Interactive: tap or drag the gauges',
            child: Column(
              children: <Widget>[
                GxLinearProgressGauge(
                  value: level,
                  height: 16,
                  style: const GxLinearProgressStyle(dense: false),
                  semanticLabel: 'Level',
                  onChanged: (double v) => setState(() => _level = v),
                ),
                const SizedBox(height: 16),
                GxRadialGauge(
                  value: GxGaugeValue(value: _knob),
                  diameter: 160,
                  startAngleInDegree: 135,
                  sweepAngleInDegree: 270,
                  showMajorTicks: true,
                  showNeedle: true,
                  needle: const GxRadialNeedle(),
                  semanticLabel: 'Volume',
                  onChanged: (double v) => setState(() => _knob = v),
                ),
                const SizedBox(height: 16),
                GxLinearStepperGauge(
                  currentStep: _step,
                  duration: const Duration(milliseconds: 300),
                  steps: const <GxStepperStep>[
                    GxStepperStep(label: GxGaugeLabel(label: 'Cart')),
                    GxStepperStep(label: GxGaugeLabel(label: 'Address')),
                    GxStepperStep(label: GxGaugeLabel(label: 'Payment')),
                    GxStepperStep(
                      marker: '✓',
                      label: GxGaugeLabel(label: 'Done'),
                    ),
                  ],
                  onStepTapped: (int step) => setState(() => _step = step),
                ),
              ],
            ),
          ),
          ItemCard(
            title: 'Vertical gauges',
            height: 280,
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GxLinearProgressGauge(
                    value: level,
                    direction: Axis.vertical,
                    height: 12,
                  ),
                  GxLinearScaleGauge(
                    value: level,
                    direction: Axis.vertical,
                    height: 80,
                    interval: 20,
                    needle: const GxLinearNeedle(
                      shape: GxNeedleShape.triangle,
                      position: GxNeedlePosition.top,
                      size: Size(12, 12),
                    ),
                  ),
                  GxLinearBarGauge(
                    value: level,
                    direction: Axis.vertical,
                    height: 24,
                    gapBetweenBars: 3,
                    bars: const <GxLinearBarPointer>[
                      GxLinearBarPointer(
                        start: 0,
                        end: 60,
                        color: Colors.green,
                      ),
                      GxLinearBarPointer(
                        start: 60,
                        end: 85,
                        color: Colors.amber,
                      ),
                      GxLinearBarPointer(
                        start: 85,
                        end: 100,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ItemCard(
            title: 'Ranges with labels, gradient bars and a needle label',
            child: GxLinearScaleGauge(
              value: level,
              interval: 20,
              needle: const GxLinearNeedle(
                shape: GxNeedleShape.triangle,
                position: GxNeedlePosition.top,
                size: Size(12, 12),
                label: GxNeedleLabel(label: '{value}%'),
              ),
              ranges: const <GxLinearRange>[
                GxLinearRange(
                  start: 0,
                  end: 60,
                  color: Color(0x5500AA00),
                  thickness: 10,
                  label: GxGaugeLabel(label: 'Normal'),
                ),
                GxLinearRange(
                  start: 60,
                  end: 100,
                  color: Color(0x55FF0000),
                  thickness: 10,
                  borderColor: Colors.red,
                  label: GxGaugeLabel(label: 'High'),
                ),
              ],
              bars: const <GxLinearBarPointer>[
                GxLinearBarPointer(
                  start: 0,
                  end: 100,
                  thickness: 6,
                  position: GxElementPosition.inside,
                  offset: 14,
                  radius: Radius.circular(3),
                  shaderCallback: _heat,
                ),
              ],
            ),
          ),
          const ItemCard(
            title: 'Marker widgets and a custom needle painter',
            child: GxLinearScaleGauge(
              value: GxGaugeValue(value: 72),
              interval: 20,
              needle: GxLinearNeedle(
                shape: GxNeedleShape.custom,
                size: Size(12, 22),
                color: Colors.indigo,
              ),
              needlePainter: _pinNeedle,
              markers: <GxLinearMarkerPointer>[
                GxLinearMarkerPointer(
                  value: 30,
                  marker: Icon(Icons.flag, color: Colors.teal, size: 18),
                ),
                GxLinearMarkerPointer(
                  value: 90,
                  marker: Icon(
                    Icons.warning_amber,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          ItemCard(
            title: 'Radial ranges with labels and a gradient',
            child: Center(
              child: GxRadialGauge(
                value: GxGaugeValue(value: _knob),
                diameter: 200,
                startAngleInDegree: 150,
                sweepAngleInDegree: 240,
                style: const GxRadialGaugeStyle(thickness: 6),
                showNeedle: true,
                needle: const GxRadialNeedle(thickness: 6),
                ranges: <GxRadialRange>[
                  const GxRadialRange(
                    start: 0,
                    end: 60,
                    color: Colors.green,
                    offset: -16,
                    label: GxGaugeLabel(label: 'Eco'),
                  ),
                  GxRadialRange(
                    start: 60,
                    end: 100,
                    offset: -16,
                    shaderCallback: (Rect bounds) => const SweepGradient(
                      colors: <Color>[Colors.amber, Colors.red],
                    ).createShader(bounds),
                    label: const GxGaugeLabel(label: 'Sport'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
