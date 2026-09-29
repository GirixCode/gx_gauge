import 'package:examples/screens/radial/components/default/default_radial_angle.dart';
import 'package:examples/screens/radial/components/default/default_radial_needle.dart';
import 'package:examples/screens/radial/components/default/default_radial_pointers.dart';
import 'package:examples/screens/radial/components/default/default_radial_tick_label.dart';
import 'package:examples/screens/radial/components/default/default_radial_ticks.dart';
import 'package:examples/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class DefaultRadialGaugeBody extends StatelessWidget {
  final double value;

  final GaugeLabel defaultLabel = const GaugeLabel(
    label: '{value}',
    style: TextStyle(fontSize: 12, color: Colors.black),
  );

  const DefaultRadialGaugeBody({super.key, required this.value});
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    const Size twinSize = Size(150, 150);

    return Column(
      children: [
        Expanded(
          child: ListView(
            key: const Key('default_radial_gauge_list'),
            padding: const EdgeInsets.all(10),
            children: [
              ItemCard(
                  title: 'Default',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GxRadialGauge(
                        size: twinSize,
                        value: GaugeValue(
                          value: value,
                        ),
                        style: const RadialGaugeStyle(
                            color: Colors.orange, thickness: 20),
                      ),
                      GxRadialGauge(
                        size: twinSize,
                        value: GaugeValue(
                          value: value,
                        ),
                        style: const RadialGaugeStyle(
                            backgroundColor: Colors.amber,
                            color: Colors.green,
                            thickness: 20),
                      ),
                    ],
                  )),
              DefaultRadialAngle(value: value, twinSize: twinSize),
              DefaultRadialTicks(value: value, twinSize: twinSize),
              DefaultRadialTickLabel(value: value, twinSize: twinSize),
              DefaultRadialNeedle(value: value, twinSize: twinSize),
              DefaultRadialPointer(value: value, twinSize: twinSize)
            ],
          ),
        ),
      ],
    );
  }
}
