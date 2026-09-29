# Changelog

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
