// example/lib/main.dart

import 'dart:async';

import 'package:examples/screens/linear_gauge/bar/bar_linear_gauge_screen.dart';
import 'package:examples/screens/linear_gauge/progress/progress_linear_screen.dart';
import 'package:examples/screens/linear_gauge/scale/scale_linear_gauge_screen.dart';
import 'package:examples/screens/linear_gauge/stepper/stepper_linear_gauge.dart';
import 'package:examples/screens/radial/radial_gauge_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class FeatureItem {
  final String title;
  final String? description;
  final Widget Function() widget;
  final Widget? leading;
  final String code;
  final String? imagePath;

  FeatureItem({
    required this.title,
    this.description,
    required this.widget,
    this.leading,
    required this.code,
    this.imagePath,
  });
}

class _ExampleAppState extends State<ExampleApp> {
  bool reRender = true;

  late final ScrollController _scrollController;

  final List<dynamic> _items = [
    "Linear Gauge",
    FeatureItem(
      title: 'Progress Linear Gauge',
      description:
          'The Progress Linear Gauge is used to display a linear gauge with progress.',
      widget: () => const MyProgressLinearGauge(),
      code: 'MyProgressLinearGauge()',
      leading: const Icon(Icons.linear_scale_rounded),
      imagePath: 'assets/images/features/linear_progress_gauge.jpeg',
    ),
    FeatureItem(
      title: 'Scale Linear Gauge',
      description:
          'The Scale Linear Gauge is used to display a linear gauge with scale.',
      widget: () => const MyScaleLinearGaugeScreen(),
      code: 'MyScaleLinearGaugeScreen()',
      leading: const Icon(Icons.linear_scale),
      imagePath: 'assets/images/features/linear_scale_gauge.jpeg',
    ),
    FeatureItem(
        title: 'Bar Linear Gauge',
        description:
            'The Bar Linear Gauge is used to display a linear gauge with bars.',
        widget: () => const MyBarLinearGaugeScreen(),
        code: 'MyBarLinearGaugeScreen()',
        leading: const Icon(Icons.bar_chart_sharp),
        imagePath: 'assets/images/features/linear_bar_gauge.jpeg'),
    FeatureItem(
        title: 'Stepper Linear Gauge',
        description:
            'The Stepper Linear Gauge is used to display a linear gauge with steps.',
        widget: () => const StepperLinearScreen(),
        code: 'StepperLinearScreen()',
        leading: const Icon(Icons.bar_chart_sharp),
        imagePath: 'assets/images/features/linear_stepper_gauge.png'),
    "Radial Gauge",
    FeatureItem(
      title: 'Radial Gauge',
      description: 'The Radial Gauge is used to display a radial gauge.',
      widget: () => const RadialGuageScreen(),
      code: 'RadialGuageScreen()',
      imagePath: 'assets/images/features/radial_gauge.png',
      leading: const Icon(
        Icons.pie_chart_rounded,
        size: 70,
        color: Colors.blue,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GirixCode: Gauges Example',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('GirixCode: Gauges Example'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  refreshPage();
                },
              )
            ],
          ),
          body: reRender
              ? ListView.builder(
                  controller: _scrollController,
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    if (_items[index] is String) {
                      return Container(
                        color: Colors.grey.shade200,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          _items[index],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      );
                    }
                    final FeatureItem item = _items[index];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(item.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: item.description != null
                            ? Text(item.description!)
                            : null,
                        leading: item.imagePath != null
                            ? Image.asset(
                                item.imagePath!,
                                width: 80,
                                height: 110,
                                fit: BoxFit.cover,
                              )
                            : item.leading,
                        minLeadingWidth: 10,
                        // contentPadding: EdgeInsets.zero,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => item.widget(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('Click on the refresh icon to reload the page'),
                )),
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
  }

  void refreshPage() {
    setState(() {
      reRender = !reRender;
    });

    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        reRender = !reRender;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
      });
    });
  }

  // Scroll to the last item in the list
  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
}
