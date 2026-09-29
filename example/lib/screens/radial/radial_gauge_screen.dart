import 'package:examples/screens/radial/components/default/default_show_case.dart';
import 'package:examples/screens/radial/components/default_radial_body.dart';
import 'package:examples/screens/radial/components/gradient/gradient_radial_gauge.dart';
import 'package:examples/screens/radial/components/ranges/range_bar_radial_gauge.dart';
import 'package:flutter/material.dart';

class RadialGuageScreen extends StatefulWidget {
  const RadialGuageScreen({super.key});

  @override
  State<RadialGuageScreen> createState() => _RadialGuageScreenState();
}

class _RadialGuageScreenState extends State<RadialGuageScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  double value = 41;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radial Gauge'),
        actions: [_buildSlider()],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          padding: EdgeInsets.zero,
          // labelPadding: EdgeInsets.zero,
          tabAlignment: TabAlignment.start,
          tabs: const <Widget>[
            Tab(
              text: 'Show Case',
              // child: Text('Default'),
            ),
            Tab(
              child: Text('Radial Gauge'),
            ),
            Tab(
              child: Text('Gradient'),
            ),
            Tab(
              child: Text('Range Bar'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        physics: const ClampingScrollPhysics(),
        controller: _tabController,
        children: <Widget>[
          DefaultRadialShowCase(
            value: value,
          ),
          DefaultRadialGaugeBody(
            value: value,
          ),
          GradientRadialGaugeBody(
            value: value,
          ),
          RangeBarRadialGaugeBody(value: value)
          // MultiRangeScaleLinearGaugeBody(),
        ],
      ),
    );
  }

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  // Slider
  Widget _buildSlider() {
    return Slider(
      value: value,
      min: 0,
      max: 100,
      divisions: 100,
      activeColor: Colors.grey.shade200,
      label: value.round().toString(),
      onChanged: (double newValue) {
        setState(() {
          value = newValue;
        });
      },
    );
  }
}
