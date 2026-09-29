import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/demo.dart';
import 'package:gx_gauge_example/showcase/widgets/showcase_settings.dart';

/// Every option of [GxLinearProgressGauge].
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GaugePage(
      title: 'Linear progress',
      actions: settingsActions(context),
      tabs: <DemoTab>[
        DemoTab('Basics', (_) => const _Basics()),
        DemoTab('Needles', (_) => const _Needles()),
        DemoTab('Labels', (_) => const _Labels()),
        DemoTab('Motion', (_) => const _Motion()),
        DemoTab('Layout', (_) => const _Layout()),
      ],
    );
  }
}

const GxGaugeValue _v = GxGaugeValue(value: 62);

class _Basics extends StatelessWidget {
  const _Basics();

  @override
  Widget build(BuildContext context) {
    return const DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Default',
          subtitle: 'A dense line in the theme\'s primary color.',
          child: GxLinearProgressGauge(value: _v),
        ),
        DemoCard(
          title: 'Bar style',
          subtitle: 'dense: false fills the gauge height with a rounded bar.',
          child: GxLinearProgressGauge(
            value: _v,
            height: 18,
            style: GxLinearProgressStyle(dense: false),
          ),
        ),
        DemoCard(
          title: 'Custom colors and thickness',
          child: GxLinearProgressGauge(
            value: _v,
            style: GxLinearProgressStyle(
              color: Colors.teal,
              backgroundColor: Color(0x3300BFA5),
              thickness: 6,
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
        DemoCard(
          title: 'Square corners',
          child: GxLinearProgressGauge(
            value: _v,
            height: 14,
            style: GxLinearProgressStyle(
              dense: false,
              radius: Radius.zero,
              color: Colors.deepOrange,
            ),
          ),
        ),
        DemoCard(
          title: 'Custom range',
          subtitle: 'value 350 on a 200..500 scale.',
          child: GxLinearProgressGauge(
            value: GxGaugeValue(value: 350, min: 200, max: 500),
          ),
        ),
      ],
    );
  }
}

void _flag(Canvas canvas, Offset anchor, GxLinearNeedle needle) {
  final Paint paint = Paint()..color = needle.color!;
  final double h = needle.size.height;
  canvas
    ..drawLine(anchor, anchor.translate(0, -h), paint..strokeWidth = 2)
    ..drawPath(
      Path()
        ..moveTo(anchor.dx, anchor.dy - h)
        ..lineTo(anchor.dx + h * 0.6, anchor.dy - h * 0.8)
        ..lineTo(anchor.dx, anchor.dy - h * 0.6)
        ..close(),
      paint,
    );
}

class _Needles extends StatelessWidget {
  const _Needles();

  @override
  Widget build(BuildContext context) {
    return DemoList(
      children: <Widget>[
        for (final GxNeedleShape shape in GxNeedleShape.values)
          if (shape != GxNeedleShape.custom)
            DemoCard(
              title: 'Shape: ${shape.name}',
              child: GxLinearProgressGauge(
                value: _v,
                needle: GxLinearNeedle(
                  shape: shape,
                  size: shape == GxNeedleShape.pipe
                      ? const Size(4, 20)
                      : const Size(14, 14),
                  position: GxNeedlePosition.bottom,
                ),
              ),
            ),
        for (final GxNeedlePosition position in GxNeedlePosition.values)
          DemoCard(
            title: 'Position: ${position.name}',
            child: GxLinearProgressGauge(
              value: _v,
              needle: GxLinearNeedle(
                shape: GxNeedleShape.diamond,
                position: position,
                size: const Size(14, 14),
                color: Colors.pink,
              ),
            ),
          ),
        const DemoCard(
          title: 'Outlined needle',
          child: GxLinearProgressGauge(
            value: _v,
            needle: GxLinearNeedle(
              shape: GxNeedleShape.circle,
              size: Size(16, 16),
              paintingStyle: PaintingStyle.stroke,
              strokeWidth: 3,
            ),
          ),
        ),
        const DemoCard(
          title: 'Needle label',
          subtitle: '{value} is replaced with the current value.',
          child: Padding(
            padding: EdgeInsets.only(top: 16),
            child: GxLinearProgressGauge(
              value: _v,
              needle: GxLinearNeedle(
                shape: GxNeedleShape.triangle,
                position: GxNeedlePosition.top,
                size: Size(12, 12),
                label: GxNeedleLabel(label: '{value}%'),
              ),
            ),
          ),
        ),
        const DemoCard(
          title: 'Custom needle painter',
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: GxLinearProgressGauge(
              value: _v,
              needle: GxLinearNeedle(
                shape: GxNeedleShape.custom,
                size: Size(10, 22),
                color: Colors.indigo,
              ),
              needlePainter: _flag,
            ),
          ),
        ),
      ],
    );
  }
}

