import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/item_card.dart';

class DefaultScaleLinearGaugeBody extends StatefulWidget {
  const DefaultScaleLinearGaugeBody({super.key});

  @override
  State<DefaultScaleLinearGaugeBody> createState() =>
      _DefaultScaleLinearGaugeBodyState();
}

class _DefaultScaleLinearGaugeBodyState
    extends State<DefaultScaleLinearGaugeBody> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(8),
      key: const Key('scale_linear_gauge_list'),
      children: [
        const ItemCard(
          title: 'Default Scale Linear Gauge',
          child: GxLinearScaleGauge(),
        ),
        const ItemCard(
          title: 'With basic Customized Style',
          child: GxLinearScaleGauge(
            interval: 20,
            minorTicksPerInterval: 5,
            axisSpaceExtent: 2,
            majorTickStyle: GxLinearTickStyle(
              length: 20,
              thickness: 2,
              color: Colors.blue,
            ),
          ),
        ),
        ItemCard(
          title: 'With Customized Label and Axis',
          child: GxLinearScaleGauge(
            interval: 50,
            minorTicksPerInterval: 10,
            axisSpaceExtent: 2,
            axisLabelStyle: const TextStyle(color: Colors.teal, fontSize: 10),
            labelFormatter: (value, index) => 'Label-$value',
            labelPosition: GxLabelPosition.topCenter,
            majorTickStyle: const GxLinearTickStyle(
              length: 40,
              thickness: 2,
              color: Colors.teal,
            ),
            axisTrackStyle: const GxLinearAxisStyle(color: Colors.teal),
            minorTickStyle: const GxLinearTickStyle(
              color: Colors.white,
              thickness: 2,
            ),
          ),
        ),
        ItemCard(
          title: 'With Tick outside',
          child: GxLinearScaleGauge(
            interval: 20,
            minorTicksPerInterval: 5,
            axisSpaceExtent: 2,
            labelPosition: GxLabelPosition.topCenter,
            tickPosition: GxElementPosition.outside,
            axisTrackStyle: const GxLinearAxisStyle(thickness: 2),
            majorTickStyle: const GxLinearTickStyle(length: 50, thickness: 2),
            minorTickStyle: const GxLinearTickStyle(length: 30, thickness: 1),
            markers: [
              GxLinearMarkerPointer(
                value: 50,
                marker: const Icon(Icons.circle, color: Colors.red, size: 10),
              ),
            ],
          ),
        ),
        const ItemCard(
          title: 'With Tick inside',
          child: GxLinearScaleGauge(
            tickPosition: GxElementPosition.inside,
            minorTickStyle: GxLinearTickStyle(length: 20, thickness: 1),
            majorTickStyle: GxLinearTickStyle(length: 40, thickness: 1),
            axisTrackStyle: GxLinearAxisStyle(
              thickness: 2,
              strokeCap: StrokeCap.butt,
              color: Colors.orange,
            ),
            // showAxisLabel: false,
            // showAxisTrack: false,
          ),
        ),
        const ItemCard(
          title: 'With Tick Out and In',
          child: GxLinearScaleGauge(
            tickPosition: GxElementPosition.outAndIn,
            minorTickStyle: GxLinearTickStyle(length: 30, thickness: 1),
            majorTickStyle: GxLinearTickStyle(length: 30, thickness: 1),
            axisTrackStyle: GxLinearAxisStyle(
              thickness: 2,
              strokeCap: StrokeCap.round,
              color: Colors.orange,
            ),
            // showAxisLabel: false,
            // showAxisTrack: false,
            showMinorTicks: false,
          ),
        ),
        const ItemCard(
          title: 'With Tick In and Out',
          child: GxLinearScaleGauge(
            tickPosition: GxElementPosition.inAndOut,
            minorTickStyle: GxLinearTickStyle(length: 10, thickness: 1),
            majorTickStyle: GxLinearTickStyle(length: 30, thickness: 1),
            axisTrackStyle: GxLinearAxisStyle(
              thickness: 2,
              strokeCap: StrokeCap.round,
              color: Colors.orange,
            ),
            // showAxisLabel: false,
            // showAxisTrack: false,
            showMinorTicks: true,
          ),
        ),
        ItemCard(
          title: 'With Customized Major Tick Style',
          child: GxLinearScaleGauge(
            tickPosition: GxElementPosition.inAndOut,
            minorTickStyle: const GxLinearTickStyle(length: 10, thickness: 1),
            majorTickStyle: const GxLinearTickStyle(length: 60, thickness: 4),
            axisTrackStyle: const GxLinearAxisStyle(
              thickness: 4,
              strokeCap: StrokeCap.round,
              color: Colors.black,
            ),
            showMinorTicks: false,
            majorTickStyler: (value, index) {
              return GxLinearTickStyle(
                length: 60,
                thickness: value == 50 ? 16 : 4,
                color: Colors.primaries[index % Colors.primaries.length],
              );
            },
          ),
        ),
        ItemCard(
          title: 'With Customized Linear Needle',
          child: GxLinearScaleGauge(
            interval: 10,
            minorTicksPerInterval: 2,
            axisLabelStyle: const TextStyle(
              color: Colors.deepOrange,
              fontSize: 14,
            ),
            labelFormatter: (value, index) => value.toInt().toString(),
            labelPosition: GxLabelPosition.topCenter,
            majorTickStyle: const GxLinearTickStyle(
              length: 40,
              thickness: 2,
              color: Colors.deepOrange,
            ),
            axisTrackStyle: const GxLinearAxisStyle(color: Colors.deepOrange),
            minorTickStyle: const GxLinearTickStyle(
              color: Colors.deepOrange,
              thickness: 2,
              length: 18,
            ),
            value: const GxGaugeValue(value: 80),
            needle: const GxLinearNeedle(
              offset: 20,
              enabled: true,
              color: Colors.deepOrange,
              size: Size(20, 20),
              position: GxNeedlePosition.bottom,
              shape: GxNeedleShape.triangle,
            ),
          ),
        ),
        ItemCard(
          title: 'With Marker Pointers',
          child: GxLinearScaleGauge(
            tickPosition: GxElementPosition.outAndIn,
            minorTickStyle: const GxLinearTickStyle(length: 10, thickness: 1),
            majorTickStyle: const GxLinearTickStyle(
              length: 60,
              thickness: 1,
              color: Colors.black26,
            ),
            axisTrackStyle: const GxLinearAxisStyle(
              thickness: 2,
              strokeCap: StrokeCap.round,
              color: Colors.black26,
            ),
            showMinorTicks: false,
            labelFormatter: (value, index) =>
                value.toInt().toString().length == 1
                ? '0$value'
                : value.toInt().toString(),
            markers: [
              GxLinearMarkerPointer(
                value: 10,
                // marker:
                //     const Icon(Icons.circle, color: Colors.red, size: 10),
                needle: const GxLinearNeedle(
                  enabled: true,
                  color: Colors.blueGrey,
                  size: Size(2, 70),
                  position: GxNeedlePosition.center,
                  shape: GxNeedleShape.pipe,
                  offset: 10,
                ),
              ),
              GxLinearMarkerPointer(
                value: 70,
                needle: const GxLinearNeedle(
                  enabled: true,
                  color: Colors.blueGrey,
                  size: Size(2, 70),
                  position: GxNeedlePosition.center,
                  shape: GxNeedleShape.pipe,
                  offset: 10,
                ),
              ),
            ],
          ),
        ),
        ItemCard(
          title: 'With Filled area and Marker Pointers',
          child: GxLinearScaleGauge(
            tickPosition: GxElementPosition.outAndIn,
            minorTickStyle: const GxLinearTickStyle(length: 10, thickness: 1),
            majorTickStyle: const GxLinearTickStyle(length: 60, thickness: 1),
            axisTrackStyle: const GxLinearAxisStyle(
              thickness: 2,
              strokeCap: StrokeCap.round,
              color: Colors.black26,
            ),
            showMinorTicks: false,
            majorTickStyler: (value, index) {
              return GxLinearTickStyle(
                length: 60,
                thickness: (value == 30 || value == 80) ? 4 : 1,
                color: (value == 30 || value == 80)
                    ? Colors.green
                    : Colors.black26,
              );
            },
            labelFormatter: (value, index) =>
                value.toInt().toString().length == 1
                ? '0$value'
                : value.toInt().toString(),
            markers: [
              GxLinearMarkerPointer(
                value: 10,
                // marker:
                //     const Icon(Icons.circle, color: Colors.red, size: 10),
                needle: const GxLinearNeedle(
                  enabled: true,
                  color: Colors.blueGrey,
                  size: Size(2, 70),
                  position: GxNeedlePosition.center,
                  shape: GxNeedleShape.pipe,
                  offset: 10,
                ),
              ),
              GxLinearMarkerPointer(
                value: 70,
                needle: const GxLinearNeedle(
                  enabled: true,
                  color: Colors.blueGrey,
                  size: Size(2, 70),
                  position: GxNeedlePosition.center,
                  shape: GxNeedleShape.pipe,
                  offset: 10,
                ),
              ),
            ],
            labelStyler: (value, index) => TextStyle(
              color: (value == 10 || value == 70)
                  ? Colors.black
                  : Colors.black38,
              fontWeight: (value == 10 || value == 70)
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
            fillAreas: [
              GxLinearFillArea(
                thickness: 60,
                start: 30,
                end: 80,
                color: Colors.green.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
        ItemCard(
          title: 'With Multiple Filled area and Marker Pointers',
          child: GxLinearScaleGauge(
            tickPosition: GxElementPosition.outAndIn,
            minorTickStyle: const GxLinearTickStyle(length: 10, thickness: 1),
            majorTickStyle: const GxLinearTickStyle(length: 60, thickness: 1),
            axisTrackStyle: const GxLinearAxisStyle(
              thickness: 2,
              strokeCap: StrokeCap.round,
              color: Colors.black26,
            ),
            showMinorTicks: false,
            majorTickStyler: (value, index) {
              return GxLinearTickStyle(
                length: 60,
                thickness: (value == 30 || value == 80) ? 4 : 1,
                color: (value == 30 || value == 80)
                    ? Colors.orange
                    : Colors.black26,
              );
            },
            labelFormatter: (value, index) =>
                value.toInt().toString().length == 1
                ? '0$value'
                : value.toInt().toString(),
            markers: [
              GxLinearMarkerPointer(
                value: 10,
                // marker:
                //     const Icon(Icons.circle, color: Colors.red, size: 10),
                needle: const GxLinearNeedle(
                  enabled: true,
                  color: Colors.blueGrey,
                  size: Size(2, 70),
                  position: GxNeedlePosition.center,
                  shape: GxNeedleShape.pipe,
                  offset: 10,
                ),
              ),
              GxLinearMarkerPointer(
                value: 70,
                needle: const GxLinearNeedle(
                  enabled: true,
                  color: Colors.blueGrey,
                  size: Size(2, 70),
                  position: GxNeedlePosition.center,
                  shape: GxNeedleShape.pipe,
                  offset: 10,
                ),
              ),
            ],
            labelStyler: (value, index) => TextStyle(
              color: (value == 10 || value == 70)
                  ? Colors.black
                  : Colors.black38,
              fontWeight: (value == 10 || value == 70)
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
            fillAreas: [
              GxLinearFillArea(
                thickness: 60,
                start: 10,
                end: 70,
                color: Colors.grey.withValues(alpha: 0.3),
              ),
              GxLinearFillArea(
                thickness: 48,
                start: 30,
                end: 80,
                color: Colors.orange.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build a Card with a GxLinearScaleGauge
  Widget buildCard(String title, Widget child) {
    return Card(
      elevation: 0.1,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
