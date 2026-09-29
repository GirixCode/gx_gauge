# Changelog

All notable changes to this package are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the package uses [Semantic Versioning](https://semver.org/).

## [1.0.0] - Unreleased

The first release under the name `gx_gauge`. **The package was previously published as [`girix_code_gauge`](https://pub.dev/packages/girix_code_gauge).** [doc/MIGRATION.md](doc/MIGRATION.md) maps every old API to the new one.

### Added

- **Implicit animation on every gauge:** `duration` and `curve` animate value changes, continuing from the value on screen when interrupted.
- **Interaction:** `onChanged`/`onChangeEnd` on the progress, scale, bar and radial gauges (the radial gauge works like a knob), and `onStepTapped` on the stepper. Interactive gauges are adjustable by screen readers.
- **Vertical gauges:** `direction: Axis.vertical` on all linear gauges.
- **Right-to-left support:** linear gauges mirror in RTL locales, and `reverse` flips them.
- **Accessibility:** `semanticLabel` and `semanticValueFormatter`.
- **Theme-aware defaults:** colors you don't set come from the app's `ColorScheme`, so dark mode works.
- **Ranges:**
  - `GxLinearRange` bands on the scale gauge, with label, gradient and border.
  - Radial range labels and gradients.
- **Needles and markers:**
  - Needle labels with a `{value}` placeholder.
  - Marker widgets on the scale gauge.
  - Custom needle painting on the scale gauge.
- **Bars:** `GxLinearBarPointer` `thickness`, `position`, `offset`, gradient and border.
- **Models:** `copyWith`, `==`/`hashCode` and DevTools diagnostics on every model.

### Changed

- **Names:** every public type has the `Gx` prefix, and the widgets are `GxLinearProgressGauge`, `GxLinearStepperGauge`, `GxLinearScaleGauge`, `GxLinearBarGauge` and `GxRadialGauge`.
- **Values and ranges:**
  - Bars and ranges take explicit `start`/`end` values instead of segment lengths.
  - The stepper takes `currentStep` (an index).
  - `GxLinearScaleGauge` takes a `GxGaugeValue`.
- **Sizing:** gauges size themselves from their parent. Linear gauges take a `height` and fill the width; the radial gauge takes an optional `diameter`.
- **Needle placement:** a scale gauge's needle and marker needles are positioned relative to the axis, and a `bottom` needle sits fully below the track, mirroring `top`.
- **Radial gauge layout:**
  - When a needle is shown, the center value moves below the needle's hub.
  - Range labels sit inside a band that is shifted inwards.
- **Number formatting:** displayed values drop trailing zeros (`65` rather than `65.0`).
- **Requirements:** Flutter 3.47 / Dart 3.13 or later. The package has no dependencies beyond Flutter.

### Removed

- `GxAnimatedProgressLinearGauge`/`GaugeAnimationType`. Use `duration` and `curve` on any gauge.
- Exported painters and utilities (`ProgressLinearPainter`, `RadialGaugePainter`, `BasePainter`, `AnimationUtils`).
- `FillAreaPointer`. Use `GxLinearRange`.
- Parameters that had no effect: `orientation`, `gaugeType`, `direction` (bar), `showTooltip`, `alignment`, `showNeedleInsideBar`, `RadialTickLabelStyle.offset` and `RadialPointerShape.custom`.

### Fixed

- **Radial gauge:**
  - It ignored `min`, so the arc, needle, pointers, ranges and ticks were misplaced whenever `min != 0`.
  - Minor ticks ran past the end of the arc, and `showMinorTicks` did nothing without major ticks or labels.
  - Range labels were never drawn.
- **Ticks:** tick generation could divide by zero, produce NaN, or mislabel ticks for some intervals.
- **Scale gauge:**
  - `showMajorTicks: false` was ignored.
  - Ticks, needle and bars didn't line up when `axisSpaceExtent > 0`.
  - Bars were invisible with the default `tickPosition`.
- **Repainting:** painters now repaint whenever anything they draw changes.
- **Animated progress gauge:** it leaked listeners, asserted on overshooting curves and snapped back when interrupted.
- **Stepper:** it divided by zero with one step.
- **Tooltip:** a filled tooltip's text was invisible.
- **Needles:** rectangle needles ignored their height, and outlined needles were hairlines by default.
- **`copyWith`:** `RadialTickStyle.copyWith` dropped `alignment` and `position`.

## girix_code_gauge

Releases published under the previous package name.

### [0.0.6]

- Bug fixes.

### [0.0.5]

- Custom needle painter for the linear bar gauge.

### [0.0.4]

- Documentation updates; debug logs removed.

### [0.0.2]

- Documentation updates.

### [0.0.1]

- Initial release: progress, scale, bar and stepper linear gauges, and a radial gauge with gradient, ranges and pointers.

[1.0.0]: https://github.com/GirixCode/gx-gauge/releases/tag/v1.0.0
[0.0.6]: https://pub.dev/packages/girix_code_gauge/versions/0.0.6
[0.0.5]: https://pub.dev/packages/girix_code_gauge/versions/0.0.5
[0.0.4]: https://pub.dev/packages/girix_code_gauge/versions/0.0.4
[0.0.2]: https://pub.dev/packages/girix_code_gauge/versions/0.0.2
[0.0.1]: https://pub.dev/packages/girix_code_gauge/versions/0.0.1
