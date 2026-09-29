# Migrating from `girix_code_gauge` to `gx_gauge`

`girix_code_gauge` is now published as **`gx_gauge`**. The API is the same set of gauges, with consistent `Gx`-prefixed names and a few cleaned-up parameters.

This guide covers `gx_gauge` up to 1.0.0-dev.2.

## 1. Update the dependency and imports

```yaml
# pubspec.yaml
dependencies:
  gx_gauge: ^1.0.0-dev.2   # was: girix_code_gauge: ^0.0.6
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
| `GxAnimatedProgressLinearGauge` | Removed. Use `GxLinearProgressGauge(duration: …)` (see §5) |
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
| `GaugeAnimationType` | Removed. Pass any Flutter `Curve` (see §5) |
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
| `GxLinearProgressGauge`, `GxLinearBarGauge` | `customDrawNeedle:` | `needlePainter:` (new signature, see below) |
| `GxLinearScaleGauge`, `GxLinearBarGauge` | `barPointers:` | `bars:` |
| `GxLinearScaleGauge` | `markerPointers:` | `markers:` |
| `GxLinearScaleGauge` | `fillAreaPointers:` | `fillAreas:` |
| `GxLinearScaleGauge`, `GxRadialGauge` | `valueToLabelFormatCallback:` | `labelFormatter:` |
| `GxLinearScaleGauge`, `GxRadialGauge` | `valueToLabelStyleCallback:` | `labelStyler:` |
| `GxLinearScaleGauge` | `valueToMajorTickStyleCallback:` | `majorTickStyler:` |
| `GxRadialGauge` | `valueToMajorTickCallback:` | `majorTickStyler:` |
| `GxRadialGauge` | `rangeBars:` | `ranges:` |
| `GxLinearStepperGauge` | `stepperPointers:` | `steps:` |
| `GxLinearStepperGauge` | `inActiveStyle:` | `inactiveStyle:` |
| `GxRadialNeedle` | `topOffest:` | `topOffset:` |
| `GxRadialNeedle` | `circle:` | `cap:` |
| `FillAreaPointer` / `RadialBarRange` | `startValue:`, `endValue:` | `start:`, `end:` |

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
| `AnimationUtils` | Unused, and it leaked its `AnimationController`. | Every gauge animates itself (§5). |
| `GxLinearBarGauge.showTooltip`, `alignment`, `showNeedleInsideBar` | No effect, or duplicated `tooltip.enabled`. | Delete them. Use `tooltip: null` or `GxGaugeTooltip(enabled: false)` to hide the tooltip. |
| `RadialTickLabelStyle.offset` | No effect. | Use `padding`. |
| `RadialPointerShape.custom` | Drew nothing. | Use `circle` or `triangle`. |

## 5. Animation

Every gauge is now implicitly animated, like Flutter's `AnimatedContainer`. When `value` changes, the gauge animates over `duration` with `curve`. The default `duration` is `Duration.zero`, which means no animation.

```dart
// Before
GxAnimatedProgressLinearGauge(
  value: 60,
  animationType: GaugeAnimationType.easeInOut,
  duration: const Duration(milliseconds: 800),
)

// After
GxLinearProgressGauge(
  value: const GxGaugeValue(value: 60),
  curve: Curves.easeInOut,
  duration: const Duration(milliseconds: 800),
)
```

Unlike the old wrapper, the gauge doesn't animate on its first build. It animates on every later change, starting from the value currently on screen.

## 6. Bars are ranges, not lengths

`LinearBarPointer.value` was the *length* of each bar, and bars were laid end to end. `GxLinearBarPointer` now takes the values where the bar starts and ends:

```dart
// Before: three bars of 33, 33 and 34
bars: [LinearBarPointer(value: 33), LinearBarPointer(value: 33), LinearBarPointer(value: 34)]

// After
bars: const [
  GxLinearBarPointer(start: 0, end: 33),
  GxLinearBarPointer(start: 33, end: 66),
  GxLinearBarPointer(start: 66, end: 100),
]
```

`GxLinearBarGauge.gapBetweenBars` is now measured in logical pixels, not gauge units.

## 7. Sizing

Gauges now size themselves from their parent's constraints:

| Widget | Before | After |
| --- | --- | --- |
| `GxLinearBarGauge` | `size: Size(w, 40)` (required) | `height: 40` (default 20), full width |
| `GxLinearScaleGauge` | `size: Size(w, 100)` | `height: 100` (default), full width |
| `GxLinearStepperGauge` | `height:` or `size:` | `height:` (default 50), full width |
| `GxRadialGauge` | `size: Size(200, 200)` (default) | `diameter: 200`. When it's null, the gauge fills the shortest bounded side |

A linear gauge in an unbounded-width parent (e.g. a `Row`) is 200 wide. Wrap it in `SizedBox`/`Expanded` to control this.

## 8. Colors come from the theme

Style colors that you don't set now come from the app's `ColorScheme` instead of hard-coded blue, grey and red, so dark mode works automatically. To keep the old look, set the colors explicitly, e.g. `GxRadialGaugeStyle(color: Colors.blue)` and `GxRadialNeedle(color: Colors.red)`.

## 9. Right-to-left and accessibility

- Linear gauges now fill from the right in RTL locales. Set `reverse: true` to keep left-to-right filling.
- Each gauge exposes its value to screen readers. Add a `semanticLabel`, e.g. `'Battery'`, and optionally a `semanticValueFormatter`.

## 10. Deprecation of `girix_code_gauge`

`girix_code_gauge` receives no further updates. Its final release (0.0.7) only adds a notice that points here.