class _Labels extends StatelessWidget {
  const _Labels();

  @override
  Widget build(BuildContext context) {
    const TextStyle onBar = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
    return DemoList(
      children: <Widget>[
        for (final TextAlign align in <TextAlign>[
          TextAlign.start,
          TextAlign.center,
          TextAlign.end,
        ])
          DemoCard(
            title: 'Label aligned ${align.name}',
            subtitle: 'start/end follow the text direction.',
            child: GxLinearProgressGauge(
              value: _v,
              height: 22,
              style: const GxLinearProgressStyle(dense: false),
              showLabel: true,
              label: GxGaugeLabel(
                label: '{value}%',
                textAlign: align,
                spaceExtent: 8,
                style: onBar,
              ),
            ),
          ),
        const DemoCard(
          title: 'Label with an offset',
          child: GxLinearProgressGauge(
            value: _v,
            height: 40,
            showLabel: true,
            label: GxGaugeLabel(
              label: 'Uploading… {value}%',
              offset: Offset(0, -14),
            ),
          ),
        ),
      ],
    );
  }
}

class _Motion extends StatefulWidget {
  const _Motion();

  @override
  State<_Motion> createState() => _MotionState();
}

class _MotionState extends State<_Motion> {
  final math.Random _random = math.Random(7);
  double _value = 30;
  double _drag = 40;

  static const Map<String, Curve> _curves = <String, Curve>{
    'linear': Curves.linear,
    'easeInOut': Curves.easeInOut,
    'easeOutCubic': Curves.easeOutCubic,
    'bounceOut': Curves.bounceOut,
    'elasticOut': Curves.elasticOut,
  };

  @override
  Widget build(BuildContext context) {
    return DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Implicit animation',
          subtitle:
              'duration + curve animate every value change, continuing '
              'from the value on screen when interrupted.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (final MapEntry<String, Curve> e
                  in _curves.entries) ...<Widget>[
                Text(e.key, style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 6),
                GxLinearProgressGauge(
                  value: GxGaugeValue(value: _value),
                  duration: const Duration(milliseconds: 900),
                  curve: e.value,
                ),
                const SizedBox(height: 14),
              ],
              FilledButton.icon(
                onPressed: () =>
                    setState(() => _value = 5 + _random.nextDouble() * 90),
                icon: const Icon(Icons.shuffle),
                label: const Text('New value'),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Interactive',
          subtitle: 'Tap or drag the bar: onChanged makes it a slider.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GxLinearProgressGauge(
                value: GxGaugeValue(value: _drag),
                height: 24,
                style: const GxLinearProgressStyle(dense: false),
                showLabel: true,
                label: const GxGaugeLabel(
                  label: '{value}',
                  style: TextStyle(color: Colors.white),
                ),
                semanticLabel: 'Brightness',
                onChanged: (double v) => setState(() => _drag = v),
              ),
              const SizedBox(height: 8),
              Text('Value: ${_drag.toStringAsFixed(1)}'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    return const DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Reverse',
          subtitle:
              'Fills from the end. Toggle RTL in the app bar: '
              'gauges mirror automatically.',
          child: GxLinearProgressGauge(value: _v, reverse: true),
        ),
        DemoCard(
          title: 'Vertical',
          subtitle: 'direction: Axis.vertical fills bottom to top.',
          child: SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GxLinearProgressGauge(
                  value: GxGaugeValue(value: 25),
                  direction: Axis.vertical,
                ),
                GxLinearProgressGauge(
                  value: GxGaugeValue(value: 60),
                  direction: Axis.vertical,
                  height: 20,
                  style: GxLinearProgressStyle(
                    dense: false,
                    color: Colors.teal,
                  ),
                ),
                GxLinearProgressGauge(
                  value: GxGaugeValue(value: 85),
                  direction: Axis.vertical,
                  height: 20,
                  style: GxLinearProgressStyle(
                    dense: false,
                    color: Colors.deepOrange,
                  ),
                  needle: GxLinearNeedle(
                    shape: GxNeedleShape.triangle,
                    position: GxNeedlePosition.top,
                    size: Size(12, 12),
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
