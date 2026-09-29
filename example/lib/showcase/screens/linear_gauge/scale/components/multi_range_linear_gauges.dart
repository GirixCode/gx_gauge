import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/item_card.dart';

class MultiRangeScaleLinearGaugeBody extends StatefulWidget {
  const MultiRangeScaleLinearGaugeBody({super.key});

  @override
  State<MultiRangeScaleLinearGaugeBody> createState() =>
      _MultiRangeScaleLinearGaugeBodyState();
}

class _MultiRangeScaleLinearGaugeBodyState
    extends State<MultiRangeScaleLinearGaugeBody> {
  @override
  Widget build(BuildContext context) {
    const double barValue = 100 / 3;
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(8),
      key: const Key('scale_linear_gauge_list'),
      children: [
        ItemCard(
          title: 'With Tick outside bars',
          child: GxLinearScaleGauge(
            interval: 20,
            minorTicksPerInterval: 5,
            axisSpaceExtent: 2,
            labelPosition: GxLabelPosition.topCenter,
            tickPosition: GxElementPosition.outside,
            axisTrackStyle: const GxLinearAxisStyle(thickness: 3),
            majorTickStyle: const GxLinearTickStyle(length: 50, thickness: 2),
            minorTickStyle: const GxLinearTickStyle(length: 30, thickness: 1),
            barOffset: 1,
            barHeight: 35,
            bars: [
              GxLinearBarPointer(
                label: const GxGaugeLabel(label: 'Low'),
                start: 0,
                end: barValue,
                thickness: 5,
                color: Colors.brown,
              ),
              GxLinearBarPointer(
                label: const GxGaugeLabel(label: 'Medium'),
                color: Colors.yellow.shade700,
                start: barValue * 1,
                end: barValue * 2,
                thickness: 5,
              ),
              GxLinearBarPointer(
                label: const GxGaugeLabel(label: 'High'),
                color: Colors.cyan.shade700,
                start: barValue * 2,
                end: barValue * 3,
                thickness: 5,
              ),
            ],
          ),
        ),
        ItemCard(
          title: 'With Tick inside bars',
          child: GxLinearScaleGauge(
            tickPosition: GxElementPosition.inside,
            labelPosition: GxLabelPosition.bottomCenter,
            minorTickStyle: const GxLinearTickStyle(length: 20, thickness: 1),
            majorTickStyle: const GxLinearTickStyle(length: 40, thickness: 1),
            axisTrackStyle: const GxLinearAxisStyle(
              thickness: 2,
              strokeCap: StrokeCap.round,
            ),
            // showAxisLabel: false,
            // showAxisTrack: false,
            barHeight: 30,
            barOffset: 0,
            bars: [
              GxLinearBarPointer(
                label: const GxGaugeLabel(
                  label: 'Developer',
                  style: TextStyle(color: Colors.black87),
                ),
                start: 0,
                end: barValue,
                thickness: 5,
                color: Colors.orangeAccent.shade400,
              ),
              GxLinearBarPointer(
                label: const GxGaugeLabel(
                  label: 'Designer',
                  style: TextStyle(color: Colors.black87),
                ),
                color: Colors.tealAccent,
                start: barValue * 1,
                end: barValue * 2,
                thickness: 5,
              ),
              GxLinearBarPointer(
                label: const GxGaugeLabel(
                  label: 'Tester',
                  style: TextStyle(color: Colors.black87),
                ),
                color: Colors.orangeAccent,
                start: barValue * 2,
                end: barValue * 3,
                thickness: 5,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ItemCard(
          title: 'With apply bar color on axis tick',
          child: GxLinearScaleGauge(
            tickPosition: GxElementPosition.inside,
            labelPosition: GxLabelPosition.bottomCenter,
            minorTickStyle: const GxLinearTickStyle(length: 20, thickness: 1),
            majorTickStyle: const GxLinearTickStyle(length: 40, thickness: 1),
            barHeight: 10,
            barOffset: 80,
            applyBarColorOnAxisTick: true,
            bars: [
              GxLinearBarPointer(
                start: 0,
                end: barValue,
                thickness: 5,
                color: Colors.red.shade400,
              ),
              GxLinearBarPointer(
                color: Colors.tealAccent.shade700,
                start: barValue * 1,
                end: barValue * 2,
                thickness: 5,
              ),
              GxLinearBarPointer(
                color: Colors.orangeAccent.shade400,
                start: barValue * 2,
                end: barValue * 3,
                thickness: 5,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ItemCard(
          title: 'With apply bar color on axis tick for in and out',
          child: GxLinearScaleGauge(
            tickPosition: GxElementPosition.inAndOut,
            minorTickStyle: const GxLinearTickStyle(length: 10, thickness: 1),
            majorTickStyle: const GxLinearTickStyle(length: 40, thickness: 2),
            applyBarColorOnAxisTick: true,
            bars: [
              GxLinearBarPointer(
                start: 0,
                end: barValue,
                thickness: 5,
                color: Colors.red.shade400,
              ),
              GxLinearBarPointer(
                color: Colors.tealAccent.shade700,
                start: barValue * 1,
                end: barValue * 2,
                thickness: 5,
              ),
              GxLinearBarPointer(
                color: Colors.orangeAccent.shade400,
                start: barValue * 2,
                end: barValue * 3,
                thickness: 5,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ItemCard(
          title: 'With apply bar color on axis tick and hide minor ticks',
          child: GxLinearScaleGauge(
            tickPosition: GxElementPosition.inAndOut,
            minorTickStyle: const GxLinearTickStyle(length: 10, thickness: 1),
            majorTickStyle: const GxLinearTickStyle(length: 40, thickness: 2),
            applyBarColorOnAxisTick: true,
            showMinorTicks: false,
            bars: [
              GxLinearBarPointer(
                start: 0,
                end: barValue,
                thickness: 5,
                color: Colors.red.shade400,
              ),
              GxLinearBarPointer(
                color: Colors.tealAccent.shade700,
                start: barValue * 1,
                end: barValue * 2,
                thickness: 5,
              ),
              GxLinearBarPointer(
                color: Colors.orangeAccent.shade400,
                start: barValue * 2,
                end: barValue * 3,
                thickness: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
