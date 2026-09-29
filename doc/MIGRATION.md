# Migrating from `girix_code_gauge` to `gx_gauge`

`girix_code_gauge` is now published as **`gx_gauge`**. The API is the same set of gauges, with consistent `Gx`-prefixed names and a few cleaned-up parameters.

This guide covers `gx_gauge` 1.0.0-dev.1. Later 1.0.0 pre-releases add further changes, which are listed in the changelog.

## 1. Update the dependency and imports

```yaml
# pubspec.yaml
dependencies:
  gx_gauge: ^1.0.0-dev.1   # was: girix_code_gauge: ^0.0.6
```

```dart
import 'package:gx_gauge/gx_gauge.dart'; // was: package:girix_code_gauge/girix_code_gauge.dart
```

`gx_gauge` requires Flutter 3.47 / Dart 3.13 or later.

## 2. Renamed types

Most migrations are a find-and-replace of the names below. Match whole words, so that `LinearNeedle` doesn't also rewrite `LinearNeedleLabel`.

### Widgets

| `girix_code_gauge` | `gx_gauge` |
| --- | --- |
| `GxProgressLinearGauge` | `GxLinearProgressGauge` |
| `GxAnimatedProgressLinearGauge` | `GxAnimatedLinearProgressGauge` |
| `GxStepperLinearGauge` | `GxLinearStepperGauge` |
| `GxScaleLinearGauge` | `GxLinearScaleGauge` |
| `GxLinearBarGauge` | `GxLinearBarGauge` (unchanged) |
| `GxRadialGauge` | `GxRadialGauge` (unchanged) |

### Models and styles

| `girix_code_gauge` | `gx_gauge` |
| --- | --- |
| `GaugeValue` | `GxGaugeValue` |
| `GaugeLabel` | `GxGaugeLabel` |
| `GaugeTooltip` | `GxGaugeTooltip` |
| `ProgressLinearStyle` | `GxLinearProgressStyle` |
| `LinearNeedle` | `GxLinearNeedle` |
| `LinearNeedleLabel` | `GxNeedleLabel` |
| `LinearBarPointer` | `GxLinearBarPointer` |
| `LinearMarkerPointer` | `GxLinearMarkerPointer` |
| `FillAreaPointer` | `GxLinearFillArea` |
| `LinearAxisTrackStyle` | `GxLinearAxisStyle` |
| `LinearTickStyle` | `GxLinearTickStyle` |
| `StepperPointer` | `GxStepperStep` |
| `RadialGaugeStyle` | `GxRadialGaugeStyle` |
| `RadialTickStyle` | `GxRadialTickStyle` |
| `RadialTickLabelStyle` | `GxRadialTickLabelStyle` |
| `RadialNeedle` | `GxRadialNeedle` |
| `NeedleCircle` | `GxNeedleCap` |
| `RadialPointer` | `GxRadialPointer` |
| `RadialPointerStyle` | `GxRadialPointerStyle` |
| `RadialBarRange` | `GxRadialRange` |

### Enums

| `girix_code_gauge` | `gx_gauge` |
| --- | --- |
| `GaugeAnimationType` | `GxAnimationType` |
| `GaugeTooltipPosition` | `GxTooltipPosition` |
| `GaugeTooltipType` | `GxTooltipType` |
| `LinearElementPosition` | `GxElementPosition` |
| `LinearGaugeLabelPosition` | `GxLabelPosition` |
| `LinearGaugeNeedlePosition` | `GxNeedlePosition` |
| `LinearGaugeNeedleType` | `GxNeedleShape` |
| `RadialElementAlignment` | `GxRadialElementAlignment` |
| `RadialElementPosition` | `GxRadialElementPosition` |
| `RadialNeedleShape` | `GxRadialNeedleShape` (value `tapperedLine` is now `taperedLine`) |
| `RadialPointerShape` | `GxRadialPointerShape` |
| `StepperShape` | `GxStepperShape` |
| `LinearGaugeOrientation`, `LinearGaugeDirection`, `ScaleLinearGaugeType`, `LinearGaugeAxisPosition` | Removed (see §4) |

