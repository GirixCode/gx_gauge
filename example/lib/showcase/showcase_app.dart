import 'package:flutter/material.dart';
import 'package:gx_gauge/gx_gauge.dart';
import 'package:gx_gauge_example/showcase/screens/bar_screen.dart';
import 'package:gx_gauge_example/showcase/screens/playground_screen.dart';
import 'package:gx_gauge_example/showcase/screens/progress_screen.dart';
import 'package:gx_gauge_example/showcase/screens/radial_screen.dart';
import 'package:gx_gauge_example/showcase/screens/scale_screen.dart';
import 'package:gx_gauge_example/showcase/screens/stepper_screen.dart';
import 'package:gx_gauge_example/showcase/widgets/showcase_settings.dart';

/// The full gx_gauge showcase: one screen per gauge, each with tabs covering
/// every option, plus a playground.
class ShowcaseApp extends StatefulWidget {
  const ShowcaseApp({super.key});

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  final ShowcaseSettings _settings = ShowcaseSettings();

  @override
  void dispose() {
    _settings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseScope(
      settings: _settings,
      child: ListenableBuilder(
        listenable: _settings,
        builder: (BuildContext context, Widget? _) => MaterialApp(
          title: 'gx_gauge showcase',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorSchemeSeed: Colors.indigo),
          darkTheme: ThemeData(
            colorSchemeSeed: Colors.indigo,
            brightness: Brightness.dark,
          ),
          themeMode: _settings.themeMode,
          builder: (BuildContext context, Widget? child) => Directionality(
            textDirection: _settings.rtl
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: child!,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}

/// One entry on the home screen.
class _Destination {
  const _Destination({
    required this.title,
    required this.description,
    required this.preview,
    required this.page,
  });

  final String title;
  final String description;
  final Widget preview;
  final Widget Function() page;
}

const GxGaugeValue _preview = GxGaugeValue(value: 64);
const GxLinearNeedle _pointer = GxLinearNeedle(
  shape: GxNeedleShape.triangle,
  position: GxNeedlePosition.top,
  size: Size(12, 12),
);

final List<_Destination> _destinations = <_Destination>[
  _Destination(
    title: 'Linear progress',
    description: 'Bars and lines, needles, labels, animation, vertical.',
    preview: const GxLinearProgressGauge(
      value: _preview,
      needle: GxLinearNeedle(
        shape: GxNeedleShape.triangle,
        position: GxNeedlePosition.bottom,
        size: Size(12, 12),
      ),
    ),
    page: () => const ProgressScreen(),
  ),
  _Destination(
    title: 'Linear stepper',
    description: 'Shapes, markers, tappable steps, vertical.',
    preview: const GxLinearStepperGauge(
      currentStep: 1,
      height: 46,
      shapeSize: 18,
      steps: <GxStepperStep>[
        GxStepperStep(label: GxGaugeLabel(label: 'Order')),
        GxStepperStep(label: GxGaugeLabel(label: 'Pack')),
        GxStepperStep(label: GxGaugeLabel(label: 'Ship')),
      ],
    ),
    page: () => const StepperScreen(),
  ),
  _Destination(
    title: 'Linear scale',
    description: 'Ticks, labels, needles, markers, ranges, bars.',
    preview: const GxLinearScaleGauge(
      value: _preview,
      height: 56,
      interval: 20,
      needle: _pointer,
      ranges: <GxLinearRange>[
        GxLinearRange(start: 0, end: 60, color: Colors.green),
        GxLinearRange(start: 60, end: 85, color: Colors.orange),
        GxLinearRange(start: 85, end: 100, color: Colors.red),
      ],
    ),
    page: () => const ScaleScreen(),
  ),
  _Destination(
    title: 'Linear bar',
    description: 'Segments, gradients, borders, tooltip, needle.',
    preview: const GxLinearBarGauge(
      value: _preview,
      height: 16,
      gapBetweenBars: 3,
      needle: _pointer,
      bars: <GxLinearBarPointer>[
        GxLinearBarPointer(start: 0, end: 50, color: Colors.green),
        GxLinearBarPointer(start: 50, end: 80, color: Colors.orange),
        GxLinearBarPointer(start: 80, end: 100, color: Colors.red),
      ],
    ),
    page: () => const BarScreen(),
  ),
  _Destination(
    title: 'Radial',
    description: 'Arcs, ticks, needles, pointers, ranges, knob, clock.',
    preview: const Center(
      child: GxRadialGauge(
        value: _preview,
        diameter: 110,
        startAngleInDegree: 135,
        sweepAngleInDegree: 270,
        showNeedle: true,
        needle: GxRadialNeedle(thickness: 6),
      ),
    ),
    page: () => const RadialScreen(),
  ),
  _Destination(
    title: 'Playground',
    description: 'Every gauge driven by the same live controls.',
    preview: const Center(child: Icon(Icons.tune, size: 56)),
    page: () => const PlaygroundScreen(),
  ),
];

/// Lists every showcase screen with a live preview.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('gx_gauge showcase'),
        actions: settingsActions(context),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final int columns = (constraints.maxWidth / 360).floor().clamp(1, 3);
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisExtent: 220,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _destinations.length,
            itemBuilder: (BuildContext context, int index) =>
                _DestinationCard(_destinations[index]),
          );
        },
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  const _DestinationCard(this.destination);

  final _Destination destination;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Card.outlined(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => destination.page(),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(destination.title, style: text.titleMedium),
              const SizedBox(height: 2),
              Text(destination.description, style: text.bodySmall),
              Expanded(
                child: IgnorePointer(child: Center(child: destination.preview)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
