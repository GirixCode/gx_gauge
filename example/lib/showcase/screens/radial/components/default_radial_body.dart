import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/screens/radial/components/default/default_radial_angle.dart';
import 'package:gx_gauge_example/showcase/screens/radial/components/default/default_radial_needle.dart';
import 'package:gx_gauge_example/showcase/screens/radial/components/default/default_radial_pointers.dart';
import 'package:gx_gauge_example/showcase/screens/radial/components/default/default_radial_tick_label.dart';
import 'package:gx_gauge_example/showcase/screens/radial/components/default/default_radial_ticks.dart';
import 'package:gx_gauge_example/showcase/widgets/item_card.dart';

class DefaultRadialGaugeBody extends StatelessWidget {
  final double value;

  final GxGaugeLabel defaultLabel = const GxGaugeLabel(
    label: '{value}',
    style: TextStyle(fontSize: 12, color: Colors.black),
  );

  const DefaultRadialGaugeBody({super.key, required this.value});
  @override
  Widget build(BuildContext context) {
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
                      value: GxGaugeValue(value: value),
                      style: const GxRadialGaugeStyle(
                        color: Colors.orange,
                        thickness: 20,
                      ),
                    ),
                    GxRadialGauge(
                      size: twinSize,
                      value: GxGaugeValue(value: value),
                      style: const GxRadialGaugeStyle(
                        backgroundColor: Colors.amber,
                        color: Colors.green,
                        thickness: 20,
                      ),
                    ),
                  ],
                ),
              ),
              DefaultRadialAngle(value: value, twinSize: twinSize),
              DefaultRadialTicks(value: value, twinSize: twinSize),
              DefaultRadialTickLabel(value: value, twinSize: twinSize),
              DefaultRadialNeedle(value: value, twinSize: twinSize),
              DefaultRadialPointer(value: value, twinSize: twinSize),
            ],
          ),
        ),
      ],
    );
  }
}
