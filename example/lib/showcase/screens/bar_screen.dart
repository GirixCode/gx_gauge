import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/demo.dart';
import 'package:gx_gauge_example/showcase/widgets/showcase_settings.dart';

/// Every option of [GxLinearBarGauge].
class BarScreen extends StatelessWidget {
  const BarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GaugePage(
      title: 'Linear bar',
      actions: settingsActions(context),
      tabs: <DemoTab>[
        DemoTab('Basics', (_) => const _Basics()),
        DemoTab('Styling', (_) => const _Styling()),
        DemoTab('Needle & tooltip', (_) => const _NeedleTooltip()),
        DemoTab('Layout', (_) => const _Layout()),
      ],
    );
  }
}

const GxGaugeValue _v = GxGaugeValue(value: 68);

const List<GxLinearBarPointer> _traffic = <GxLinearBarPointer>[
  GxLinearBarPointer(start: 0, end: 50, color: Colors.green),
  GxLinearBarPointer(start: 50, end: 80, color: Colors.orange),
  GxLinearBarPointer(start: 80, end: 100, color: Colors.red),
];

const GxLinearNeedle _pointer = GxLinearNeedle(
  shape: GxNeedleShape.triangle,
  position: GxNeedlePosition.top,
  size: Size(14, 14),
);

class _Basics extends StatelessWidget {
  const _Basics();

