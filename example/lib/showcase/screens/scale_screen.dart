import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/demo.dart';
import 'package:gx_gauge_example/showcase/widgets/showcase_settings.dart';

/// Every option of [GxLinearScaleGauge].
class ScaleScreen extends StatelessWidget {
  const ScaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GaugePage(
      title: 'Linear scale',
      actions: settingsActions(context),
      tabs: <DemoTab>[
        DemoTab('Ticks & labels', (_) => const _Ticks()),
        DemoTab('Needles & markers', (_) => const _Needles()),
        DemoTab('Ranges', (_) => const _Ranges()),
        DemoTab('Bars', (_) => const _Bars()),
        DemoTab('Layout', (_) => const _Layout()),
      ],
    );
  }
}

const GxGaugeValue _v = GxGaugeValue(value: 64);
const GxLinearNeedle _pointer = GxLinearNeedle(
  shape: GxNeedleShape.triangle,
  position: GxNeedlePosition.top,
  size: Size(12, 12),
);

GxLinearTickStyle _tickByValue(double value, int index) => GxLinearTickStyle(
  length: value % 50 == 0 ? 20 : 12,
  thickness: value % 50 == 0 ? 2 : 1,
  color: value >= 80 ? Colors.red : null,
);

String _celsius(double value, int index) => '${value.toInt()}°';

TextStyle _hotLabels(double value, int index) =>
    TextStyle(color: value >= 80 ? Colors.red : null);

class _Ticks extends StatelessWidget {
  const _Ticks();

  @override
  Widget build(BuildContext context) {
    return DemoList(
      children: <Widget>[
        const DemoCard(
          title: 'Default',
          subtitle: 'A tenth of the range per major tick.',
          child: GxLinearScaleGauge(value: _v, height: 60),
        ),
        const DemoCard(
          title: 'Interval and minor ticks',
          child: GxLinearScaleGauge(
            value: _v,
            height: 60,
            interval: 25,
            minorTicksPerInterval: 4,
          ),
        ),
        for (final GxElementPosition position in GxElementPosition.values)
          DemoCard(
            title: 'tickPosition: ${position.name}',
            child: GxLinearScaleGauge(
              value: _v,
              height: 70,
              interval: 20,
              minorTicksPerInterval: 3,
              tickPosition: position,
              majorTickStyle: const GxLinearTickStyle(length: 18),
              minorTickStyle: const GxLinearTickStyle(length: 9),
            ),
          ),
        const DemoCard(
          title: 'Labels on top, custom axis',
          child: GxLinearScaleGauge(
            value: _v,
            height: 60,
            interval: 20,
            labelPosition: GxLabelPosition.topCenter,
            axisTrackStyle: GxLinearAxisStyle(
              thickness: 3,
              color: Colors.indigo,
              strokeCap: StrokeCap.round,
            ),
            axisLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            axisSpaceExtent: 12,
          ),
        ),
        const DemoCard(
          title: 'Formatter and stylers',
          subtitle:
              'labelFormatter, labelStyler and majorTickStyler per value.',
          child: GxLinearScaleGauge(
            value: _v,
            height: 70,
            interval: 10,
            minorTicksPerInterval: 1,
            labelFormatter: _celsius,
            labelStyler: _hotLabels,
            majorTickStyler: _tickByValue,
          ),
        ),
        const DemoCard(
          title: 'Hidden parts',
          subtitle: 'showMinorTicks: false, showAxisTrack: false.',
          child: GxLinearScaleGauge(
            value: _v,
            height: 60,
            interval: 20,
            showMinorTicks: false,
            showAxisTrack: false,
          ),
        ),
      ],
    );
  }
}

void _pin(Canvas canvas, Offset anchor, GxLinearNeedle needle) {
  final Paint paint = Paint()..color = needle.color!;
  final Offset head = anchor.translate(0, -needle.size.height);
  canvas
    ..drawLine(anchor, head, paint..strokeWidth = 2)
    ..drawCircle(head, 5, paint);
}

class _Needles extends StatelessWidget {
  const _Needles();

