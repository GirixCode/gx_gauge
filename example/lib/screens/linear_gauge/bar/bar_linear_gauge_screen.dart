import 'package:examples/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class MyBarLinearGaugeScreen extends StatefulWidget {
  const MyBarLinearGaugeScreen({super.key});

  @override
  State<MyBarLinearGaugeScreen> createState() => _MyBarLinearGaugeScreenState();
}

class _MyBarLinearGaugeScreenState extends State<MyBarLinearGaugeScreen> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bar Linear Gauge'),
      ),
      body: ListView(
        children: [
          ItemCard(
              title: 'Default Linear Bar Gauge',
              child: GxLinearBarGauge(
                size: Size(width, 40),
                value: const GaugeValue(value: 60, max: 99),
                barPointers: [
                  LinearBarPointer(value: 33, thickness: 5, color: Colors.teal),
                  LinearBarPointer(
                      color: Colors.lightBlue, value: 33, thickness: 5),
                  LinearBarPointer(
                      color: Colors.cyanAccent, value: 33, thickness: 5),
                ],
              )),

          ItemCard(
              title: 'With Labels',
              child: GxLinearBarGauge(
                size: Size(width, 40),
                value: const GaugeValue(
                  value: 60,
                  min: 0,
                  max: 120,
                ),
                barPointers: [
                  LinearBarPointer(
                      label: const GaugeLabel(
                        label: 'Low',
                      ),
                      value: 33,
                      thickness: 5,
                      color: Colors.deepOrangeAccent),
                  LinearBarPointer(
                      label: const GaugeLabel(
                        label: 'Medium',
                      ),
                      color: Colors.yellow.shade800,
                      value: 54,
                      thickness: 5),
                  LinearBarPointer(
                      label: const GaugeLabel(
                        label: 'High',
                      ),
                      color: Colors.greenAccent.shade700,
                      value: 33,
                      thickness: 5),
                ],
              )),

          ItemCard(
              title: "With Gap Between Bars",
              child: GxLinearBarGauge(
                size: const Size(410, 40),
                value: const GaugeValue(
                  value: 60,
                  min: 0,
                  max: 100,
                ),
                gapBetweenBars: 6,
                barPointers: [
                  LinearBarPointer(
                      value: 25, thickness: 5, color: Colors.blueGrey.shade100),
                  LinearBarPointer(
                      color: Colors.blueGrey.shade200, value: 25, thickness: 5),
                  LinearBarPointer(
                      color: Colors.blueGrey.shade300, value: 25, thickness: 5),
                  LinearBarPointer(
                      color: Colors.blueGrey, value: 25, thickness: 5),
                ],
              )),

          const SizedBox(height: 10),
          // Customized Bar Gauge Style with Gap
          ItemCard(
              title: "Customized Bar Gauge Style with Gap",
              child: GxLinearBarGauge(
                size: const Size.fromHeight(40),
                value: const GaugeValue(
                  value: 30,
                  min: 0,
                  max: 100,
                ),
                gapBetweenBars: 10,
                barPointers: [
                  LinearBarPointer(
                      value: 30,
                      label: const GaugeLabel(label: '30'),
                      thickness: 2,
                      color: Colors.orange,
                      strokeCap: StrokeCap.round,
                      paintingStyle: PaintingStyle.fill,
                      radius: const Radius.circular(2)),
                  LinearBarPointer(
                      color: Colors.orange,
                      value: 40,
                      thickness: 2,
                      label: const GaugeLabel(
                          label: '40', style: TextStyle(color: Colors.black)),
                      strokeCap: StrokeCap.round,
                      paintingStyle: PaintingStyle.stroke,
                      radius: const Radius.circular(2)),
                  LinearBarPointer(
                      color: Colors.orange,
                      value: 30,
                      label: const GaugeLabel(
                        label: '30',
                      ),
                      thickness: 2,
                      strokeCap: StrokeCap.round,
                      paintingStyle: PaintingStyle.fill,
                      radius: const Radius.circular(2)),
                ],
              )),
          const SizedBox(height: 10),
          ItemCard(
              title: "With a needle, \ntooltip and inside bar",
              child: GxLinearBarGauge(
                size: const Size(410, 25),
                value: const GaugeValue(
                  value: 70,
                  min: 0,
                  max: 100,
                ),
                gapBetweenBars: 5,
                showNeedleInsideBar: true,
                tooltip: const GaugeTooltip(
                    label: 'REC {value}',
                    offset: 20,
                    showPointer: false,
                    thickness: 2,
                    color: Colors.green,
                    strokeCap: StrokeCap.round,
                    radius: Radius.circular(5),
                    paintingStyle: PaintingStyle.stroke,
                    size: Size(100, 30),
                    textStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    borderColor: Colors.green),
                needle: const LinearNeedle(
                    enabled: true,
                    color: Colors.green,
                    size: Size(1.5, 75),
                    position: LinearGaugeNeedlePosition.bottom,
                    needleType: LinearGaugeNeedleType.pipe),
                barPointers: [
                  LinearBarPointer(
                      // strokeCap: StrokeCap.square,
                      // paintingStyle: PaintingStyle.stroke,
                      radius: const Radius.circular(5),
                      value: 75,
                      thickness: 5,
                      color: Colors.blueGrey.shade300),
                  LinearBarPointer(
                      radius: const Radius.circular(5),
                      color: Colors.blueGrey,
                      value: 25,
                      thickness: 5),
                  // LinearBarPointer(
                  //     color: Colors.blueGrey.shade600, value: 50, thickness: 5),
                ],
              )),
          const SizedBox(height: 10),
          ItemCard(
              title: 'With TextAlign and Offset of Labels',
              child: GxLinearBarGauge(
                size: Size(width, 40),
                value: const GaugeValue(
                  value: 60,
                  min: 0,
                  max: 120,
                ),
                gapBetweenBars: 5,
                barPointers: [
                  LinearBarPointer(
                      label: const GaugeLabel(
                          style: TextStyle(color: Colors.black87),
                          label: 'TextAlign label',
                          textAlign: TextAlign.center),
                      value: 40,
                      thickness: 2,
                      paintingStyle: PaintingStyle.stroke,
                      color: Colors.black45),
                  LinearBarPointer(
                      paintingStyle: PaintingStyle.stroke,
                      label: const GaugeLabel(
                          offset: Offset(0, 0),
                          style: TextStyle(color: Colors.black87),
                          label: 'Offset label',
                          textAlign: TextAlign.center),
                      color: Colors.black45,
                      value: 40,
                      thickness: 2),
                  LinearBarPointer(
                      paintingStyle: PaintingStyle.stroke,
                      label: const GaugeLabel(
                        label: 'Default label',
                        style: TextStyle(color: Colors.black87),
                      ),
                      color: Colors.black45,
                      value: 40,
                      thickness: 2),
                ],
              )),

          const SizedBox(height: 10),
          // Tooltip
          ItemCard(
              title: 'With Tooltip',
              height: 120,
              child: GxLinearBarGauge(
                size: Size(width, 40),
                value: const GaugeValue(
                  value: 95,
                  min: 0,
                  max: 100,
                ),
                // gapBetweenBars: 5,
                tooltip: const GaugeTooltip(
                  enabled: true,
                  color: Colors.black12,
                  borderColor: Colors.redAccent,
                  radius: Radius.circular(5),
                  offset: 20,
                  type: GaugeTooltipType.normal,
                  position: GaugeTooltipPosition.top,
                  paintingStyle: PaintingStyle.stroke,
                  thickness: 1.0,
                  size: Size(40, 20),
                  textStyle: TextStyle(),
                ),
                barPointers: [
                  LinearBarPointer(
                      label: const GaugeLabel(
                        style: TextStyle(color: Colors.black87),
                        label: 'Documents',
                      ),
                      value: 33,
                      thickness: 2,
                      paintingStyle: PaintingStyle.stroke,
                      color: Colors.black45),
                  LinearBarPointer(
                      paintingStyle: PaintingStyle.stroke,
                      label: const GaugeLabel(
                          style: TextStyle(color: Colors.black87),
                          label: 'Developers',
                          textAlign: TextAlign.center),
                      color: Colors.black45,
                      value: 34,
                      thickness: 2),
                  LinearBarPointer(
                      paintingStyle: PaintingStyle.stroke,
                      label: const GaugeLabel(
                        label: 'System',
                        style: TextStyle(color: Colors.black87),
                      ),
                      color: Colors.black45,
                      value: 33,
                      thickness: 2),
                ],
              )),
          const SizedBox(height: 10),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget buildCard(
    String title,
    Widget child, {
    double? height,
    bool visible = true,
  }) {
    if (!visible) {
      return const SizedBox();
    }
    return Card(
      elevation: 0.1,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
