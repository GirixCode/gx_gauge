import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/item_card.dart';

class DefaultRadialPointer extends StatelessWidget {
  final double value;
  final Size twinSize;

  const DefaultRadialPointer({
    super.key,
    required this.value,
    required this.twinSize,
  });

  double get ratioValue => (144 / 100) * value;

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = DateTime.now();
    final double hours = getHoursIn12HrsFormat(dateTime.hour).toDouble();
    final double minutes = dateTime.minute.toDouble();
    final double seconds = dateTime.second.toDouble();
    return ItemCard(
      title: 'With Pointers ',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GxRadialGauge(
                showValueAtCenter: false,
                startAngleInDegree: 270,
                size: twinSize,
                value: GxGaugeValue(value: ratioValue, min: 0, max: 144),
                showLabels: true,
                labelTickStyle: const GxRadialTickLabelStyle(padding: 20),
                interval: 12,
                style: const GxRadialGaugeStyle(
                  color: Colors.pinkAccent,
                  thickness: 15,
                ),
                labelFormatter: (value, index) {
                  if (index == 0) {
                    return '';
                  }
                  return (value / 12).toInt().toString();
                },
                pointers: [
                  GxRadialPointer(
                    value: ratioValue,
                    shape: GxRadialPointerShape.circle,
                    showNeedle: false,
                    style: const GxRadialPointerStyle(
                      color: Colors.indigoAccent,
                      paintingStyle: PaintingStyle.fill,
                      size: 12,
                      thickness: 2,
                    ),
                  ),
                  GxRadialPointer(
                    value: hours * 5,
                    shape: GxRadialPointerShape.circle,
                    showPointer: false,
                    style: const GxRadialPointerStyle(
                      color: Colors.blueGrey,
                      paintingStyle: PaintingStyle.fill,
                      size: 12,
                      thickness: 2,
                    ),
                    needle: const GxRadialNeedle(
                      thickness: 3.5,
                      topOffest: -30,
                      color: Colors.black,
                      shape: GxRadialNeedleShape.line,
                      alignment: GxRadialElementAlignment.end,
                    ),
                  ),
                  GxRadialPointer(
                    value: minutes,
                    showPointer: false,
                    needle: const GxRadialNeedle(
                      thickness: 2.5,
                      color: Colors.indigo,
                      shape: GxRadialNeedleShape.line,
                      topOffest: -10,
                      alignment: GxRadialElementAlignment.end,
                    ),
                  ),
                  GxRadialPointer(
                    value: seconds,
                    showPointer: false,
                    needle: const GxRadialNeedle(
                      thickness: 2,
                      color: Colors.indigo,
                      shape: GxRadialNeedleShape.line,
                      topOffest: -28,
                      bottomOffset: 10,
                      alignment: GxRadialElementAlignment.end,
                    ),
                  ),
                ],
              ),
              GxRadialGauge(
                showValueAtCenter: false,
                size: twinSize,
                startAngleInDegree: 180,
                value: GxGaugeValue(value: value),
                interval: 20,
                style: const GxRadialGaugeStyle(
                  color: Colors.indigoAccent,
                  thickness: 15,
                ),
                pointers: [
                  GxRadialPointer(
                    alignment: GxRadialElementAlignment.start,
                    value: value,
                    shape: GxRadialPointerShape.triangle,
                    style: const GxRadialPointerStyle(
                      color: Colors.indigoAccent,
                      paintingStyle: PaintingStyle.fill,
                      size: 20,
                      thickness: 2,
                    ),
                  ),
                  GxRadialPointer(
                    value: value,
                    shape: GxRadialPointerShape.circle,
                    alignment: GxRadialElementAlignment.center,
                    showNeedle: true,
                    showPointer: true,
                    style: const GxRadialPointerStyle(
                      color: Colors.pinkAccent,
                      paintingStyle: PaintingStyle.fill,
                      size: 12,
                      thickness: 2,
                    ),
                    needle: const GxRadialNeedle(
                      thickness: 2,
                      bottomOffset: 20,
                      circle: GxNeedleCap(
                        color: Colors.pinkAccent,
                        strokeWidth: 3,
                        paintingStyle: PaintingStyle.stroke,
                      ),
                      color: Colors.pinkAccent,
                      shape: GxRadialNeedleShape.line,
                      alignment: GxRadialElementAlignment.end,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Convert 24 hrs format to 12 hrs format
  int getHoursIn12HrsFormat(int hours) {
    if (hours > 12) {
      return hours - 12;
    }
    return hours;
  }
}
