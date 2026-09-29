import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/demo.dart';
import 'package:gx_gauge_example/showcase/widgets/showcase_settings.dart';

/// Every option of [GxLinearStepperGauge].
class StepperScreen extends StatelessWidget {
  const StepperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GaugePage(
      title: 'Linear stepper',
      actions: settingsActions(context),
      tabs: <DemoTab>[
        DemoTab('Basics', (_) => const _Basics()),
        DemoTab('Markers', (_) => const _Markers()),
        DemoTab('Interactive', (_) => const _Interactive()),
        DemoTab('Vertical', (_) => const _Vertical()),
      ],
    );
  }
}

const List<GxStepperStep> _order = <GxStepperStep>[
  GxStepperStep(label: GxGaugeLabel(label: 'Ordered')),
  GxStepperStep(label: GxGaugeLabel(label: 'Packed')),
  GxStepperStep(label: GxGaugeLabel(label: 'Shipped')),
  GxStepperStep(label: GxGaugeLabel(label: 'Delivered')),
];

class _Basics extends StatelessWidget {
  const _Basics();

  @override
  Widget build(BuildContext context) {
    return DemoList(
      children: <Widget>[
        const DemoCard(
          title: 'Default',
          subtitle: 'currentStep: 2. Steps up to and including it are reached.',
          child: GxLinearStepperGauge(currentStep: 2, steps: _order),
        ),
        for (final GxStepperShape shape in GxStepperShape.values)
          DemoCard(
            title: 'Shape: ${shape.name}',
            child: GxLinearStepperGauge(
              currentStep: 1,
              shape: shape,
              shapeSize: 24,
              steps: _order,
            ),
          ),
        const DemoCard(
          title: 'Custom colors and sizes',
          child: GxLinearStepperGauge(
            currentStep: 2,
            height: 64,
            shapeSize: 30,
            offset: 18,
            style: GxLinearProgressStyle(
              color: Colors.deepOrange,
              backgroundColor: Color(0x33FF5722),
              thickness: 8,
            ),
            steps: _order,
          ),
        ),
        const DemoCard(
          title: 'Nothing reached yet',
          subtitle: 'currentStep: -1',
          child: GxLinearStepperGauge(currentStep: -1, steps: _order),
        ),
      ],
    );
  }
}

class _Markers extends StatelessWidget {
  const _Markers();

  @override
  Widget build(BuildContext context) {
    return const DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Custom marker text',
          subtitle: 'marker replaces the 1-based step number.',
          child: GxLinearStepperGauge(
            currentStep: 2,
            shapeSize: 26,
            steps: <GxStepperStep>[
              GxStepperStep(
                marker: '✓',
                label: GxGaugeLabel(label: 'Cart'),
              ),
              GxStepperStep(
                marker: '✓',
                label: GxGaugeLabel(label: 'Address'),
              ),
              GxStepperStep(
                marker: '€',
                label: GxGaugeLabel(label: 'Payment'),
              ),
              GxStepperStep(
                marker: '★',
                label: GxGaugeLabel(label: 'Review'),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Styled marker and label text',
          child: GxLinearStepperGauge(
            currentStep: 1,
            shapeSize: 26,
            activeStyle: TextStyle(fontWeight: FontWeight.bold),
            inactiveStyle: TextStyle(color: Colors.grey),
            steps: <GxStepperStep>[
              GxStepperStep(
                label: GxGaugeLabel(
                  label: 'Draft',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              GxStepperStep(
                label: GxGaugeLabel(
                  label: 'Review',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              GxStepperStep(
                label: GxGaugeLabel(
                  label: 'Publish',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
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
  int _step = 1;

  void _go(int step) =>
      setState(() => _step = step.clamp(0, _order.length - 1));

  @override
  Widget build(BuildContext context) {
    return DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Tap a step',
          subtitle:
              'onStepTapped reports the nearest step; duration animates '
              'the progress line between steps.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GxLinearStepperGauge(
                currentStep: _step,
                steps: _order,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                semanticLabel: 'Order status',
                onStepTapped: _go,
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  OutlinedButton(
                    onPressed: _step > 0 ? () => _go(_step - 1) : null,
                    child: const Text('Back'),
                  ),
                  Expanded(
                    child: Text(
                      'Step ${_step + 1} of ${_order.length}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FilledButton(
                    onPressed: _step < _order.length - 1
                        ? () => _go(_step + 1)
                        : null,
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Vertical extends StatelessWidget {
  const _Vertical();

  @override
  Widget build(BuildContext context) {
    return const DemoList(
      children: <Widget>[
        DemoCard(
          title: 'Vertical',
          subtitle: 'direction: Axis.vertical runs bottom to top.',
          child: SizedBox(
            height: 280,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GxLinearStepperGauge(
                  currentStep: 1,
                  direction: Axis.vertical,
                  height: 90,
                  steps: _order,
                ),
                GxLinearStepperGauge(
                  currentStep: 2,
                  direction: Axis.vertical,
                  height: 90,
                  reverse: true,
                  shape: GxStepperShape.diamond,
                  steps: _order,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