  @override
  Widget build(BuildContext context) {
    return DemoList(
      children: <Widget>[
        for (final GxNeedlePosition position in GxNeedlePosition.values)
          DemoCard(
            title: 'Needle position: ${position.name}',
            subtitle: 'Positions are relative to the axis.',
            child: GxLinearScaleGauge(
              value: _v,
              height: 70,
              interval: 20,
              needle: GxLinearNeedle(
                shape: GxNeedleShape.triangle,
                position: position,
                size: const Size(12, 12),
                color: Colors.pink,
              ),
            ),
          ),
        const DemoCard(
          title: 'Needle label',
          child: GxLinearScaleGauge(
            value: _v,
            height: 80,
            interval: 20,
            needle: GxLinearNeedle(
              shape: GxNeedleShape.triangle,
              position: GxNeedlePosition.top,
              size: Size(12, 12),
              label: GxNeedleLabel(label: '{value}%'),
            ),
          ),
        ),
        const DemoCard(
          title: 'Marker pointers',
          subtitle: 'Extra needles at fixed values, each with a label.',
          child: GxLinearScaleGauge(
            value: _v,
            height: 80,
            interval: 20,
            needle: _pointer,
            markers: <GxLinearMarkerPointer>[
              GxLinearMarkerPointer(
                value: 30,
                needle: GxLinearNeedle(
                  shape: GxNeedleShape.diamond,
                  position: GxNeedlePosition.bottom,
                  color: Colors.teal,
                  label: GxNeedleLabel(label: 'min {value}'),
                ),
              ),
              GxLinearMarkerPointer(
                value: 90,
                needle: GxLinearNeedle(
                  shape: GxNeedleShape.diamond,
                  position: GxNeedlePosition.bottom,
                  color: Colors.red,
                  label: GxNeedleLabel(label: 'max {value}'),
                ),
              ),
            ],
          ),
        ),
        const DemoCard(
          title: 'Marker widgets',
          subtitle: 'Any widget, centered on the axis.',
          child: GxLinearScaleGauge(
            value: _v,
            height: 70,
            interval: 20,
            markers: <GxLinearMarkerPointer>[
              GxLinearMarkerPointer(
                value: 20,
                marker: Icon(Icons.flag, color: Colors.teal, size: 20),
              ),
              GxLinearMarkerPointer(
                value: 90,
                marker: Icon(Icons.warning_amber, color: Colors.red, size: 20),
              ),
            ],
          ),
        ),
        const DemoCard(
          title: 'Custom needle painter',
          child: GxLinearScaleGauge(
            value: _v,
            height: 80,
            interval: 20,
            needle: GxLinearNeedle(
              shape: GxNeedleShape.custom,
              size: Size(10, 24),
              color: Colors.indigo,
            ),
            needlePainter: _pin,
          ),
        ),
      ],
    );
  }
}

Shader _heat(Rect bounds) => const LinearGradient(
  colors: <Color>[Colors.green, Colors.amber, Colors.red],
).createShader(bounds);

class _Ranges extends StatelessWidget {
  const _Ranges();