  @override
  Widget build(BuildContext context) {
    return DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Segments',
          subtitle: 'Each bar covers start..end of the range.',
          child: GxLinearBarGauge(value: _v, bars: _traffic),
        ),
        DemoCard(
          title: 'Gaps between bars',
          subtitle: 'gapBetweenBars in logical pixels.',
          child: GxLinearBarGauge(value: _v, bars: _traffic, gapBetweenBars: 6),
        ),
        DemoCard(
          title: 'Rounded bars',
          child: GxLinearBarGauge(
            value: _v,
            height: 14,
            gapBetweenBars: 4,
            bars: <GxLinearBarPointer>[
              GxLinearBarPointer(
                start: 0,
                end: 50,
                color: Colors.green,
                radius: Radius.circular(7),
              ),
              GxLinearBarPointer(
                start: 50,
                end: 80,
                color: Colors.orange,
                radius: Radius.circular(7),
              ),
              GxLinearBarPointer(
                start: 80,
                end: 100,
                color: Colors.red,
                radius: Radius.circular(7),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Many segments',
          child: GxLinearBarGauge(
            value: _v,
            height: 16,
            gapBetweenBars: 3,
            bars: <GxLinearBarPointer>[
              for (int i = 0; i < 10; i++)
                GxLinearBarPointer(
                  start: i * 10,
                  end: i * 10 + 10,
                  color: Color.lerp(Colors.green, Colors.red, i / 9),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

Shader _rainbow(Rect bounds) => const LinearGradient(
  colors: <Color>[Colors.blue, Colors.purple, Colors.pink],
).createShader(bounds);

class _Styling extends StatelessWidget {
  const _Styling();

  @override
  Widget build(BuildContext context) {
    const TextStyle white = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
    return const DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Labels inside bars',
          child: GxLinearBarGauge(
            value: _v,
            height: 28,
            gapBetweenBars: 4,
            bars: <GxLinearBarPointer>[
              GxLinearBarPointer(
                start: 0,
                end: 50,
                color: Colors.green,
                label: GxGaugeLabel(label: 'Low', style: white),
              ),
              GxLinearBarPointer(
                start: 50,
                end: 80,
                color: Colors.orange,
                label: GxGaugeLabel(
                  label: 'Mid',
                  style: white,
                  textAlign: TextAlign.start,
                  spaceExtent: 6,
                ),
              ),
              GxLinearBarPointer(
                start: 80,
                end: 100,
                color: Colors.red,
                label: GxGaugeLabel(
                  label: 'High',
                  style: white,
                  textAlign: TextAlign.end,
                  spaceExtent: 6,
                ),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Gradient',
          subtitle: 'shaderCallback paints the bar with a shader.',
          child: GxLinearBarGauge(
            value: _v,
            height: 18,
            bars: <GxLinearBarPointer>[
              GxLinearBarPointer(
                start: 0,
                end: 100,
                radius: Radius.circular(9),
                shaderCallback: _rainbow,
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Outlined bars',
          subtitle: 'A transparent fill with borderColor.',
          child: GxLinearBarGauge(
            value: _v,
            height: 24,
            gapBetweenBars: 6,
            bars: <GxLinearBarPointer>[
              GxLinearBarPointer(
                start: 0,
                end: 50,
                color: Colors.transparent,
                borderColor: Colors.green,
                borderWidth: 2,
                radius: Radius.circular(4),
              ),
              GxLinearBarPointer(
                start: 50,
                end: 100,
                color: Color(0x22FF0000),
                borderColor: Colors.red,
                borderWidth: 2,
                radius: Radius.circular(4),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Thickness and position per bar',
          subtitle:
              'thickness sets the cross size; position/offset place '
              'bars around the center line.',
          child: GxLinearBarGauge(
            value: _v,
            height: 40,
            bars: <GxLinearBarPointer>[
              GxLinearBarPointer(
                start: 0,
                end: 100,
                thickness: 4,
                color: Colors.black26,
              ),
              GxLinearBarPointer(
                start: 0,
                end: 68,
                thickness: 12,
                position: GxElementPosition.outside,
                offset: 4,
                color: Colors.indigo,
              ),
              GxLinearBarPointer(
                start: 0,
                end: 40,
                thickness: 12,
                position: GxElementPosition.inside,
                offset: 4,
                color: Colors.teal,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void _drop(Canvas canvas, Offset anchor, GxLinearNeedle needle) {
  final double r = needle.size.width / 2;
  final Offset c = anchor.translate(0, -r * 2);
  canvas.drawPath(
    Path()
      ..moveTo(anchor.dx, anchor.dy)
      ..lineTo(c.dx - r, c.dy)
      ..arcToPoint(Offset(c.dx + r, c.dy), radius: Radius.circular(r))
      ..close(),
    Paint()..color = needle.color!,
  );
}

class _NeedleTooltip extends StatelessWidget {
  const _NeedleTooltip();

  @override
  Widget build(BuildContext context) {
    return const DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Needle',
          child: GxLinearBarGauge(value: _v, bars: _traffic, needle: _pointer),
        ),
        DemoCard(
          title: 'Needle with label',
          child: Padding(
            padding: EdgeInsets.only(top: 18),
            child: GxLinearBarGauge(
              value: _v,
              bars: _traffic,
              needle: GxLinearNeedle(
                shape: GxNeedleShape.triangle,
                position: GxNeedlePosition.top,
                size: Size(14, 14),
                label: GxNeedleLabel(label: '{value} km/h'),
              ),
            ),
          ),
        ),
        DemoCard(
          title: 'Tooltip on top',
          child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: GxLinearBarGauge(
              value: _v,
              bars: _traffic,
              tooltip: GxGaugeTooltip(
                label: '{value}%',
                radius: Radius.circular(6),
              ),
            ),
          ),
        ),
        DemoCard(
          title: 'Outlined tooltip below',
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: GxLinearBarGauge(
              value: _v,
              bars: _traffic,
              tooltip: GxGaugeTooltip(
                position: GxTooltipPosition.bottom,
                paintingStyle: PaintingStyle.stroke,
                borderColor: Colors.indigo,
                radius: Radius.circular(6),
                size: Size(70, 28),
              ),
            ),
          ),
        ),
        DemoCard(
          title: 'Custom needle painter',
          child: Padding(
            padding: EdgeInsets.only(top: 22),
            child: GxLinearBarGauge(
              value: _v,
              bars: _traffic,
              needle: GxLinearNeedle(
                shape: GxNeedleShape.custom,
                position: GxNeedlePosition.top,
                size: Size(14, 14),
                color: Colors.indigo,
              ),
              needlePainter: _drop,
            ),
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
  double _value = 30;

  @override
  Widget build(BuildContext context) {
    return DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Interactive',
          subtitle: 'Tap or drag the bars.',
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: GxLinearBarGauge(
              value: GxGaugeValue(value: _value),
              bars: _traffic,
              gapBetweenBars: 4,
              tooltip: const GxGaugeTooltip(label: '{value}%'),
              semanticLabel: 'Risk level',
              onChanged: (double v) => setState(() => _value = v),
            ),
          ),
        ),
        const DemoCard(
          title: 'Reverse',
          child: GxLinearBarGauge(
            value: _v,
            bars: _traffic,
            needle: _pointer,
            reverse: true,
          ),
        ),
        const DemoCard(
          title: 'Vertical',
          child: SizedBox(
            height: 240,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GxLinearBarGauge(
                  value: _v,
                  direction: Axis.vertical,
                  height: 24,
                  gapBetweenBars: 4,
                  bars: _traffic,
                  needle: _pointer,
                ),
                GxLinearBarGauge(
                  value: GxGaugeValue(value: 35),
                  direction: Axis.vertical,
                  height: 36,
                  bars: <GxLinearBarPointer>[
                    GxLinearBarPointer(
                      start: 0,
                      end: 100,
                      radius: Radius.circular(6),
                      color: Color(0x22000000),
                    ),
                    GxLinearBarPointer(
                      start: 0,
                      end: 35,
                      radius: Radius.circular(6),
                      color: Colors.teal,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
