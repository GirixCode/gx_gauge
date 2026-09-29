import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/widgets/item_card.dart';

class MyBarLinearGaugeScreen extends StatefulWidget {
  const MyBarLinearGaugeScreen({super.key});

  @override
  State<MyBarLinearGaugeScreen> createState() => _MyBarLinearGaugeScreenState();
}

class _MyBarLinearGaugeScreenState extends State<MyBarLinearGaugeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bar Linear Gauge')),
      body: ListView(
        children: [
          ItemCard(
            title: 'Default Linear Bar Gauge',
            child: GxLinearBarGauge(
              height: 40,
              value: const GxGaugeValue(value: 60, max: 99),
              bars: [
                GxLinearBarPointer(start: 0, end: 33, color: Colors.teal),
                GxLinearBarPointer(color: Colors.lightBlue, start: 33, end: 66),
                GxLinearBarPointer(
                  color: Colors.cyanAccent,
                  start: 66,
                  end: 99,
                ),
              ],
            ),
          ),

          ItemCard(
            title: 'With Labels',
            child: GxLinearBarGauge(
              height: 40,
              value: const GxGaugeValue(value: 60, min: 0, max: 120),
              bars: [
                GxLinearBarPointer(
                  label: const GxGaugeLabel(label: 'Low'),
                  start: 0,
                  end: 33,
                  color: Colors.deepOrangeAccent,
                ),
                GxLinearBarPointer(
                  label: const GxGaugeLabel(label: 'Medium'),
                  color: Colors.yellow.shade800,
                  start: 33,
                  end: 87,
                ),
                GxLinearBarPointer(
                  label: const GxGaugeLabel(label: 'High'),
                  color: Colors.greenAccent.shade700,
                  start: 87,
                  end: 120,
                ),
              ],
            ),
          ),

          ItemCard(
            title: "With Gap Between Bars",
            child: GxLinearBarGauge(
              height: 40,
              value: const GxGaugeValue(value: 60, min: 0, max: 100),
              gapBetweenBars: 6,
              bars: [
                GxLinearBarPointer(
                  start: 0,
                  end: 25,
                  color: Colors.blueGrey.shade100,
                ),
                GxLinearBarPointer(
                  color: Colors.blueGrey.shade200,
                  start: 25,
                  end: 50,
                ),
                GxLinearBarPointer(
                  color: Colors.blueGrey.shade300,
                  start: 50,
                  end: 75,
                ),
                GxLinearBarPointer(color: Colors.blueGrey, start: 75, end: 100),
              ],
            ),
          ),

          const SizedBox(height: 10),
          // Customized Bar Gauge Style with Gap
          ItemCard(
            title: "Customized Bar Gauge Style with Gap",
            child: GxLinearBarGauge(
              height: 40,
              value: const GxGaugeValue(value: 30, min: 0, max: 100),
              gapBetweenBars: 10,
              bars: [
                GxLinearBarPointer(
                  start: 0,
                  end: 30,
                  label: const GxGaugeLabel(label: '30'),
                  color: Colors.orange,
                  radius: const Radius.circular(2),
                ),
                GxLinearBarPointer(
                  borderColor: Colors.orange,
                  color: Colors.transparent,
                  start: 30,
                  end: 70,
                  borderWidth: 2,
                  label: const GxGaugeLabel(
                    label: '40',
                    style: TextStyle(color: Colors.black),
                  ),
                  radius: const Radius.circular(2),
                ),
                GxLinearBarPointer(
                  color: Colors.orange,
                  start: 70,
                  end: 100,
                  label: const GxGaugeLabel(label: '30'),
                  radius: const Radius.circular(2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ItemCard(
            title: "With a needle, \ntooltip and inside bar",
            child: GxLinearBarGauge(
              height: 25,
              value: const GxGaugeValue(value: 70, min: 0, max: 100),
              gapBetweenBars: 5,
              tooltip: const GxGaugeTooltip(
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
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                borderColor: Colors.green,
              ),
              needle: const GxLinearNeedle(
                enabled: true,
                color: Colors.green,
                size: Size(1.5, 75),
                position: GxNeedlePosition.bottom,
                shape: GxNeedleShape.pipe,
              ),
              bars: [
                GxLinearBarPointer(
                  // strokeCap: StrokeCap.square,
                  // paintingStyle: PaintingStyle.stroke,
                  radius: const Radius.circular(5),
                  start: 0,
                  end: 75,
                  color: Colors.blueGrey.shade300,
                ),
                GxLinearBarPointer(
                  radius: const Radius.circular(5),
                  color: Colors.blueGrey,
                  start: 75,
                  end: 100,
                ),
                // GxLinearBarPointer(
                //     color: Colors.blueGrey.shade600, start: 100, end: 150),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ItemCard(
            title: 'With TextAlign and Offset of Labels',
            child: GxLinearBarGauge(
              height: 40,
              value: const GxGaugeValue(value: 60, min: 0, max: 120),
              gapBetweenBars: 5,
              bars: [
                GxLinearBarPointer(
                  label: const GxGaugeLabel(
                    style: TextStyle(color: Colors.black87),
                    label: 'TextAlign label',
                    textAlign: TextAlign.center,
                  ),
                  start: 0,
                  end: 40,
                  borderWidth: 2,
                  borderColor: Colors.black45,
                  color: Colors.transparent,
                ),
                GxLinearBarPointer(
                  label: const GxGaugeLabel(
                    offset: Offset(0, 0),
                    style: TextStyle(color: Colors.black87),
                    label: 'Offset label',
                    textAlign: TextAlign.center,
                  ),
                  borderColor: Colors.black45,
                  color: Colors.transparent,
                  start: 40,
                  end: 80,
                  borderWidth: 2,
                ),
                GxLinearBarPointer(
                  label: const GxGaugeLabel(
                    label: 'Default label',
                    style: TextStyle(color: Colors.black87),
                  ),
                  borderColor: Colors.black45,
                  color: Colors.transparent,
                  start: 80,
                  end: 120,
                  borderWidth: 2,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          // Tooltip
          ItemCard(
            title: 'With Tooltip',
            height: 120,
            child: GxLinearBarGauge(
              height: 40,
              value: const GxGaugeValue(value: 95, min: 0, max: 100),
              // gapBetweenBars: 5,
              tooltip: const GxGaugeTooltip(
                enabled: true,
                color: Colors.black12,
                borderColor: Colors.redAccent,
                radius: Radius.circular(5),
                offset: 20,
                type: GxTooltipType.normal,
                position: GxTooltipPosition.top,
                paintingStyle: PaintingStyle.stroke,
                thickness: 1.0,
                size: Size(40, 20),
                textStyle: TextStyle(),
              ),
              bars: [
                GxLinearBarPointer(
                  label: const GxGaugeLabel(
                    style: TextStyle(color: Colors.black87),
                    label: 'Documents',
                  ),
                  start: 0,
                  end: 33,
                  borderWidth: 2,
                  borderColor: Colors.black45,
                  color: Colors.transparent,
                ),
                GxLinearBarPointer(
                  label: const GxGaugeLabel(
                    style: TextStyle(color: Colors.black87),
                    label: 'Developers',
                    textAlign: TextAlign.center,
                  ),
                  borderColor: Colors.black45,
                  color: Colors.transparent,
                  start: 33,
                  end: 67,
                  borderWidth: 2,
                ),
                GxLinearBarPointer(
                  label: const GxGaugeLabel(
                    label: 'System',
                    style: TextStyle(color: Colors.black87),
                  ),
                  borderColor: Colors.black45,
                  color: Colors.transparent,
                  start: 67,
                  end: 100,
                  borderWidth: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ItemCard(
            title: "With a custom painter needle",
            child: GxLinearBarGauge(
              height: 25,
              value: const GxGaugeValue(value: 70, min: 0, max: 100),
              gapBetweenBars: 5,
              needle: const GxLinearNeedle(
                enabled: true,
                color: Colors.orange,
                size: Size(30.5, 75),
                position: GxNeedlePosition.top,
                shape: GxNeedleShape.custom,
              ),
              needlePainter: _drawCustomNeedle,
              bars: [
                GxLinearBarPointer(
                  // strokeCap: StrokeCap.square,
                  // paintingStyle: PaintingStyle.stroke,
                  radius: const Radius.circular(5),
                  start: 0,
                  end: 75,
                  color: Colors.blueGrey.shade300,
                ),
                GxLinearBarPointer(
                  radius: const Radius.circular(5),
                  color: Colors.blueGrey,
                  start: 75,
                  end: 100,
                ),
                // GxLinearBarPointer(
                //     color: Colors.blueGrey.shade600, start: 100, end: 150),
              ],
            ),
          ),
          const SizedBox(height: 10),

          const SizedBox(height: 100),
        ],
      ),
    );

    // Custom Needle Painter
  }

  void _drawCustomNeedle(
    Canvas canvas,
    Offset position,
    GxLinearNeedle needle,
  ) {
    final Paint paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    final Path path = Path()
      ..moveTo(position.dx, position.dy)
      ..lineTo(position.dx + 15, position.dy + 15)
      ..lineTo(position.dx - 15, position.dy + 15)
      ..close();

    canvas.drawPath(path, paint);
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
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
