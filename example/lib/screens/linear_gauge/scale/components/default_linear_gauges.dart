import 'package:examples/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

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
          child: GxScaleLinearGauge(),
        ),
        const ItemCard(
          title: 'With basic Customized Style',
          child: GxScaleLinearGauge(
            minimum: 0,
            maximum: 100,
            interval: 20,
            minorTicksPerInterval: 5,
            axisSpaceExtent: 2,
            majorTickStyle: LinearTickStyle(
              length: 20,
              thickness: 2,
              color: Colors.blue,
            ),
          ),
        ),
        ItemCard(
            title: 'With Customized Label and Axis',
            child: GxScaleLinearGauge(
              minimum: 0,
              maximum: 100,
              interval: 50,
              minorTicksPerInterval: 10,
              axisSpaceExtent: 2,
              axisLabelStyle: const TextStyle(
                color: Colors.teal,
                fontSize: 10,
              ),
              valueToLabelFormatCallback: (value, index) => 'Label-$value',
              labelPosition: LinearGaugeLabelPosition.topCenter,
              majorTickStyle: const LinearTickStyle(
                length: 40,
                thickness: 2,
                color: Colors.teal,
              ),
              axisTrackStyle: const LinearAxisTrackStyle(
                color: Colors.teal,
              ),
              minorTickStyle:
                  const LinearTickStyle(color: Colors.white, thickness: 2),
            )),
        ItemCard(
          title: 'With Tick outside',
          child: GxScaleLinearGauge(
            minimum: 0,
            maximum: 100,
            interval: 20,
            minorTicksPerInterval: 5,
            axisSpaceExtent: 2,
            labelPosition: LinearGaugeLabelPosition.topCenter,
            tickPosition: LinearElementPosition.outside,
            axisTrackStyle: const LinearAxisTrackStyle(
              thickness: 2,
            ),
            majorTickStyle: const LinearTickStyle(
              length: 50,
              thickness: 2,
            ),
            minorTickStyle: const LinearTickStyle(
              length: 30,
              thickness: 1,
            ),
            markerPointers: [
              LinearMarkerPointer(
                value: 50,
                marker: const Icon(Icons.circle, color: Colors.red, size: 10),
              ),
            ],
          ),
        ),
        const ItemCard(
          title: 'With Tick inside',
          child: GxScaleLinearGauge(
            tickPosition: LinearElementPosition.inside,
            minorTickStyle: LinearTickStyle(
              length: 20,
              thickness: 1,
            ),
            majorTickStyle: LinearTickStyle(
              length: 40,
              thickness: 1,
            ),
            axisTrackStyle: LinearAxisTrackStyle(
                thickness: 2, strokeCap: StrokeCap.butt, color: Colors.orange),
            // showAxisLabel: false,
            // showAxisTrack: false,
          ),
        ),
        const ItemCard(
          title: 'With Tick Out and In',
          child: GxScaleLinearGauge(
            tickPosition: LinearElementPosition.outAndIn,
            minorTickStyle: LinearTickStyle(
              length: 30,
              thickness: 1,
            ),
            majorTickStyle: LinearTickStyle(
              length: 30,
              thickness: 1,
            ),
            axisTrackStyle: LinearAxisTrackStyle(
                thickness: 2, strokeCap: StrokeCap.round, color: Colors.orange),
            // showAxisLabel: false,
            // showAxisTrack: false,
            showMinorTicks: false,
          ),
        ),
        const ItemCard(
          title: 'With Tick In and Out',
          child: GxScaleLinearGauge(
            tickPosition: LinearElementPosition.inAndOut,
            minorTickStyle: LinearTickStyle(
              length: 10,
              thickness: 1,
            ),
            majorTickStyle: LinearTickStyle(
              length: 30,
              thickness: 1,
            ),
            axisTrackStyle: LinearAxisTrackStyle(
                thickness: 2, strokeCap: StrokeCap.round, color: Colors.orange),
            // showAxisLabel: false,
            // showAxisTrack: false,
            showMinorTicks: true,
          ),
        ),
        ItemCard(
          title: 'With Customized Major Tick Style',
          child: GxScaleLinearGauge(
            tickPosition: LinearElementPosition.inAndOut,
            minorTickStyle: const LinearTickStyle(
              length: 10,
              thickness: 1,
            ),
            majorTickStyle: const LinearTickStyle(
              length: 60,
              thickness: 4,
            ),
            axisTrackStyle: const LinearAxisTrackStyle(
                thickness: 4, strokeCap: StrokeCap.round, color: Colors.black),
            showMinorTicks: false,
            valueToMajorTickStyleCallback: (value, index) {
              return LinearTickStyle(
                length: 60,
                thickness: value == 50 ? 16 : 4,
                color: Colors.primaries[index % Colors.primaries.length],
              );
            },
          ),
        ),
        ItemCard(
          title: 'With Customized Linear Needle',
          child: GxScaleLinearGauge(
            minimum: 0,
            maximum: 100,
            interval: 10,
            minorTicksPerInterval: 2,
            axisLabelStyle: const TextStyle(
              color: Colors.deepOrange,
              fontSize: 14,
            ),
            valueToLabelFormatCallback: (value, index) =>
                value.toInt().toString(),
            labelPosition: LinearGaugeLabelPosition.topCenter,
            majorTickStyle: const LinearTickStyle(
              length: 40,
              thickness: 2,
              color: Colors.deepOrange,
            ),
            axisTrackStyle: const LinearAxisTrackStyle(
              color: Colors.deepOrange,
            ),
            minorTickStyle: const LinearTickStyle(
                color: Colors.deepOrange, thickness: 2, length: 18),
            value: 80,
            needle: const LinearNeedle(
              offset: 20,
              enabled: true,
              color: Colors.deepOrange,
              size: Size(20, 20),
              position: LinearGaugeNeedlePosition.bottom,
              needleType: LinearGaugeNeedleType.triangle,
            ),
          ),
        ),
        ItemCard(
          title: 'With Marker Pointers',
          child: GxScaleLinearGauge(
              tickPosition: LinearElementPosition.outAndIn,
              minorTickStyle: const LinearTickStyle(
                length: 10,
                thickness: 1,
              ),
              majorTickStyle: const LinearTickStyle(
                  length: 60, thickness: 1, color: Colors.black26),
              axisTrackStyle: const LinearAxisTrackStyle(
                  thickness: 2,
                  strokeCap: StrokeCap.round,
                  color: Colors.black26),
              showMinorTicks: false,
              valueToLabelFormatCallback: (value, index) =>
                  value.toInt().toString().length == 1
                      ? '0$value'
                      : value.toInt().toString(),
              markerPointers: [
                LinearMarkerPointer(
                  value: 10,
                  // marker:
                  //     const Icon(Icons.circle, color: Colors.red, size: 10),
                  needle: const LinearNeedle(
                    enabled: true,
                    color: Colors.blueGrey,
                    size: Size(2, 70),
                    position: LinearGaugeNeedlePosition.center,
                    needleType: LinearGaugeNeedleType.pipe,
                    offset: 10,
                  ),
                ),
                LinearMarkerPointer(
                  value: 70,
                  needle: const LinearNeedle(
                    enabled: true,
                    color: Colors.blueGrey,
                    size: Size(2, 70),
                    position: LinearGaugeNeedlePosition.center,
                    needleType: LinearGaugeNeedleType.pipe,
                    offset: 10,
                  ),
                ),
              ]),
        ),
        ItemCard(
          title: 'With Filled area and Marker Pointers',
          child: GxScaleLinearGauge(
            tickPosition: LinearElementPosition.outAndIn,
            minorTickStyle: const LinearTickStyle(
              length: 10,
              thickness: 1,
            ),
            majorTickStyle: const LinearTickStyle(
              length: 60,
              thickness: 1,
            ),
            axisTrackStyle: const LinearAxisTrackStyle(
                thickness: 2,
                strokeCap: StrokeCap.round,
                color: Colors.black26),
            showMinorTicks: false,
            valueToMajorTickStyleCallback: (value, index) {
              return LinearTickStyle(
                length: 60,
                thickness: (value == 30 || value == 80) ? 4 : 1,
                color: (value == 30 || value == 80)
                    ? Colors.green
                    : Colors.black26,
              );
            },
            valueToLabelFormatCallback: (value, index) =>
                value.toInt().toString().length == 1
                    ? '0$value'
                    : value.toInt().toString(),
            markerPointers: [
              LinearMarkerPointer(
                value: 10,
                // marker:
                //     const Icon(Icons.circle, color: Colors.red, size: 10),
                needle: const LinearNeedle(
                  enabled: true,
                  color: Colors.blueGrey,
                  size: Size(2, 70),
                  position: LinearGaugeNeedlePosition.center,
                  needleType: LinearGaugeNeedleType.pipe,
                  offset: 10,
                ),
              ),
              LinearMarkerPointer(
                value: 70,
                needle: const LinearNeedle(
                  enabled: true,
                  color: Colors.blueGrey,
                  size: Size(2, 70),
                  position: LinearGaugeNeedlePosition.center,
                  needleType: LinearGaugeNeedleType.pipe,
                  offset: 10,
                ),
              ),
            ],
            valueToLabelStyleCallback: (value, index) => TextStyle(
              color:
                  (value == 10 || value == 70) ? Colors.black : Colors.black38,
              fontWeight: (value == 10 || value == 70)
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
            fillAreaPointers: [
              FillAreaPointer(
                  thickness: 60,
                  startValue: 30,
                  endValue: 80,
                  color: Colors.green.withOpacity(0.3))
            ],
          ),
        ),
        ItemCard(
          title: 'With Multiple Filled area and Marker Pointers',
          child: GxScaleLinearGauge(
            tickPosition: LinearElementPosition.outAndIn,
            minorTickStyle: const LinearTickStyle(
              length: 10,
              thickness: 1,
            ),
            majorTickStyle: const LinearTickStyle(
              length: 60,
              thickness: 1,
            ),
            axisTrackStyle: const LinearAxisTrackStyle(
                thickness: 2,
                strokeCap: StrokeCap.round,
                color: Colors.black26),
            showMinorTicks: false,
            valueToMajorTickStyleCallback: (value, index) {
              return LinearTickStyle(
                length: 60,
                thickness: (value == 30 || value == 80) ? 4 : 1,
                color: (value == 30 || value == 80)
                    ? Colors.orange
                    : Colors.black26,
              );
            },
            valueToLabelFormatCallback: (value, index) =>
                value.toInt().toString().length == 1
                    ? '0$value'
                    : value.toInt().toString(),
            markerPointers: [
              LinearMarkerPointer(
                value: 10,
                // marker:
                //     const Icon(Icons.circle, color: Colors.red, size: 10),
                needle: const LinearNeedle(
                  enabled: true,
                  color: Colors.blueGrey,
                  size: Size(2, 70),
                  position: LinearGaugeNeedlePosition.center,
                  needleType: LinearGaugeNeedleType.pipe,
                  offset: 10,
                ),
              ),
              LinearMarkerPointer(
                value: 70,
                needle: const LinearNeedle(
                  enabled: true,
                  color: Colors.blueGrey,
                  size: Size(2, 70),
                  position: LinearGaugeNeedlePosition.center,
                  needleType: LinearGaugeNeedleType.pipe,
                  offset: 10,
                ),
              ),
            ],
            valueToLabelStyleCallback: (value, index) => TextStyle(
              color:
                  (value == 10 || value == 70) ? Colors.black : Colors.black38,
              fontWeight: (value == 10 || value == 70)
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
            fillAreaPointers: [
              FillAreaPointer(
                  thickness: 60,
                  startValue: 10,
                  endValue: 70,
                  color: Colors.grey.withOpacity(0.3)),
              FillAreaPointer(
                  thickness: 48,
                  startValue: 30,
                  endValue: 80,
                  color: Colors.orange.withOpacity(0.3))
            ],
          ),
        ),
      ],
    );
  }

  // Build a Card with a GxScaleLinearGauge
  Widget buildCard(
    String title,
    Widget child,
  ) {
    return Card(
      elevation: 0.1,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
