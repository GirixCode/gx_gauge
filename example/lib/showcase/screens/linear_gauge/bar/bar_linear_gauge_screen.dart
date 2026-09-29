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
    final double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: const Text('Bar Linear Gauge')),
      body: ListView(
        children: [
          ItemCard(
            title: 'Default Linear Bar Gauge',
            child: GxLinearBarGauge(
              size: Size(width, 40),
              value: const GxGaugeValue(value: 60, max: 99),
              bars: [
                GxLinearBarPointer(value: 33, thickness: 5, color: Colors.teal),
                GxLinearBarPointer(
                  color: Colors.lightBlue,
                  value: 33,
                  thickness: 5,
                ),
                GxLinearBarPointer(
                  color: Colors.cyanAccent,
                  value: 33,
                  thickness: 5,
                ),
              ],
            ),
          ),

          ItemCard(
            title: 'With Labels',
            child: GxLinearBarGauge(
              size: Size(width, 40),
              value: const GxGaugeValue(value: 60, min: 0, max: 120),
              bars: [
                GxLinearBarPointer(
                  label: const GxGaugeLabel(label: 'Low'),
                  value: 33,
                  thickness: 5,
                  color: Colors.deepOrangeAccent,
                ),
                GxLinearBarPointer(
                  label: const GxGaugeLabel(label: 'Medium'),
                  color: Colors.yellow.shade800,
                  value: 54,
                  thickness: 5,
                ),
                GxLinearBarPointer(
                  label: const GxGaugeLabel(label: 'High'),
                  color: Colors.greenAccent.shade700,
                  value: 33,
                  thickness: 5,
                ),
              ],
            ),
          ),

          ItemCard(
            title: "With Gap Between Bars",
            child: GxLinearBarGauge(
              size: const Size(410, 40),
              value: const GxGaugeValue(value: 60, min: 0, max: 100),
              gapBetweenBars: 6,
              bars: [
                GxLinearBarPointer(
                  value: 25,
                  thickness: 5,
                  color: Colors.blueGrey.shade100,
                ),
                GxLinearBarPointer(
                  color: Colors.blueGrey.shade200,
                  value: 25,
                  thickness: 5,
                ),
                GxLinearBarPointer(
                  color: Colors.blueGrey.shade300,
                  value: 25,
                  thickness: 5,
                ),
                GxLinearBarPointer(
                  color: Colors.blueGrey,
                  value: 25,
                  thickness: 5,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          // Customized Bar Gauge Style with Gap
          ItemCard(
            title: "Customized Bar Gauge Style with Gap",
            child: GxLinearBarGauge(
              size: const Size.fromHeight(40),
              value: const GxGaugeValue(value: 30, min: 0, max: 100),
              gapBetweenBars: 10,
              bars: [
                GxLinearBarPointer(
                  value: 30,
                  label: const GxGaugeLabel(label: '30'),
                  thickness: 2,
                  color: Colors.orange,
                  strokeCap: StrokeCap.round,
                  paintingStyle: PaintingStyle.fill,
                  radius: const Radius.circular(2),
                ),
                GxLinearBarPointer(
                  color: Colors.orange,
                  value: 40,
                  thickness: 2,
                  label: const GxGaugeLabel(
                    label: '40',
                    style: TextStyle(color: Colors.black),
                  ),
                  strokeCap: StrokeCap.round,
                  paintingStyle: PaintingStyle.stroke,
                  radius: const Radius.circular(2),
                ),
                GxLinearBarPointer(
                  color: Colors.orange,
                  value: 30,
                  label: const GxGaugeLabel(label: '30'),
                  thickness: 2,
                  strokeCap: StrokeCap.round,
                  paintingStyle: PaintingStyle.fill,
                  radius: const Radius.circular(2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ItemCard(
            title: "With a needle, \ntooltip and inside bar",
            child: GxLinearBarGauge(
              size: const Size(410, 25),
              value: const GxGaugeValue(value: 70, min: 0, max: 100),
              gapBetweenBars: 5,
              showNeedleInsideBar: true,
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
                  value: 75,
                  thickness: 5,
                  color: Colors.blueGrey.shade300,
                ),
                GxLinearBarPointer(
                  radius: const Radius.circular(5),
                  color: Colors.blueGrey,
                  value: 25,
                  thickness: 5,
                ),
                // GxLinearBarPointer(
                //     color: Colors.blueGrey.shade600, value: 50, thickness: 5),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ItemCard(
            title: 'With TextAlign and Offset of Labels',
            child: GxLinearBarGauge(
              size: Size(width, 40),
              value: const GxGaugeValue(value: 60, min: 0, max: 120),
              gapBetweenBars: 5,
              bars: [
                GxLinearBarPointer(
                  label: const GxGaugeLabel(
                    style: TextStyle(color: Colors.black87),
                    label: 'TextAlign label',
                    textAlign: TextAlign.center,
                  ),
                  value: 40,
                  thickness: 2,
                  paintingStyle: PaintingStyle.stroke,
                  color: Colors.black45,
                ),
                GxLinearBarPointer(
                  paintingStyle: PaintingStyle.stroke,
                  label: const GxGaugeLabel(
                    offset: Offset(0, 0),
                    style: TextStyle(color: Colors.black87),
                    label: 'Offset label',
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.black45,
                  value: 40,
                  thickness: 2,
                ),
                GxLinearBarPointer(
                  paintingStyle: PaintingStyle.stroke,
                  label: const GxGaugeLabel(
                    label: 'Default label',
                    style: TextStyle(color: Colors.black87),
                  ),
                  color: Colors.black45,
                  value: 40,
                  thickness: 2,
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
              size: Size(width, 40),
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
                  value: 33,
                  thickness: 2,
                  paintingStyle: PaintingStyle.stroke,
                  color: Colors.black45,
                ),
                GxLinearBarPointer(
                  paintingStyle: PaintingStyle.stroke,
                  label: const GxGaugeLabel(
                    style: TextStyle(color: Colors.black87),
                    label: 'Developers',
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.black45,
                  value: 34,
                  thickness: 2,
                ),
                GxLinearBarPointer(
                  paintingStyle: PaintingStyle.stroke,
                  label: const GxGaugeLabel(
                    label: 'System',
                    style: TextStyle(color: Colors.black87),
                  ),
                  color: Colors.black45,
                  value: 33,
                  thickness: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ItemCard(
            title: "With a custom painter needle",
            child: GxLinearBarGauge(
              size: const Size(410, 25),
              value: const GxGaugeValue(value: 70, min: 0, max: 100),
              gapBetweenBars: 5,
              showNeedleInsideBar: true,
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
                  value: 75,
                  thickness: 5,
                  color: Colors.blueGrey.shade300,
                ),
                GxLinearBarPointer(
                  radius: const Radius.circular(5),
                  color: Colors.blueGrey,
                  value: 25,
                  thickness: 5,
                ),
                // GxLinearBarPointer(
                //     color: Colors.blueGrey.shade600, value: 50, thickness: 5),
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
