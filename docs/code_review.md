# Code review: `girix_code_gauge` package

- **Scope:** the whole `lib/` directory, plus the README where it documents `lib/`. The version reviewed is `v0.0.6`, commit `c5e74a736fed5463d7b49172c268b27b649a2b9f`.
- **How it was reviewed:** with the `code-review` plugin. Five independent reviewers looked at CLAUDE.md compliance, obvious bugs, git history, API/doc consistency and whether the code does what its comments say. Every candidate issue was then scored from 0 to 100 against the code, and only issues scoring **≥ 80** are listed.
- **Links:** they point at `c5e74a7`. Uncommitted working-tree changes to `linear_needle_model.dart` and `needle_utils.dart` are not reflected in the links.

Found 24 issues.

---

## Radial gauge

1. **The value-to-angle math ignores `min`.** Every angle is calculated as `(v / value.max) * sweepAngle` rather than `(v - min) / (max - min)`. This covers the range bars, the needle, the pointers and the foreground arc. Any gauge with `min != 0` draws everything at the wrong angle. For example, with `min: -50, max: 50, value: 0` the arc is empty instead of half full.

   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/radial/painters/radial_gauge_painter.dart#L144-L148>
   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/radial/painters/radial_gauge_painter.dart#L272-L274>
   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/radial/painters/radial_gauge_painter.dart#L505-L507>

2. **Tick count ignores `min` and can produce NaN.** `totalTicks = maxValue ~/ interval` ignores `min`.
   - If `max < interval` (for example the default `interval` of 10 with `max: 1`), `totalTicks` is 0 and `i / totalTicks` gives NaN angles and labels.
   - An `interval` of 0 throws.

   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/radial/painters/radial_gauge_painter.dart#L556-L575>

3. **`shouldRepaint` compares only `value` and `style`.** Changing the needle, pointers, range bars, angles, interval, tick styles, show flags or callbacks while keeping the same value and style does not repaint. CLAUDE.md says a new option needs "the widget constructor, the painter's fields, **and** its `shouldRepaint`".

   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/radial/painters/radial_gauge_painter.dart#L123-L127>

4. **`showMinorTicks: true` alone draws nothing.** The tick pass only runs when `showMajorTicks || showLabels`.

   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/radial/painters/radial_gauge_painter.dart#L81-L83>

5. **`RadialBarRange.label` is required but never drawn.** The label painting code in `_drawBarLabels` is commented out.

   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/radial/painters/radial_gauge_painter.dart#L160-L170>

6. **`RadialTickStyle.copyWith` drops `alignment` and `position`.** Both are silently reset to their defaults.

   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/radial/models/radial_gauge_style.dart#L208-L220>

7. **Documented defaults contradict the code.** In `RadialGaugeStyle`, the docs say `strokeCap` defaults to `butt` and `paintingStyle` to `fill`; the code uses `round` and `stroke`. In `RadialTickStyle`, the documented `alignment` and `position` defaults are swapped.

   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/radial/models/radial_gauge_style.dart#L61-L64>
   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/radial/models/radial_gauge_style.dart#L81-L91>
   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/radial/models/radial_gauge_style.dart#L198-L205>

## Scale linear gauge

1. **`showMajorTicks` is ignored.** Major ticks are always drawn. The flag is only read in `shouldRepaint`.

   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/painters/scale_linear_gauge_painter.dart#L352-L358>

2. **Pointers and ticks use different horizontal extents.** Ticks span `axisSpaceExtent..width - axisSpaceExtent`, but the needle, markers and fill area map values onto `0..size.width`. With `axisSpaceExtent > 0`, the needle at `max` does not line up with the last tick.

   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/painters/scale_linear_gauge_painter.dart#L161-L164>
   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/painters/scale_linear_gauge_painter.dart#L208-L211>

3. **`ScaleLinearGaugeType.multiRange` renders nothing.** It dispatches to `_drawMultiRangeGauge`, which has an empty body.

   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/painters/scale_linear_gauge_painter.dart#L248-L250>

4. **`barPointers` are invisible with the default `tickPosition`.** `_drawBars` returns early unless `tickPosition` is `inside` or `outside`, but the widget defaults to `cross`.

   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/painters/scale_linear_gauge_painter.dart#L114-L124>
   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/widgets/scale_linear_gauge.dart#L498-L500>

5. **The `barHeight` assert checks the wrong condition.** `assert(barPointers != null || barHeight == null, 'barHeight can not be null when barPoints are not null')` does the opposite of its message. It fires when `barHeight` is set without `barPointers`, and it never catches a missing `barHeight`.

   <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/widgets/scale_linear_gauge.dart#L514-L517>

## Linear bar gauge

1.  **The needle gap logic contains dead code.** Two `else if` branches have the same condition (`needleValue > startValue && needleValue < endValue`). The first is a no-op (`needleValue = needleValue`), so `needleValue += gapBetweenBars` can never run. As a result, the needle is misplaced when `gapBetweenBars > 0`.

    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/utils/linear_bar_utils.dart#L147-L157>

