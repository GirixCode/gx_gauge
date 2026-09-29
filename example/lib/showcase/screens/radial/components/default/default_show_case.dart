import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/item_card.dart';

class DefaultRadialShowCase extends StatefulWidget {
  final double value;

  const DefaultRadialShowCase({super.key, required this.value});

  @override
  State<DefaultRadialShowCase> createState() => _DefaultRadialShowCaseState();
}

class _DefaultRadialShowCaseState extends State<DefaultRadialShowCase> {
  late DateTime dateTime;
  final ValueNotifier<DateTime> dateTimeNotifier = ValueNotifier<DateTime>(
    DateTime.now(),
  );

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
            builder: (_, DateTime now, _) {
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
                      diameter: twinSize.width,
                      value: GxGaugeValue(
                        value: seconds.toDouble(),
                        min: 0,
                        max: 60,
                      ),
                      showLabels: true,
                      labelTickStyle: const GxRadialTickLabelStyle(
                        padding: 20,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      interval: 5,
                      minorTicksPerInterval: 4,
                      style: const GxRadialGaugeStyle(
                        strokeCap: StrokeCap.butt,
                        color: Colors.brown,
                        thickness: 20,
                      ),
                      showMajorTicks: true,
                      showMinorTicks: true,
                      majorTickStyle: const GxRadialTickStyle(
                        color: Colors.brown,
                        thickness: 2,
                        length: 14,
                        alignment: GxRadialElementAlignment.end,
                        position: GxRadialElementPosition.inside,
                      ),
                      minorTickStyle: GxRadialTickStyle(
                        color: Colors.brown.shade100,
                        alignment: GxRadialElementAlignment.end,
                        position: GxRadialElementPosition.inside,
                        length: 18,
                      ),
                      labelFormatter: (value, index) {
                        if (index == 0) {
                          return '';
                        }
                        return (value / 5).toInt().toString();
                      },
                      pointers: [
                        GxRadialPointer(
                          value: seconds.toDouble(),
                          shape: GxRadialPointerShape.triangle,
                          alignment: GxRadialElementAlignment.start,
                          showNeedle: false,
                          style: const GxRadialPointerStyle(
                            color: Colors.brown,
                            paintingStyle: PaintingStyle.fill,
                            size: 20,
                            thickness: 2,
                          ),
                        ),
                        GxRadialPointer(
                          value: getHourRatio(hours, minutes),
                          showPointer: false,
                          style: const GxRadialPointerStyle(
                            color: Colors.brown,
                            paintingStyle: PaintingStyle.fill,
                            size: 12,
                            thickness: 2,
                          ),
                          needle: const GxRadialNeedle(
                            thickness: 3.5,
                            topOffset: -40,
                            color: Colors.brown,
                            shape: GxRadialNeedleShape.line,
                            alignment: GxRadialElementAlignment.end,
                          ),
                        ),
                        GxRadialPointer(
                          value: minutes.toDouble(),
                          showPointer: false,
                          needle: const GxRadialNeedle(
                            thickness: 2.5,
                            color: Colors.brown,
                            shape: GxRadialNeedleShape.line,
                            topOffset: -20,
                            alignment: GxRadialElementAlignment.end,
                          ),
                        ),
                        GxRadialPointer(
                          value: seconds.toDouble(),
                          showPointer: false,
                          needle: const GxRadialNeedle(
                            thickness: 2,
                            color: Colors.brown,
                            shape: GxRadialNeedleShape.line,
                            topOffset: -15,
                            bottomOffset: 20,
                            alignment: GxRadialElementAlignment.end,
                          ),
                        ),
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
                        diameter: twinSize.width,
                        value: GxGaugeValue(
                          value: seconds.toDouble(),
                          min: 0,
                          max: 60,
                        ),
                        showLabels: true,
                        labelTickStyle: const GxRadialTickLabelStyle(
                          padding: 20,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        interval: 5,
                        minorTicksPerInterval: 4,
                        style: const GxRadialGaugeStyle(
                          strokeCap: StrokeCap.butt,
                          paintingStyle: PaintingStyle.fill,
                          color: Colors.blueGrey,
                          backgroundColor: Colors.blueGrey,
                          thickness: 20,
                        ),
                        showMajorTicks: true,
                        showMinorTicks: true,
                        majorTickStyle: const GxRadialTickStyle(
                          color: Colors.white,
                          thickness: 2,
                          length: 12,
                          alignment: GxRadialElementAlignment.end,
                          position: GxRadialElementPosition.inside,
                        ),
                        minorTickStyle: GxRadialTickStyle(
                          color: Colors.grey.shade300,
                          alignment: GxRadialElementAlignment.end,
                          position: GxRadialElementPosition.inside,
                          length: 10,
                        ),
                        labelFormatter: (value, index) {
                          if (index == 0) {
                            return '';
                          }
                          return (value / 5).toInt().toString();
                        },
                        pointers: [
                          // GxRadialPointer(
                          //   value: seconds.toDouble(),
                          //   shape: GxRadialPointerShape.triangle,
                          //   alignment: GxRadialElementAlignment.start,
                          //   showNeedle: false,
                          //   style: const GxRadialPointerStyle(
                          //       color: Colors.blueGrey,
                          //       paintingStyle: PaintingStyle.fill,
                          //       size: 20,
                          //       thickness: 2),
                          // ),
                          GxRadialPointer(
                            value: getHourRatio(hours, minutes),
                            showPointer: false,
                            style: const GxRadialPointerStyle(
                              color: Colors.white,
                              paintingStyle: PaintingStyle.fill,
                              size: 12,
                              thickness: 2,
                            ),
                            needle: const GxRadialNeedle(
                              thickness: 3.5,
                              topOffset: -40,
                              color: Colors.white,
                              shape: GxRadialNeedleShape.line,
                              alignment: GxRadialElementAlignment.end,
                            ),
                          ),
                          GxRadialPointer(
                            value: minutes.toDouble(),
                            showPointer: false,
                            needle: const GxRadialNeedle(
                              thickness: 2.5,
                              color: Colors.white,
                              shape: GxRadialNeedleShape.line,
                              topOffset: -20,
                              alignment: GxRadialElementAlignment.end,
                            ),
                          ),
                          GxRadialPointer(
                            value: seconds.toDouble(),
                            showPointer: false,
                            needle: const GxRadialNeedle(
                              thickness: 2,
                              color: Colors.white,
                              shape: GxRadialNeedleShape.line,
                              topOffset: -15,
                              bottomOffset: 20,
                              alignment: GxRadialElementAlignment.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        ItemCard(
          title: 'Clock Show Case',
          child: ValueListenableBuilder<DateTime>(
            valueListenable: dateTimeNotifier,
            builder: (_, DateTime now, _) {
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
                                  diameter: 60,
                                  value: GxGaugeValue(
                                    value: seconds.toDouble(),
                                    min: 0,
                                    max: 60,
                                  ),
                                  showLabels: true,
                                  labelTickStyle: const GxRadialTickLabelStyle(
                                    padding: 6,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  interval: 5,
                                  style: const GxRadialGaugeStyle(
                                    strokeCap: StrokeCap.butt,
                                    paintingStyle: PaintingStyle.fill,
                                    color: Colors.brown,
                                    backgroundColor: Colors.brown,
                                    thickness: 2,
                                  ),
                                  showMajorTicks: true,
                                  showMinorTicks: false,
                                  majorTickStyle: const GxRadialTickStyle(
                                    color: Colors.white,
                                    thickness: 2,
                                    length: 2,
                                    alignment: GxRadialElementAlignment.end,
                                    position: GxRadialElementPosition.inside,
                                  ),
                                  labelFormatter: (value, index) {
                                    if (index == 3 ||
                                        index == 6 ||
                                        index == 9 ||
                                        index == 12) {
                                      return (value / 5).toInt().toString();
                                    }
                                    return '';
                                  },
                                  pointers: [
                                    GxRadialPointer(
                                      value: getHourRatio(hours, minutes),
                                      showPointer: false,
                                      style: const GxRadialPointerStyle(
                                        color: Colors.white,
                                        paintingStyle: PaintingStyle.fill,
                                        size: 12,
                                        thickness: 2,
                                      ),
                                      needle: const GxRadialNeedle(
                                        thickness: 5,
                                        topOffset: -4,
                                        color: Colors.white,
                                        shape: GxRadialNeedleShape.taperedLine,
                                        alignment: GxRadialElementAlignment.end,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GxRadialGauge(
                            showValueAtCenter: false,
                            startAngleInDegree: 270,
                            diameter: 250,
                            value: GxGaugeValue(
                              value: seconds.toDouble(),
                              min: 0,
                              max: 60,
                            ),
                            showLabels: true,
                            labelTickStyle: const GxRadialTickLabelStyle(
                              padding: 20,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            interval: 5,
                            minorTicksPerInterval: 4,
                            style: const GxRadialGaugeStyle(
                              strokeCap: StrokeCap.butt,
                              paintingStyle: PaintingStyle.stroke,
                              color: Colors.blueGrey,
                              backgroundColor: Colors.blueGrey,
                              thickness: 5,
                            ),
                            showMajorTicks: true,
                            showMinorTicks: true,
                            majorTickStyle: const GxRadialTickStyle(
                              color: Colors.blueGrey,
                              thickness: 2,
                              length: 12,
                              alignment: GxRadialElementAlignment.end,
                              position: GxRadialElementPosition.inside,
                            ),
                            minorTickStyle: GxRadialTickStyle(
                              color: Colors.grey.shade300,
                              alignment: GxRadialElementAlignment.end,
                              position: GxRadialElementPosition.inside,
                              length: 10,
                            ),
                            labelFormatter: (value, index) {
                              if (index == 0) {
                                return '';
                              }
                              return (value / 5).toInt().toString();
                            },
                            pointers: [
                              // GxRadialPointer(
                              //   value: seconds.toDouble(),
                              //   shape: GxRadialPointerShape.triangle,
                              //   alignment: GxRadialElementAlignment.start,
                              //   showNeedle: false,
                              //   style: const GxRadialPointerStyle(
                              //       color: Colors.blueGrey,
                              //       paintingStyle: PaintingStyle.fill,
                              //       size: 20,
                              //       thickness: 2),
                              // ),
                              GxRadialPointer(
                                value: getHourRatio(hours, minutes),
                                showPointer: false,
                                style: const GxRadialPointerStyle(
                                  color: Colors.blueGrey,
                                  paintingStyle: PaintingStyle.fill,
                                  size: 12,
                                  thickness: 2,
                                ),
                                needle: const GxRadialNeedle(
                                  thickness: 3.5,
                                  topOffset: -40,
                                  color: Colors.blueGrey,
                                  shape: GxRadialNeedleShape.line,
                                  alignment: GxRadialElementAlignment.end,
                                ),
                              ),
                              GxRadialPointer(
                                value: minutes.toDouble(),
                                showPointer: false,
                                needle: const GxRadialNeedle(
                                  thickness: 2.5,
                                  color: Colors.blueGrey,
                                  shape: GxRadialNeedleShape.line,
                                  topOffset: -20,
                                  alignment: GxRadialElementAlignment.end,
                                ),
                              ),
                              GxRadialPointer(
                                value: seconds.toDouble(),
                                showPointer: false,
                                needle: const GxRadialNeedle(
                                  thickness: 2,
                                  color: Colors.blueGrey,
                                  shape: GxRadialNeedleShape.line,
                                  topOffset: -15,
                                  bottomOffset: 20,
                                  alignment: GxRadialElementAlignment.end,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
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
