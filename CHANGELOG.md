# Changelog

## 1.0.0-dev.2 (unreleased)

### Breaking

- **Every gauge animates implicitly.** Pass `duration` (default `Duration.zero`, so no animation) and `curve`. `GxAnimatedLinearProgressGauge` and `GxAnimationType` are removed; use `GxLinearProgressGauge(duration: …, curve: …)`.
- **Bars and ranges take explicit ranges.**
  - `GxLinearBarPointer(value:)` is now `GxLinearBarPointer(start:, end:)`.
  - `GxLinearFillArea` and `GxRadialRange` use `start`/`end` instead of `startValue`/`endValue`.
- **Sizing follows the parent's constraints.**
  - Linear gauges take the full width and a `height`. The `size` parameter is removed from the bar, scale and stepper gauges.
  - `GxRadialGauge.size` is now an optional `diameter`. When it's null, the gauge fills the shortest bounded side, falling back to 200 when unbounded.
- **Theme-aware defaults.**
  - Color fields default to `null`, which resolves from the app's `ColorScheme`: `primary` for progress and arcs, `outlineVariant` for axes, `outline` for ticks, `onSurface` for needles, and `inverseSurface` for tooltips.
  - Label styles merge onto the theme's `bodySmall`.
- **Renamed and removed parameters.**
  - Renamed: `GxRadialNeedle.topOffest` → `topOffset`, `GxRadialNeedle.circle` → `cap`, and `GxLinearStepperGauge.inActiveStyle` → `inactiveStyle`.
  - `GxLinearBarGauge.gapBetweenBars` is now in logical pixels.
  - Removed: `GxLinearBarGauge.showTooltip`, `alignment` and `showNeedleInsideBar`; `GxRadialTickLabelStyle.offset`; and `GxRadialPointerShape.custom`. They had no effect, or duplicated `tooltip.enabled`.
- `GxGaugeLabel.textAlign` is non-nullable. `TextAlign.start` and `TextAlign.end` now follow the text direction.
- `GxRadialGauge.interval` is a `double?`.
- List parameters (`bars`, `markers`, `fillAreas`, `pointers`, `ranges`) are non-null and default to empty.
- Models no longer extend `Equatable`; the `equatable` dependency is removed.

### Fixed

- Radial gauges ignored `min`. The arc, needle, pointers, ranges and ticks are now placed with `(value - min) / (max - min)`.
- Tick generation no longer divides by zero, produces `NaN`, or mislabels ticks when `interval` is 0, larger than the range, or doesn't divide it evenly. Floating-point steps such as 0.1 keep their last tick.
- Radial minor ticks no longer run past the end of the arc, and `showMinorTicks` works without major ticks or labels.
- `GxLinearScaleGauge.showMajorTicks: false` now hides major ticks, and ticks, needle, markers and bars now share the same track when `axisSpaceExtent > 0`.
- Scale-gauge `bars` are drawn with the default `tickPosition` (centered on the axis). The inverted `barHeight` assert is removed.
- Every painter repaints when any drawn property changes. Previously the radial gauge only compared `value` and `style`.
- Animations no longer assert on overshooting curves, no longer leak listeners, and continue from the current value when interrupted.
- The bar gauge's needle and tooltip always sit at the value. The unreachable gap-adjustment code is gone.
- A stepper with a single step no longer divides by zero, and step markers are no longer clipped at the ends.
- `GxRadialTickStyle.copyWith` no longer resets `alignment` and `position`.
- Rectangle needles use `size.height`.
- A filled tooltip's text is now readable. It was drawn in the bubble's own color.
- `GxLinearNeedle.strokeWidth` defaults to 2, not 0, so outlined needles are visible.

### Added

- Right-to-left support: linear gauges mirror in RTL locales. `reverse` flips them, and is now available on the stepper, bar and scale gauges.
- Accessibility: `semanticLabel` and `semanticValueFormatter` on every gauge.
- `copyWith`, `==`/`hashCode` and diagnostics (`debugFillProperties`) on every model. Also `GxGaugeValue.fraction` and `GxGaugeValue.lerp`.
- Displayed values are formatted without trailing zeros, for example `65` instead of `65.0`.

## 1.0.0-dev.1 (unreleased)

- **Moved from `girix_code_gauge`.** The package is now `gx_gauge`, and every public type is `Gx`-prefixed. See [doc/MIGRATION.md](doc/MIGRATION.md) for the full old-to-new mapping.
- Requires Flutter 3.47 / Dart 3.13 or later.
- Custom needles receive the needle's style: `GxNeedlePainter(canvas, anchor, needle)`.
- `GxLinearScaleGauge` takes a single `GxGaugeValue value` instead of `minimum`, `maximum` and `value`.
- Removed parameters that had no effect: `orientation` and `gaugeType` (`GxLinearScaleGauge`), `direction` (`GxLinearBarGauge`).
- Painters and internal utilities are no longer exported.

## Previous releases (as `girix_code_gauge`)

## 0.0.6

- Bug fixes

## 0.0.5

- Allowed to draw the custom needle painter in Linear Bar Guages.

## 0.0.4

- Doc Updated
- Logs Removed

## 0.0.2

- Doc Updated

## 0.0.1

- Initial release of the package.
- Added Linear and Radial Gauge.
- Added Linear Gauge with Progress, Scale, Bar, and Stepper.
- Added Radial Gauge with Gradient, Range Bar, Pointer, and Show Case.