2.  **`shouldRepaint` ignores `tooltip` and `customDrawNeedle`.** Both fields were added in `80d2278` without updating `shouldRepaint`, so changing either alone doesn't repaint. CLAUDE.md calls out the `shouldRepaint` requirement.

    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/painters/linear_bar_painter.dart#L39-L48>

## Progress and animated gauges

1.  **`GxAnimatedProgressLinearGauge` can trip the `GaugeValue` assert.** Each frame builds `GaugeValue(value: _animation.value)` with the default 0..100 range. `GaugeAnimationType.elastic` (`Curves.elasticOut`) overshoots, so animating towards about 90–100 fails `'value must be between min and max'` in debug builds. The widget also has no way to set `min` or `max`.

    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/widgets/animated_linear_gauge.dart#L45-L47>
    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/common/models/linear_gauge_common_model.dart#L130-L134>

2.  **Animation listeners leak.** Every value change creates a new `CurvedAnimation` and adds a new `setState` listener to the same controller, and none are ever removed. After N updates, N `setState` calls fire on every frame.

    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/widgets/animated_linear_gauge.dart#L106-L111>

3.  **Animation snaps back when interrupted.** The tween starts from `oldWidget.value` instead of the current `_animation.value`, so an update mid-animation jumps back to the previous target first.

    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/widgets/animated_linear_gauge.dart#L61-L66>

4.  **`ProgressLinearStyle.props` leaves out `strokeCap` and `paintingStyle`.** `ProgressLinearPainter.shouldRepaint` relies on `style !=`, so changing only those fields doesn't repaint.

    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/models/linear_gauge_style.dart#L57-L60>

## Stepper gauge

1.  **A single pointer divides by zero.** `stepWidth = axisWidth / (actualInterval - 1)` is infinite for one pointer, which gives NaN x positions.

    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/painters/stepper_linear_painter.dart#L112-L116>

2.  **`shouldRepaint` is incomplete.** It omits `inActiveStyle` and `offset`, and `checkListEquality` compares only `pointer.value`, so label changes don't repaint.

    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/painters/stepper_linear_painter.dart#L59-L68>

## Needle

1.  **`LinearNeedle.label` is never rendered, and rectangle needles ignore `size.height`.** No painter or `NeedleUtils` reads `label`. The `rectangle` needle type uses `needleWidthSize` for both width and height, while `pipe` does use the height.

    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/models/linear_needle_model.dart#L11-L13>
    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/utils/needle_utils.dart#L89-L94>

## Package hygiene and docs

1.  **A stray duplicate painter ships in `lib/`.** `linear_bar_painter copy.dart` declares a second `LinearBarPainter` that nothing references, and its filename contains a space. CLAUDE.md says: "`lib/src/linear/painters/linear_bar_painter copy.dart` is a stray, unreferenced backup file."

    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/linear/painters/linear_bar_painter%20copy.dart#L1-L10>

2.  **README scale examples don't compile.** `ValueToLabelFormatCallback` is `String Function(double, int)`, but the README uses `(value, index) => value` and calls `value.length` on a `double`.

    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/README.md#L436-L438>
    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/README.md#L495-L498>
    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/common/utils/typedef.dart#L19-L21>

3.  **The README radial "Ranges" example doesn't compile.** Its `RadialBarRange(...)` calls leave out the required `label`.

    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/README.md#L1239-L1259>
    <https://github.com/GirixCode/girix-code-gauge/blob/c5e74a736fed5463d7b49172c268b27b649a2b9f/lib/src/radial/models/radial_gauge_style.dart#L31-L33>

---

<details>
<summary>Real but below the 80 threshold (scored 50–75, not included above)</summary>

- Linear bars treat `LinearBarPointer.value` as a segment length and ignore `min`, so bars can extend past the widget's width (`linear_bar_utils.dart` L22-42).
- The scale tick count is NaN or throws when `interval` is 0 or larger than the range, and ticks are mislabelled when the range isn't a multiple of `interval`.
- The scale gauge has no `customDrawNeedle`, so `LinearGaugeNeedleType.custom` draws nothing on it.
- The scale painter's `shouldRepaint` omits `gaugeType` and `orientation`.
- Radial minor ticks are drawn past the end of the arc for the last major tick.
- `ProgressLinearPainter.shouldRepaint` omits `label` and `customDrawNeedle`.
- `GxLinearBarGauge.showTooltip` and `alignment` are never used.
- `LinearBarPointer.shaderCallback`, `offset` and `position` are ignored.
- `label!.textAlign!` crashes when `textAlign` is explicitly set to null.
- `typedef.dart` is not exported.
- `bar_linear_gauge_model.dart` is not exported and not used.
- The README claims vertical orientation, but only `horizontal` exists.
- In the uncommitted changes, `LinearNeedle.strokeWidth` defaults to 0.0, which gives a hairline needle when `paintingStyle` is `stroke`.
- The `GxScaleLinearGauge` docs reference a `ranges` parameter and `LinearGaugeRange` class that don't exist.

</details>
