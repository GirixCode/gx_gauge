import 'package:examples/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class DefaultRadialPointer extends StatelessWidget {
  final double value;
  final Size twinSize;

  const DefaultRadialPointer(
      {super.key, required this.value, required this.twinSize});

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
                  value: GaugeValue(value: ratioValue, min: 0, max: 144),
                  showLabels: true,
                  labelTickStyle: const RadialTickLabelStyle(
                    padding: 20,
                  ),
                  interval: 12,
                  style: const RadialGaugeStyle(
                      color: Colors.pinkAccent, thickness: 15),
                  valueToLabelFormatCallback: (value, index) {
                    if (index == 0) {
                      return '';
                    }
                    return (value / 12).toInt().toString();
                  },
                  pointers: [
                    RadialPointer(
                      value: ratioValue,
                      shape: RadialPointerShape.circle,
                      showNeedle: false,
                      style: const RadialPointerStyle(
                          color: Colors.indigoAccent,
                          paintingStyle: PaintingStyle.fill,
                          size: 12,
                          thickness: 2),
                    ),
                    RadialPointer(
                        value: hours * 5,
                        shape: RadialPointerShape.circle,
                        showPointer: false,
                        style: const RadialPointerStyle(
                            color: Colors.blueGrey,
                            paintingStyle: PaintingStyle.fill,
                            size: 12,
                            thickness: 2),
                        needle: const RadialNeedle(
                            thickness: 3.5,
                            topOffest: -30,
                            color: Colors.black,
                            shape: RadialNeedleShape.line,
                            alignment: RadialElementAlignment.end)),
                    RadialPointer(
                        value: minutes,
                        showPointer: false,
                        needle: const RadialNeedle(
                            thickness: 2.5,
                            color: Colors.indigo,
                            shape: RadialNeedleShape.line,
                            topOffest: -10,
                            alignment: RadialElementAlignment.end)),
                    RadialPointer(
                        value: seconds,
                        showPointer: false,
                        needle: const RadialNeedle(
                            thickness: 2,
                            color: Colors.indigo,
                            shape: RadialNeedleShape.line,
                            topOffest: -28,
                            bottomOffset: 10,
                            alignment: RadialElementAlignment.end)),
                  ],
                ),
                GxRadialGauge(
                  showValueAtCenter: false,
                  size: twinSize,
                  startAngleInDegree: 180,
                  value: GaugeValue(
                    value: value,
                  ),
                  interval: 20,
                  style: const RadialGaugeStyle(
                      color: Colors.indigoAccent, thickness: 15),
                  pointers: [
                    RadialPointer(
                      alignment: RadialElementAlignment.start,
                      value: value,
                      shape: RadialPointerShape.triangle,
                      style: const RadialPointerStyle(
                          color: Colors.indigoAccent,
                          paintingStyle: PaintingStyle.fill,
                          size: 20,
                          thickness: 2),
                    ),
                    RadialPointer(
                        value: value,
                        shape: RadialPointerShape.circle,
                        alignment: RadialElementAlignment.center,
                        showNeedle: true,
                        showPointer: true,
                        style: const RadialPointerStyle(
                            color: Colors.pinkAccent,
                            paintingStyle: PaintingStyle.fill,
                            size: 12,
                            thickness: 2),
                        needle: const RadialNeedle(
                            thickness: 2,
                            bottomOffset: 20,
                            circle: NeedleCircle(
                                color: Colors.pinkAccent,
                                strokeWidth: 3,
                                paintingStyle: PaintingStyle.stroke),
                            color: Colors.pinkAccent,
                            shape: RadialNeedleShape.line,
                            alignment: RadialElementAlignment.end)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ));
  }

// Convert 24 hrs format to 12 hrs format
  int getHoursIn12HrsFormat(int hours) {
    if (hours > 12) {
      return hours - 12;
    }
    return hours;
  }
}
