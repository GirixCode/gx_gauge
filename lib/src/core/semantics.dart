import 'package:gx_gauge/src/core/gauge_scale.dart';

/// Formats a gauge value for screen readers.
typedef GxSemanticValueFormatter = String Function(double value);

/// The semantic value text for [value], using [formatter] when given.
String semanticValue(GxSemanticValueFormatter? formatter, double value) =>
    formatter?.call(value) ?? formatGaugeValue(value);
