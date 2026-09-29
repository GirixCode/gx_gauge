import 'package:examples/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class StepperLinearScreen extends StatelessWidget {
  const StepperLinearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(
      fontSize: 12,
      color: Colors.black,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stepper Linear Gauge'),
      ),
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
                  child: GxStepperLinearGauge(
                      value: GaugeValue(
                        value: 77,
                      ),
                      stepperPointers: [
                        StepperPointer(
                            label:
                                GaugeLabel(label: 'Ordered', style: textStyle)),
                        StepperPointer(
                            label:
                                GaugeLabel(label: 'Packed', style: textStyle)),
                        StepperPointer(
                            label:
                                GaugeLabel(label: 'Shipped', style: textStyle)),
                        StepperPointer(
                            label: GaugeLabel(
                                label: 'Delivered', style: textStyle)),
                      ]),
                )),
            ItemCard(
                title: 'Rectangle Stepper Shape',
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GxStepperLinearGauge(
                      shapeSize: 30,
                      height: 50,
                      offset: 20,
                      shape: StepperShape.rectangle,
                      value: GaugeValue(
                        value: 79,
                        min: 20,
                        max: 100,
                      ),
                      style:
                          ProgressLinearStyle(color: Colors.red, thickness: 5),
                      stepperPointers: [
                        StepperPointer(
                            value: 20,
                            label:
                                GaugeLabel(label: 'Ordered', style: textStyle)),
                        StepperPointer(
                            value: 40,
                            label:
                                GaugeLabel(label: 'Packed', style: textStyle)),
                        StepperPointer(
                            value: 60,
                            label:
                                GaugeLabel(label: 'Shipped', style: textStyle)),
                        StepperPointer(
                            value: 80,
                            label: GaugeLabel(
                                label: 'Delivered', style: textStyle)),
                        StepperPointer(
                            value: 100,
                            label: GaugeLabel(
                                label: 'Completed', style: textStyle)),
                      ]),
                )),
          ]),
    );
  }
}


/// Documentation
/// 
/// [GxStepperLinearGauge] is a linear gauge that displays the progress of a process in a step-by-step manner.
/// 
/// The following properties are required to create a [GxStepperLinearGauge]:
/// 
///  /// 