### Callback typedefs

| `girix_code_gauge` | `gx_gauge` |
| --- | --- |
| `ValueToLabelFormatCallback` | `GxValueLabelFormatter` |
| `ValueToLabelStyleCallback` | `GxValueLabelStyler<TextStyle>` |
| `ValueToRadialLabelStyleCallback` | `GxValueLabelStyler<GxRadialTickLabelStyle>` |
| `ValueToMajorTickStyleCallback` | `GxValueTickStyler<GxLinearTickStyle>` |
| `ValueToRadialMajorTickCallback` | `GxValueTickStyler<GxRadialTickStyle>` |
| `ValueToLabelCallback` | Removed (unused) |

## 3. Renamed parameters

| Where | `girix_code_gauge` | `gx_gauge` |
| --- | --- | --- |
| `GxLinearNeedle` | `needleType:` | `shape:` |
| `GxLinearProgressGauge`, `GxAnimatedLinearProgressGauge`, `GxLinearBarGauge` | `customDrawNeedle:` | `needlePainter:` (new signature, see below) |
| `GxLinearScaleGauge`, `GxLinearBarGauge` | `barPointers:` | `bars:` |
| `GxLinearScaleGauge` | `markerPointers:` | `markers:` |
| `GxLinearScaleGauge` | `fillAreaPointers:` | `fillAreas:` |
| `GxLinearScaleGauge`, `GxRadialGauge` | `valueToLabelFormatCallback:` | `labelFormatter:` |
| `GxLinearScaleGauge`, `GxRadialGauge` | `valueToLabelStyleCallback:` | `labelStyler:` |
| `GxLinearScaleGauge` | `valueToMajorTickStyleCallback:` | `majorTickStyler:` |
| `GxRadialGauge` | `valueToMajorTickCallback:` | `majorTickStyler:` |
| `GxRadialGauge` | `rangeBars:` | `ranges:` |
| `GxLinearStepperGauge` | `stepperPointers:` | `steps:` |

### Custom needles receive the needle

The custom needle callback now also receives the configured `GxLinearNeedle`, so it can use the needle's color and size instead of hard-coding them.

```dart
// Before
customDrawNeedle: (Canvas canvas, Offset position) {
  canvas.drawCircle(position, 8, Paint()..color = Colors.orange);
},

// After
needlePainter: (Canvas canvas, Offset anchor, GxLinearNeedle needle) {
  canvas.drawCircle(anchor, needle.size.width / 2, Paint()..color = needle.color);
},
```

### `GxLinearScaleGauge` takes a `GxGaugeValue`

Like the other gauges, the scale gauge now takes one `GxGaugeValue` instead of three separate numbers.

```dart
// Before
GxScaleLinearGauge(minimum: -50, maximum: 50, value: 10)

// After
GxLinearScaleGauge(value: const GxGaugeValue(value: 10, min: -50, max: 50))
```

## 4. Removed parameters and types

These had only one working value or no effect at all, so removing them doesn't change how any gauge draws.

| Removed | Why | What to do |
| --- | --- | --- |
| `GxScaleLinearGauge.orientation` / `LinearGaugeOrientation` | Only `horizontal` existed, and it was ignored. | Delete the argument. Vertical gauges are planned as an `Axis direction` parameter. |
| `GxLinearBarGauge.direction` / `LinearGaugeDirection` | Same as above. | Delete the argument. |
| `GxScaleLinearGauge.gaugeType` / `ScaleLinearGaugeType` | `multiRange` drew nothing, and `defaultGauge` is now the only behaviour. | Delete the argument. Ranges are planned as a `ranges:` parameter. |
| Painters (`ProgressLinearPainter`, `RadialGaugePainter`) and `BasePainter` | Implementation details. | Use the widgets. To draw your own needle, use `needlePainter`. |
| `AnimationUtils` | Unused, and it leaked its `AnimationController`. | Use `GxAnimatedLinearProgressGauge` or your own `AnimationController`. |

## 5. Deprecation of `girix_code_gauge`

`girix_code_gauge` receives no further updates. Its final release (0.0.7) only adds a notice that points here.
