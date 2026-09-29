import 'package:examples/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class DefaultRadialShowCase extends StatefulWidget {
  final double value;

  const DefaultRadialShowCase({
    super.key,
    required this.value,
  });

  @override
  State<DefaultRadialShowCase> createState() => _DefaultRadialShowCaseState();
}

class _DefaultRadialShowCaseState extends State<DefaultRadialShowCase> {
  late DateTime dateTime;
  final ValueNotifier<DateTime> dateTimeNotifier =
      ValueNotifier<DateTime>(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final Size twinSize = Size(size.width / 2.5, size.width / 2.5);
    return ListView(
      children: [
        ItemCard(
          title: 'Clock Show Case',
          child: ValueListenableBuilder<DateTime>(
              valueListenable: dateTimeNotifier,
              builder: (_, DateTime now, __) {
                final int hours = getHoursIn12HrsFormat(now.hour);
                final int minutes = now.minute;
                final int seconds = now.second;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: GxRadialGauge(
                        showValueAtCenter: false,
                        startAngleInDegree: 270,
                        size: twinSize,
                        value: GaugeValue(
                            value: seconds.toDouble(), min: 0, max: 60),
                        showLabels: true,
                        labelTickStyle: const RadialTickLabelStyle(
                          padding: 20,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        interval: 5,
                        minorTicksPerInterval: 4,
                        style: const RadialGaugeStyle(
                            strokeCap: StrokeCap.butt,
                            color: Colors.brown,
                            thickness: 20),
                        showMajorTicks: true,
                        showMinorTicks: true,
                        majorTickStyle: const RadialTickStyle(
                            color: Colors.brown,
                            thickness: 2,
                            length: 14,
                            alignment: RadialElementAlignment.end,
                            position: RadialElementPosition.inside),
                        minorTickStyle: RadialTickStyle(
                            color: Colors.brown.shade100,
                            alignment: RadialElementAlignment.end,
                            position: RadialElementPosition.inside,
                            length: 18),
                        valueToLabelFormatCallback: (value, index) {
                          if (index == 0) {
                            return '';
                          }
                          return (value / 5).toInt().toString();
                        },
                        pointers: [
                          RadialPointer(
                            value: seconds.toDouble(),
                            shape: RadialPointerShape.triangle,
                            alignment: RadialElementAlignment.start,
                            showNeedle: false,
                            style: const RadialPointerStyle(
                                color: Colors.brown,
                                paintingStyle: PaintingStyle.fill,
                                size: 20,
                                thickness: 2),
                          ),
                          RadialPointer(
                              value: getHourRatio(hours, minutes),
                              showPointer: false,
                              style: const RadialPointerStyle(
                                  color: Colors.brown,
                                  paintingStyle: PaintingStyle.fill,
                                  size: 12,
                                  thickness: 2),
                              needle: const RadialNeedle(
                                  thickness: 3.5,
                                  topOffest: -40,
                                  color: Colors.brown,
                                  shape: RadialNeedleShape.line,
                                  alignment: RadialElementAlignment.end)),
                          RadialPointer(
                              value: minutes.toDouble(),
                              showPointer: false,
                              needle: const RadialNeedle(
                                  thickness: 2.5,
                                  color: Colors.brown,
                                  shape: RadialNeedleShape.line,
                                  topOffest: -20,
                                  alignment: RadialElementAlignment.end)),
                          RadialPointer(
                              value: seconds.toDouble(),
                              showPointer: false,
                              needle: const RadialNeedle(
                                  thickness: 2,
                                  color: Colors.brown,
                                  shape: RadialNeedleShape.line,
                                  topOffest: -15,
                                  bottomOffset: 20,
                                  alignment: RadialElementAlignment.end)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        radius: twinSize.width / 2,
                        child: GxRadialGauge(
                          showValueAtCenter: false,
                          startAngleInDegree: 270,
                          size: twinSize,
                          value: GaugeValue(
                              value: seconds.toDouble(), min: 0, max: 60),
                          showLabels: true,
                          labelTickStyle: const RadialTickLabelStyle(
                            padding: 20,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          interval: 5,
                          minorTicksPerInterval: 4,
                          style: const RadialGaugeStyle(
                              strokeCap: StrokeCap.butt,
                              paintingStyle: PaintingStyle.fill,
                              color: Colors.blueGrey,
                              backgroundColor: Colors.blueGrey,
                              thickness: 20),
                          showMajorTicks: true,
                          showMinorTicks: true,
                          majorTickStyle: const RadialTickStyle(
                              color: Colors.white,
                              thickness: 2,
                              length: 12,
                              alignment: RadialElementAlignment.end,
                              position: RadialElementPosition.inside),
                          minorTickStyle: RadialTickStyle(
                              color: Colors.grey.shade300,
                              alignment: RadialElementAlignment.end,
                              position: RadialElementPosition.inside,
                              length: 10),
                          valueToLabelFormatCallback: (value, index) {
                            if (index == 0) {
                              return '';
                            }
                            return (value / 5).toInt().toString();
                          },
                          pointers: [
                            // RadialPointer(
                            //   value: seconds.toDouble(),
                            //   shape: RadialPointerShape.triangle,
                            //   alignment: RadialElementAlignment.start,
                            //   showNeedle: false,
                            //   style: const RadialPointerStyle(
                            //       color: Colors.blueGrey,
                            //       paintingStyle: PaintingStyle.fill,
                            //       size: 20,
                            //       thickness: 2),
                            // ),
                            RadialPointer(
                                value: getHourRatio(hours, minutes),
                                showPointer: false,
                                style: const RadialPointerStyle(
                                    color: Colors.white,
                                    paintingStyle: PaintingStyle.fill,
                                    size: 12,
                                    thickness: 2),
                                needle: const RadialNeedle(
                                    thickness: 3.5,
                                    topOffest: -40,
                                    color: Colors.white,
                                    shape: RadialNeedleShape.line,
                                    alignment: RadialElementAlignment.end)),
                            RadialPointer(
                                value: minutes.toDouble(),
                                showPointer: false,
                                needle: const RadialNeedle(
                                    thickness: 2.5,
                                    color: Colors.white,
                                    shape: RadialNeedleShape.line,
                                    topOffest: -20,
                                    alignment: RadialElementAlignment.end)),
                            RadialPointer(
                                value: seconds.toDouble(),
                                showPointer: false,
                                needle: const RadialNeedle(
                                    thickness: 2,
                                    color: Colors.white,
                                    shape: RadialNeedleShape.line,
                                    topOffest: -15,
                                    bottomOffset: 20,
                                    alignment: RadialElementAlignment.end)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
        ItemCard(
          title: 'Clock Show Case',
          child: ValueListenableBuilder<DateTime>(
              valueListenable: dateTimeNotifier,
              builder: (_, DateTime now, __) {
                final int hours = getHoursIn12HrsFormat(now.hour);
                final int minutes = now.minute;
                final int seconds = now.second;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          // boxShadow: [
                          //   BoxShadow(
                          //       offset: Offset(10, 20),
                          //       blurRadius: 30,
                          //       color: Colors.blueGrey38,
                          //       spreadRadius: 10)
                          // ],
                        ),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Positioned(
                              left: size.width / 3.5,
                              top: size.height / 7.5,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.orange,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: GxRadialGauge(
                                    showValueAtCenter: false,
                                    startAngleInDegree: 270,
                                    size: const Size(60, 60),
                                    value: GaugeValue(
                                        value: seconds.toDouble(),
                                        min: 0,
                                        max: 60),
                                    showLabels: true,
                                    labelTickStyle: const RadialTickLabelStyle(
                                      padding: 6,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    interval: 5,
                                    style: const RadialGaugeStyle(
                                        strokeCap: StrokeCap.butt,
                                        paintingStyle: PaintingStyle.fill,
                                        color: Colors.brown,
                                        backgroundColor: Colors.brown,
                                        thickness: 2),
                                    showMajorTicks: true,
                                    showMinorTicks: false,
                                    majorTickStyle: const RadialTickStyle(
                                        color: Colors.white,
                                        thickness: 2,
                                        length: 2,
                                        alignment: RadialElementAlignment.end,
                                        position: RadialElementPosition.inside),
                                    valueToLabelFormatCallback: (value, index) {
                                      if (index == 3 ||
                                          index == 6 ||
                                          index == 9 ||
                                          index == 12) {
                                        return (value / 5).toInt().toString();
                                      }
                                      return '';
                                    },
                                    pointers: [
                                      RadialPointer(
                                          value: getHourRatio(hours, minutes),
                                          showPointer: false,
                                          style: const RadialPointerStyle(
                                              color: Colors.white,
                                              paintingStyle: PaintingStyle.fill,
                                              size: 12,
                                              thickness: 2),
                                          needle: const RadialNeedle(
                                              thickness: 5,
                                              topOffest: -4,
                                              color: Colors.white,
                                              shape: RadialNeedleShape
                                                  .tapperedLine,
                                              alignment:
                                                  RadialElementAlignment.end)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GxRadialGauge(
                              showValueAtCenter: false,
                              startAngleInDegree: 270,
                              size: Size(size.width, 250),
                              value: GaugeValue(
                                  value: seconds.toDouble(), min: 0, max: 60),
                              showLabels: true,
                              labelTickStyle: const RadialTickLabelStyle(
                                padding: 20,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                              interval: 5,
                              minorTicksPerInterval: 4,
                              style: const RadialGaugeStyle(
                                  strokeCap: StrokeCap.butt,
                                  paintingStyle: PaintingStyle.stroke,
                                  color: Colors.blueGrey,
                                  backgroundColor: Colors.blueGrey,
                                  thickness: 5),
                              showMajorTicks: true,
                              showMinorTicks: true,
                              majorTickStyle: const RadialTickStyle(
                                  color: Colors.blueGrey,
                                  thickness: 2,
                                  length: 12,
                                  alignment: RadialElementAlignment.end,
                                  position: RadialElementPosition.inside),
                              minorTickStyle: RadialTickStyle(
                                  color: Colors.grey.shade300,
                                  alignment: RadialElementAlignment.end,
                                  position: RadialElementPosition.inside,
                                  length: 10),
                              valueToLabelFormatCallback: (value, index) {
                                if (index == 0) {
                                  return '';
                                }
                                return (value / 5).toInt().toString();
                              },
                              pointers: [
                                // RadialPointer(
                                //   value: seconds.toDouble(),
                                //   shape: RadialPointerShape.triangle,
                                //   alignment: RadialElementAlignment.start,
                                //   showNeedle: false,
                                //   style: const RadialPointerStyle(
                                //       color: Colors.blueGrey,
                                //       paintingStyle: PaintingStyle.fill,
                                //       size: 20,
                                //       thickness: 2),
                                // ),
                                RadialPointer(
                                    value: getHourRatio(hours, minutes),
                                    showPointer: false,
                                    style: const RadialPointerStyle(
                                        color: Colors.blueGrey,
                                        paintingStyle: PaintingStyle.fill,
                                        size: 12,
                                        thickness: 2),
                                    needle: const RadialNeedle(
                                        thickness: 3.5,
                                        topOffest: -40,
                                        color: Colors.blueGrey,
                                        shape: RadialNeedleShape.line,
                                        alignment: RadialElementAlignment.end)),
                                RadialPointer(
                                    value: minutes.toDouble(),
                                    showPointer: false,
                                    needle: const RadialNeedle(
                                        thickness: 2.5,
                                        color: Colors.blueGrey,
                                        shape: RadialNeedleShape.line,
                                        topOffest: -20,
                                        alignment: RadialElementAlignment.end)),
                                RadialPointer(
                                    value: seconds.toDouble(),
                                    showPointer: false,
                                    needle: const RadialNeedle(
                                        thickness: 2,
                                        color: Colors.blueGrey,
                                        shape: RadialNeedleShape.line,
                                        topOffest: -15,
                                        bottomOffset: 20,
                                        alignment: RadialElementAlignment.end)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }

  @override
  void dispose() {
    dateTimeNotifier.dispose();
    super.dispose();
  }

// Get Hour ratio wrt to minutes
  double getHourRatio(int hours, int minutes) {
    final double minToHour = minutes / 60;
    final double hoursRatio = (hours + minToHour);
    final hourValue = hoursRatio * 5;

    print(
        'DefaultRadialShowCase: Hours Value: $hourValue Hour Ratio: $hoursRatio, Hours: $hours, Minutes: $minutes');
    return hourValue;
  }

  // Convert 24 hrs format to 12 hrs format
  int getHoursIn12HrsFormat(int hours) {
    if (hours > 12) {
      return hours - 12;
    }
    return hours;
  }

  // Handle Time Notifier
  void handleTimeNotifier() {
    Future.delayed(const Duration(seconds: 1), () {
      dateTime = DateTime.now();
      dateTimeNotifier.value = dateTime;
      handleTimeNotifier();
    });
  }

  @override
  void initState() {
    // get 12 hrs format
    dateTime = DateTime.now();
    handleTimeNotifier();

    super.initState();
  }
}
