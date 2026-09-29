import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/item_card.dart';

class StepperLinearScreen extends StatelessWidget {
  const StepperLinearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(fontSize: 12, color: Colors.black);

    return Scaffold(
      appBar: AppBar(title: const Text('Stepper Linear Gauge')),
      body: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(8),
        key: const Key('scale_linear_gauge_list'),
        children: const [
          ItemCard(
            title: 'Default Stepper',
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: GxLinearStepperGauge(
                value: GxGaugeValue(value: 77),
                steps: [
                  GxStepperStep(
                    label: GxGaugeLabel(label: 'Ordered', style: textStyle),
                  ),
                  GxStepperStep(
                    label: GxGaugeLabel(label: 'Packed', style: textStyle),
                  ),
                  GxStepperStep(
                    label: GxGaugeLabel(label: 'Shipped', style: textStyle),
                  ),
                  GxStepperStep(
                    label: GxGaugeLabel(label: 'Delivered', style: textStyle),
                  ),
                ],
              ),
            ),
          ),
          ItemCard(
            title: 'Rectangle Stepper Shape',
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: GxLinearStepperGauge(
                shapeSize: 30,
                height: 50,
                offset: 20,
                shape: GxStepperShape.rectangle,
                value: GxGaugeValue(value: 79, min: 20, max: 100),
                style: GxLinearProgressStyle(color: Colors.red, thickness: 5),
                steps: [
                  GxStepperStep(
                    value: 20,
                    label: GxGaugeLabel(label: 'Ordered', style: textStyle),
                  ),
                  GxStepperStep(
                    value: 40,
                    label: GxGaugeLabel(label: 'Packed', style: textStyle),
                  ),
                  GxStepperStep(
                    value: 60,
                    label: GxGaugeLabel(label: 'Shipped', style: textStyle),
                  ),
                  GxStepperStep(
                    value: 80,
                    label: GxGaugeLabel(label: 'Delivered', style: textStyle),
                  ),
                  GxStepperStep(
                    value: 100,
                    label: GxGaugeLabel(label: 'Completed', style: textStyle),
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

/// Documentation
///
/// [GxLinearStepperGauge] is a linear gauge that displays the progress of a process in a step-by-step manner.
///
/// The following properties are required to create a [GxLinearStepperGauge]:
///
///  ///
