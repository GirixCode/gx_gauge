import 'package:flutter/material.dart';

/// Theme-derived fallbacks for every color and text style a gauge draws with.
///
/// Style fields left `null` resolve against these, so gauges follow the app's
/// [ColorScheme] and [TextTheme], including dark mode.
@immutable
class GaugeDefaults {
  /// Creates a set of defaults. Prefer [GaugeDefaults.of].
  const GaugeDefaults({
    required this.primary,
    required this.onPrimary,
    required this.tertiary,
    required this.track,
    required this.tick,
    required this.needle,
    required this.surface,
    required this.onSurface,
    required this.tooltip,
    required this.onTooltip,
    required this.labelStyle,
    required this.valueStyle,
  });

  /// Resolves defaults from the ambient [Theme].
  factory GaugeDefaults.of(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    return GaugeDefaults(
      primary: scheme.primary,
      onPrimary: scheme.onPrimary,
      tertiary: scheme.tertiary,
      track: scheme.outlineVariant,
      tick: scheme.outline,
      needle: scheme.onSurface,
      surface: scheme.surface,
      onSurface: scheme.onSurface,
      tooltip: scheme.inverseSurface,
      onTooltip: scheme.onInverseSurface,
      labelStyle: (theme.textTheme.bodySmall ?? const TextStyle(fontSize: 12))
          .copyWith(color: scheme.onSurfaceVariant),
      valueStyle: (theme.textTheme.titleLarge ?? const TextStyle(fontSize: 20))
          .copyWith(color: scheme.onSurface),
    );
  }

  /// Fill color for progress, arcs and bars.
  final Color primary;

  /// Content drawn on top of [primary], e.g. active stepper indices.
  final Color onPrimary;

  /// Radial pointer markers.
  final Color tertiary;

  /// Axis tracks.
  final Color track;

  /// Major and minor ticks.
  final Color tick;

  /// Needles.
  final Color needle;

  /// Background behind a stroked needle cap.
  final Color surface;

  /// Text and shapes on the surface.
  final Color onSurface;

  /// Tooltip bubble.
  final Color tooltip;

  /// Tooltip text.
  final Color onTooltip;

  /// Tick labels, step labels and bar labels.
  final TextStyle labelStyle;

  /// The large value shown at the center of a radial gauge.
  final TextStyle valueStyle;

  @override
  bool operator ==(Object other) =>
      other is GaugeDefaults &&
      other.primary == primary &&
      other.onPrimary == onPrimary &&
      other.tertiary == tertiary &&
      other.track == track &&
      other.tick == tick &&
      other.needle == needle &&
      other.surface == surface &&
      other.onSurface == onSurface &&
      other.tooltip == tooltip &&
      other.onTooltip == onTooltip &&
      other.labelStyle == labelStyle &&
      other.valueStyle == valueStyle;

  @override
  int get hashCode => Object.hash(
    primary,
    onPrimary,
    tertiary,
    track,
    tick,
    needle,
    surface,
    onSurface,
    tooltip,
    onTooltip,
    labelStyle,
    valueStyle,
  );
}