  @override
  Widget build(BuildContext context) {
    return const DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Colored ranges',
          child: GxLinearScaleGauge(
            value: _v,
            height: 60,
            interval: 20,
            needle: _pointer,
            ranges: <GxLinearRange>[
              GxLinearRange(start: 0, end: 60, color: Colors.green),
              GxLinearRange(start: 60, end: 85, color: Colors.orange),
              GxLinearRange(start: 85, end: 100, color: Colors.red),
            ],
          ),
        ),
        DemoCard(
          title: 'Labels, thickness and borders',
          child: GxLinearScaleGauge(
            value: _v,
            height: 80,
            interval: 20,
            ranges: <GxLinearRange>[
              GxLinearRange(
                start: 0,
                end: 60,
                thickness: 12,
                color: Color(0x3300AA00),
                borderColor: Colors.green,
                radius: Radius.circular(6),
                label: GxGaugeLabel(label: 'Normal'),
              ),
              GxLinearRange(
                start: 60,
                end: 100,
                thickness: 12,
                color: Color(0x33FF0000),
                borderColor: Colors.red,
                radius: Radius.circular(6),
                label: GxGaugeLabel(label: 'High'),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Gradient range',
          child: GxLinearScaleGauge(
            value: _v,
            height: 60,
            interval: 20,
            needle: _pointer,
            ranges: <GxLinearRange>[
              GxLinearRange(
                start: 0,
                end: 100,
                thickness: 8,
                shaderCallback: _heat,
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Ranges beside the axis',
          subtitle: 'position: inside / outside, with an offset.',
          child: GxLinearScaleGauge(
            value: _v,
            height: 90,
            interval: 20,
            showMinorTicks: false,
            showAxisLabel: false,
            ranges: <GxLinearRange>[
              GxLinearRange(
                start: 0,
                end: 50,
                position: GxElementPosition.outside,
                offset: 6,
                thickness: 6,
                color: Colors.teal,
                label: GxGaugeLabel(label: 'Outside'),
              ),
              GxLinearRange(
                start: 50,
                end: 100,
                position: GxElementPosition.inside,
                offset: 6,
                thickness: 6,
                color: Colors.purple,
                label: GxGaugeLabel(label: 'Inside'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const List<GxLinearBarPointer> _bars = <GxLinearBarPointer>[
  GxLinearBarPointer(start: 0, end: 40, color: Colors.green),
  GxLinearBarPointer(start: 40, end: 75, color: Colors.orange),
  GxLinearBarPointer(start: 75, end: 100, color: Colors.red),
];

class _Bars extends StatelessWidget {
  const _Bars();

  @override
  Widget build(BuildContext context) {
    return DemoList(
      children: <Widget>[
        for (final GxElementPosition position in <GxElementPosition>[
          GxElementPosition.cross,
          GxElementPosition.inside,
          GxElementPosition.outside,
        ])
          DemoCard(
            title: 'Bars with tickPosition: ${position.name}',
            subtitle: 'By default bars sit opposite the ticks.',
            child: GxLinearScaleGauge(
              value: _v,
              height: 80,
              interval: 20,
              tickPosition: position,
              barHeight: 10,
              bars: _bars,
            ),
          ),
        const DemoCard(
          title: 'Ticks colored by bars',
          subtitle: 'applyBarColorOnAxisTick: true',
          child: GxLinearScaleGauge(
            value: _v,
            height: 80,
            interval: 10,
            minorTicksPerInterval: 1,
            tickPosition: GxElementPosition.inside,
            barHeight: 6,
            applyBarColorOnAxisTick: true,
            majorTickStyle: GxLinearTickStyle(length: 20, thickness: 2),
            bars: _bars,
          ),
        ),
        const DemoCard(
          title: 'Per-bar placement, labels and gradient',
          child: GxLinearScaleGauge(
            value: _v,
            height: 100,
            interval: 20,
            showMinorTicks: false,
            bars: <GxLinearBarPointer>[
              GxLinearBarPointer(
                start: 0,
                end: 100,
                thickness: 8,
                position: GxElementPosition.outside,
                offset: 16,
                radius: Radius.circular(4),
                shaderCallback: _heat,
              ),
              GxLinearBarPointer(
                start: 20,
                end: 70,
                thickness: 20,
                position: GxElementPosition.inside,
                offset: 18,
                radius: Radius.circular(4),
                color: Colors.indigo,
                label: GxGaugeLabel(
                  label: 'Target',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  double _value = 40;

  @override
  Widget build(BuildContext context) {
    return DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Interactive',
          subtitle: 'Tap or drag along the axis.',
          child: GxLinearScaleGauge(
            value: GxGaugeValue(value: _value),
            height: 70,
            interval: 20,
            needle: const GxLinearNeedle(
              shape: GxNeedleShape.triangle,
              position: GxNeedlePosition.top,
              size: Size(14, 14),
              label: GxNeedleLabel(label: '{value}'),
            ),
            semanticLabel: 'Temperature',
            onChanged: (double v) => setState(() => _value = v),
          ),
        ),
        const DemoCard(
          title: 'Negative range',
          subtitle: '-40..40 with ticks every 10.',
          child: GxLinearScaleGauge(
            value: GxGaugeValue(value: -12, min: -40, max: 40),
            height: 60,
            interval: 10,
            needle: _pointer,
            ranges: <GxLinearRange>[
              GxLinearRange(start: -40, end: 0, color: Colors.lightBlue),
              GxLinearRange(start: 0, end: 40, color: Colors.orange),
            ],
          ),
        ),
        const DemoCard(
          title: 'Reverse',
          child: GxLinearScaleGauge(
            value: _v,
            height: 60,
            interval: 20,
            needle: _pointer,
            reverse: true,
          ),
        ),
        const DemoCard(
          title: 'Vertical',
          subtitle: 'Thermometer style: bottom to top, labels to the right.',
          child: SizedBox(
            height: 260,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GxLinearScaleGauge(
                  value: GxGaugeValue(value: 22, min: -10, max: 40),
                  direction: Axis.vertical,
                  height: 90,
                  interval: 10,
                  minorTicksPerInterval: 4,
                  labelFormatter: _celsius,
                  needle: GxLinearNeedle(
                    shape: GxNeedleShape.triangle,
                    position: GxNeedlePosition.top,
                    size: Size(12, 12),
                    color: Colors.red,
                  ),
                  ranges: <GxLinearRange>[
                    GxLinearRange(start: -10, end: 22, color: Colors.red),
                  ],
                ),
                GxLinearScaleGauge(
                  value: _v,
                  direction: Axis.vertical,
                  height: 90,
                  interval: 25,
                  tickPosition: GxElementPosition.inside,
                  barHeight: 10,
                  bars: _bars,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
