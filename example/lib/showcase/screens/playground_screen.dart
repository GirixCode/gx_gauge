import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/demo.dart';
import 'package:gx_gauge_example/showcase/widgets/showcase_settings.dart';

/// Every gauge driven by the same controls: value, range, animation,
/// direction and reverse.
class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  double _value = 60;
  double _max = 100;
  bool _animate = true;
  bool _vertical = false;
  bool _reverse = false;

  @override
  Widget build(BuildContext context) {
    final GxGaugeValue value = GxGaugeValue(
      value: _value.clamp(0, _max),
      max: _max,
    );
    final Duration duration = _animate
        ? const Duration(milliseconds: 500)
        : Duration.zero;
    final Axis direction = _vertical ? Axis.vertical : Axis.horizontal;
    void set(double v) => setState(() => _value = v);

    const GxLinearNeedle pointer = GxLinearNeedle(
      shape: GxNeedleShape.triangle,
      position: GxNeedlePosition.top,
      size: Size(12, 12),
    );
    final List<GxLinearBarPointer> bars = <GxLinearBarPointer>[
      GxLinearBarPointer(start: 0, end: _max * 0.5, color: Colors.green),
      GxLinearBarPointer(
        start: _max * 0.5,
        end: _max * 0.8,
        color: Colors.orange,
      ),
      GxLinearBarPointer(start: _max * 0.8, end: _max, color: Colors.red),
    ];

    final List<Widget> linear = <Widget>[
      GxLinearProgressGauge(
        value: value,
        direction: direction,
        reverse: _reverse,
        duration: duration,
        onChanged: set,
      ),
      GxLinearScaleGauge(
        value: value,
        direction: direction,
        reverse: _reverse,
        duration: duration,
        height: 70,
        needle: pointer,
        onChanged: set,
      ),
      GxLinearBarGauge(
        value: value,
        direction: direction,
        reverse: _reverse,
        duration: duration,
        bars: bars,
        gapBetweenBars: 3,
        needle: pointer,
        onChanged: set,
      ),
      GxLinearStepperGauge(
        currentStep: (value.fraction * 3).floor(),
        direction: direction,
        reverse: _reverse,
        duration: duration,
        steps: const <GxStepperStep>[
          GxStepperStep(label: GxGaugeLabel(label: 'One')),
          GxStepperStep(label: GxGaugeLabel(label: 'Two')),
          GxStepperStep(label: GxGaugeLabel(label: 'Three')),
          GxStepperStep(label: GxGaugeLabel(label: 'Four')),
        ],
        onStepTapped: (int step) => set(step / 3 * _max),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Playground'),
        actions: settingsActions(context),
      ),
      body: DemoList(
        children: <Widget>[
          DemoCard(
            title: 'Controls',
            subtitle: 'Every gauge below is also interactive: tap or drag it.',
            child: Column(
              children: <Widget>[
                LabeledSlider(
                  label: 'Value',
                  value: value.value,
                  max: _max,
                  onChanged: set,
                ),
                LabeledSlider(
                  label: 'Max',
                  value: _max,
                  min: 10,
                  max: 500,
                  onChanged: (double v) => setState(() => _max = v),
                ),
                SwitchListTile(
                  title: const Text('Animate changes'),
                  value: _animate,
                  onChanged: (bool v) => setState(() => _animate = v),
                ),
                SwitchListTile(
                  title: const Text('Vertical'),
                  value: _vertical,
                  onChanged: (bool v) => setState(() => _vertical = v),
                ),
                SwitchListTile(
                  title: const Text('Reverse'),
                  value: _reverse,
                  onChanged: (bool v) => setState(() => _reverse = v),
                ),
              ],
            ),
          ),
          DemoCard(
            title: 'Linear gauges',
            child: _vertical
                ? SizedBox(
                    height: 260,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: linear,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      for (final Widget gauge in linear) ...<Widget>[
                        gauge,
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
          ),
          DemoCard(
            title: 'Radial gauge',
            child: Center(
              child: GxRadialGauge(
                value: value,
                diameter: 220,
                startAngleInDegree: 135,
                sweepAngleInDegree: 270,
                interval: _max / 10,
                showMajorTicks: true,
                showLabels: true,
                showNeedle: true,
                needle: const GxRadialNeedle(),
                duration: duration,
                onChanged: set,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
