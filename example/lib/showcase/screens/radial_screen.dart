import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/demo.dart';
import 'package:gx_gauge_example/showcase/widgets/showcase_settings.dart';

/// Every option of [GxRadialGauge].
class RadialScreen extends StatelessWidget {
  const RadialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GaugePage(
      title: 'Radial',
      actions: settingsActions(context),
      tabs: <DemoTab>[
        DemoTab('Arcs', (_) => const _Arcs()),
        DemoTab('Ticks & labels', (_) => const _Ticks()),
        DemoTab('Needles & pointers', (_) => const _Needles()),
        DemoTab('Ranges', (_) => const _Ranges()),
        DemoTab('Interactive', (_) => const _Interactive()),
        DemoTab('Clock', (_) => const _Clock()),
      ],
    );
  }
}

const GxGaugeValue _v = GxGaugeValue(value: 65);

/// Lays radial demos out two per row on wide screens.
class _Grid extends StatelessWidget {
  const _Grid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 16,
      runSpacing: 16,
      children: children,
    );
  }
}

class _Captioned extends StatelessWidget {
  const _Captioned(this.caption, this.child);

  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        child,
        const SizedBox(height: 4),
        Text(caption, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _Arcs extends StatelessWidget {
  const _Arcs();

  @override
  Widget build(BuildContext context) {
    return const DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Angles',
          subtitle:
              'startAngleInDegree / sweepAngleInDegree, clockwise from '
              '3 o\'clock.',
          child: _Grid(
            children: <Widget>[
              _Captioned(
                'Full circle (0°, 360°)',
                GxRadialGauge(value: _v, diameter: 140),
              ),
              _Captioned(
                'Speedometer (135°, 270°)',
                GxRadialGauge(
                  value: _v,
                  diameter: 140,
                  startAngleInDegree: 135,
                  sweepAngleInDegree: 270,
                ),
              ),
              _Captioned(
                'Semicircle (180°, 180°)',
                GxRadialGauge(
                  value: _v,
                  diameter: 140,
                  startAngleInDegree: 180,
                  sweepAngleInDegree: 180,
                ),
              ),
              _Captioned(
                'Counter-clockwise (270°, -360°)',
                GxRadialGauge(
                  value: _v,
                  diameter: 140,
                  startAngleInDegree: 270,
                  sweepAngleInDegree: -360,
                ),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Arc styles',
          child: _Grid(
            children: <Widget>[
              _Captioned(
                'Thick, butt caps',
                GxRadialGauge(
                  value: _v,
                  diameter: 140,
                  style: GxRadialGaugeStyle(
                    thickness: 22,
                    strokeCap: StrokeCap.butt,
                  ),
                ),
              ),
              _Captioned(
                'Custom colors',
                GxRadialGauge(
                  value: _v,
                  diameter: 140,
                  style: GxRadialGaugeStyle(
                    thickness: 6,
                    color: Colors.teal,
                    backgroundColor: Color(0x2200BFA5),
                  ),
                ),
              ),
              _Captioned(
                'Sweep gradient',
                GxRadialGauge(
                  value: _v,
                  diameter: 140,
                  startAngleInDegree: 135,
                  sweepAngleInDegree: 270,
                  style: GxRadialGaugeStyle(
                    thickness: 14,
                    gradient: SweepGradient(
                      colors: <Color>[Colors.green, Colors.amber, Colors.red],
                    ),
                    backgroundColor: Color(0x22000000),
                  ),
                ),
              ),
              _Captioned(
                'Value hidden',
                GxRadialGauge(
                  value: _v,
                  diameter: 140,
                  showValueAtCenter: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

GxRadialTickStyle _redZone(double value, int index) => GxRadialTickStyle(
  length: 14,
  thickness: 2,
  color: value >= 80 ? Colors.red : null,
);

GxRadialTickLabelStyle _boldZero(double value, int index) =>
    GxRadialTickLabelStyle(
      style: TextStyle(
        fontWeight: value == 0 ? FontWeight.bold : null,
        color: value >= 80 ? Colors.red : null,
      ),
    );

String _rpm(double value, int index) => '${(value / 10).toInt()}k';

class _Ticks extends StatelessWidget {
  const _Ticks();

  @override
  Widget build(BuildContext context) {
    return const DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Major, minor ticks and labels',
          child: Center(
            child: GxRadialGauge(
              value: _v,
              diameter: 220,
              startAngleInDegree: 135,
              sweepAngleInDegree: 270,
              interval: 10,
              minorTicksPerInterval: 4,
              showMajorTicks: true,
              showMinorTicks: true,
              showLabels: true,
              majorTickStyle: GxRadialTickStyle(length: 12, thickness: 2),
              minorTickStyle: GxRadialTickStyle(length: 6),
            ),
          ),
        ),
        DemoCard(
          title: 'Tick placement',
          subtitle: 'alignment and position relative to the arc.',
          child: _Grid(
            children: <Widget>[
              _Captioned(
                'center, inside',
                GxRadialGauge(
                  value: _v,
                  diameter: 140,
                  showMajorTicks: true,
                  majorTickStyle: GxRadialTickStyle(length: 14, thickness: 2),
                ),
              ),
              _Captioned(
                'center, outside',
                GxRadialGauge(
                  value: _v,
                  diameter: 140,
                  showMajorTicks: true,
                  style: GxRadialGaugeStyle(thickness: 6),
                  majorTickStyle: GxRadialTickStyle(
                    length: 14,
                    thickness: 2,
                    position: GxRadialElementPosition.outside,
                  ),
                ),
              ),
              _Captioned(
                'end (inner edge)',
                GxRadialGauge(
                  value: _v,
                  diameter: 140,
                  showMajorTicks: true,
                  majorTickStyle: GxRadialTickStyle(
                    length: 24,
                    thickness: 2,
                    alignment: GxRadialElementAlignment.end,
                  ),
                ),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Labels outside the arc',
          child: Center(
            child: GxRadialGauge(
              value: _v,
              diameter: 200,
              startAngleInDegree: 135,
              sweepAngleInDegree: 270,
              interval: 20,
              showLabels: true,
              showMajorTicks: true,
              style: GxRadialGaugeStyle(thickness: 6),
              labelTickStyle: GxRadialTickLabelStyle(
                position: GxRadialElementPosition.outside,
                padding: 4,
              ),
            ),
          ),
        ),
        DemoCard(
          title: 'Formatter and stylers',
          subtitle: 'labelFormatter, labelStyler and majorTickStyler.',
          child: Center(
            child: GxRadialGauge(
              value: _v,
              diameter: 220,
              startAngleInDegree: 135,
              sweepAngleInDegree: 270,
              interval: 10,
              showMajorTicks: true,
              showLabels: true,
              labelFormatter: _rpm,
              labelStyler: _boldZero,
              majorTickStyler: _redZone,
            ),
          ),
        ),
      ],
    );
  }
}

class _Needles extends StatelessWidget {
  const _Needles();

  @override
  Widget build(BuildContext context) {
    return DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Needle shapes and caps',
          child: _Grid(
            children: <Widget>[
              _Captioned(
                'Tapered (default)',
                GxRadialGauge(
                  value: _v,
                  diameter: 150,
                  showNeedle: true,
                  needle: GxRadialNeedle(),
                ),
              ),
              _Captioned(
                'Line, round cap',
                GxRadialGauge(
                  value: _v,
                  diameter: 150,
                  showNeedle: true,
                  needle: GxRadialNeedle(
                    shape: GxRadialNeedleShape.line,
                    thickness: 4,
                    color: Colors.red,
                  ),
                ),
              ),
              _Captioned(
                'Outlined cap',
                GxRadialGauge(
                  value: _v,
                  diameter: 150,
                  showNeedle: true,
                  showValueAtCenter: false,
                  needle: GxRadialNeedle(
                    cap: GxNeedleCap(
                      radius: 12,
                      paintingStyle: PaintingStyle.stroke,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
              _Captioned(
                'Tail (bottomOffset)',
                GxRadialGauge(
                  value: _v,
                  diameter: 150,
                  showNeedle: true,
                  showValueAtCenter: false,
                  needle: GxRadialNeedle(
                    bottomOffset: 20,
                    thickness: 6,
                    shape: GxRadialNeedleShape.line,
                  ),
                ),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Needle alignment',
          subtitle: 'Where the tip ends across the arc.',
          child: _Grid(
            children: <Widget>[
              for (final GxRadialElementAlignment alignment
                  in GxRadialElementAlignment.values)
                _Captioned(
                  alignment.name,
                  GxRadialGauge(
                    value: _v,
                    diameter: 130,
                    showNeedle: true,
                    showValueAtCenter: false,
                    style: GxRadialGaugeStyle(thickness: 16),
                    needle: GxRadialNeedle(
                      alignment: alignment,
                      shape: GxRadialNeedleShape.line,
                      thickness: 3,
                    ),
                  ),
                ),
            ],
          ),
        ),
        DemoCard(
          title: 'Pointers',
          subtitle:
              'Markers at fixed values, optionally with their own needle.',
          child: Center(
            child: GxRadialGauge(
              value: _v,
              diameter: 220,
              startAngleInDegree: 135,
              sweepAngleInDegree: 270,
              showNeedle: true,
              needle: GxRadialNeedle(),
              pointers: <GxRadialPointer>[
                GxRadialPointer(value: 20, showNeedle: false),
                GxRadialPointer(
                  value: 45,
                  shape: GxRadialPointerShape.triangle,
                  alignment: GxRadialElementAlignment.start,
                  showNeedle: false,
                  style: GxRadialPointerStyle(color: Colors.teal, size: 14),
                ),
                GxRadialPointer(
                  value: 90,
                  showPointer: false,
                  needle: GxRadialNeedle(
                    shape: GxRadialNeedleShape.line,
                    thickness: 2,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The "Sport" band covers 80..100 of a 150° + 240° arc, i.e. 342°..390°.
/// Rotating the sweep to start at 342° keeps the gradient from wrapping.
Shader _hot(Rect bounds) => const SweepGradient(
  endAngle: 48 * math.pi / 180,
  colors: <Color>[Colors.amber, Colors.red],
  transform: GradientRotation(342 * math.pi / 180),
).createShader(bounds);

class _Ranges extends StatelessWidget {
  const _Ranges();

  @override
  Widget build(BuildContext context) {
    return const DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Bands inside the arc, with labels',
          child: Center(
            child: GxRadialGauge(
              value: _v,
              diameter: 240,
              startAngleInDegree: 150,
              sweepAngleInDegree: 240,
              style: GxRadialGaugeStyle(thickness: 6),
              showNeedle: true,
              needle: GxRadialNeedle(thickness: 6),
              ranges: <GxRadialRange>[
                GxRadialRange(
                  start: 0,
                  end: 50,
                  offset: -16,
                  color: Colors.green,
                  label: GxGaugeLabel(label: 'Eco'),
                ),
                GxRadialRange(
                  start: 50,
                  end: 80,
                  offset: -16,
                  color: Colors.orange,
                  label: GxGaugeLabel(label: 'Normal'),
                ),
                GxRadialRange(
                  start: 80,
                  end: 100,
                  offset: -16,
                  shaderCallback: _hot,
                  label: GxGaugeLabel(label: 'Sport'),
                ),
              ],
            ),
          ),
        ),
        DemoCard(
          title: 'Bands on the arc',
          subtitle: 'offset 0, height matching the arc.',
          child: Center(
            child: GxRadialGauge(
              value: _v,
              diameter: 220,
              startAngleInDegree: 135,
              sweepAngleInDegree: 270,
              showNeedle: true,
              needle: GxRadialNeedle(),
              style: GxRadialGaugeStyle(
                thickness: 14,
                color: Color(0x00000000),
                backgroundColor: Color(0x00000000),
              ),
              ranges: <GxRadialRange>[
                GxRadialRange(
                  start: 0,
                  end: 60,
                  height: 14,
                  color: Colors.green,
                ),
                GxRadialRange(
                  start: 60,
                  end: 85,
                  height: 14,
                  color: Colors.amber,
                ),
                GxRadialRange(
                  start: 85,
                  end: 100,
                  height: 14,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Interactive extends StatefulWidget {
  const _Interactive();

  @override
  State<_Interactive> createState() => _InteractiveState();
}

class _InteractiveState extends State<_Interactive> {
  double _knob = 40;
  double _speed = 60;

  @override
  Widget build(BuildContext context) {
    return DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Knob',
          subtitle:
              'Tap or drag around the gauge. Screen readers can adjust it too.',
          child: Center(
            child: GxRadialGauge(
              value: GxGaugeValue(value: _knob),
              diameter: 200,
              startAngleInDegree: 135,
              sweepAngleInDegree: 270,
              style: const GxRadialGaugeStyle(thickness: 16),
              showNeedle: true,
              needle: const GxRadialNeedle(),
              semanticLabel: 'Volume',
              onChanged: (double v) => setState(() => _knob = v),
            ),
          ),
        ),
        DemoCard(
          title: 'Animated value',
          subtitle: 'duration + curve; drag the slider.',
          child: Column(
            children: <Widget>[
              GxRadialGauge(
                value: GxGaugeValue(value: _speed, max: 240),
                diameter: 200,
                startAngleInDegree: 135,
                sweepAngleInDegree: 270,
                interval: 40,
                showMajorTicks: true,
                showLabels: true,
                showNeedle: true,
                needle: const GxRadialNeedle(),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutBack,
              ),
              LabeledSlider(
                label: 'Speed',
                value: _speed,
                max: 240,
                onChanged: (double v) => setState(() => _speed = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Clock extends StatefulWidget {
  const _Clock();

  @override
  State<_Clock> createState() => _ClockState();
}

class _ClockState extends State<_Clock> {
  DateTime _now = DateTime.now();
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _now = DateTime.now()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double seconds = _now.second.toDouble();
    final double minutes = _now.minute + seconds / 60;
    final double hours = _now.hour % 12 + minutes / 60;
    final Color hands = Theme.of(context).colorScheme.onSurface;
    return DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Clock',
          subtitle:
              'A 0..12 gauge starting at 12 o\'clock, with pointers '
              'as hands.',
          child: Center(
            child: GxRadialGauge(
              value: const GxGaugeValue(value: 0, max: 12),
              diameter: 240,
              startAngleInDegree: 270,
              interval: 1,
              minorTicksPerInterval: 4,
              showMajorTicks: true,
              showMinorTicks: true,
              showLabels: true,
              showValueAtCenter: false,
              labelFormatter: _hour,
              style: GxRadialGaugeStyle(
                thickness: 4,
                backgroundColor: hands.withValues(alpha: 0.3),
              ),
              majorTickStyle: const GxRadialTickStyle(length: 12, thickness: 3),
              minorTickStyle: const GxRadialTickStyle(length: 6),
              pointers: <GxRadialPointer>[
                GxRadialPointer(
                  value: hours,
                  showPointer: false,
                  needle: GxRadialNeedle(
                    color: hands,
                    thickness: 8,
                    topOffset: -60,
                    alignment: GxRadialElementAlignment.end,
                  ),
                ),
                GxRadialPointer(
                  value: minutes / 5,
                  showPointer: false,
                  needle: GxRadialNeedle(
                    color: hands,
                    thickness: 6,
                    topOffset: -20,
                    alignment: GxRadialElementAlignment.end,
                  ),
                ),
                GxRadialPointer(
                  value: seconds / 5,
                  showPointer: false,
                  needle: const GxRadialNeedle(
                    color: Colors.red,
                    thickness: 2,
                    shape: GxRadialNeedleShape.line,
                    bottomOffset: 16,
                    alignment: GxRadialElementAlignment.end,
                    topOffset: -8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String _hour(double value, int index) =>
    value == 0 ? '12' : value.toInt().toString();
