# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`girix_code_gauge` is a Flutter package (published to pub.dev) that provides progress, stepper, scale, bar linear gauges and radial gauges, all drawn with `CustomPainter`. The only runtime dependency beyond Flutter is `equatable`.

## Modernisation in progress: read `docs/PLAN.md` first

The package is being rebuilt and republished as **`gx_gauge`**. `docs/PLAN.md` is the source of truth for the target API, the phase order and the PR slicing. `docs/code_review.md` lists the known defects that the plan cites as "CR <section> <n>".
- Execute only the phase or PR you were asked to do. Don't pull later-phase work forward. The README rewrite is deliberately last.
- The decisions in PLAN.md §1 (D1–D10) are settled defaults. Don't re-litigate them in code. If one needs changing, update PLAN.md first.
- Until Phase 1 lands, the code still uses the old names described below. After it lands, use the new `Gx*` names from PLAN.md §3.2, `package:gx_gauge/...` imports, and update this file.
- Directory roles: `docs/` holds internal planning and review, which is not published. `doc/` holds user-facing docs such as `MIGRATION.md`, which is published with the package.

## Commands

```bash
flutter pub get                      # install deps (root package)
flutter analyze                      # lint (currently 54 known issues; Phase 0 brings this to 0, then CI uses --fatal-infos)
flutter test                         # run all tests
flutter test test/girix_shape_test.dart          # single test file
flutter test --plain-name "<test name>"          # single test by name
dart format lib test                 # format
flutter pub publish --dry-run        # validate before publishing

# Demo app (depends on the package via `path: ../`)
cd example && flutter pub get && flutter run
```

The `test/` directory currently has only a placeholder test, so the example app is the main way to check visual changes. The target test layout (unit, widget, and Linux-only golden tests tagged `golden`) is in PLAN.md §6. Test files mirror `lib/src/` paths.

## Architecture

**Public API surface.** `lib/girix_code_gauge.dart` re-exports barrel files (`models.dart`, `painters.dart`, `widgets.dart`, `animations.dart`) from each of `lib/src/{common,linear,radial}/`. Something is public only if its barrel exports it. The barrels are incomplete: for example, `linear/painters/painters.dart` exports only `progress_linear_painter.dart`, and `bar_linear_gauge_model.dart` is not exported. When you add a public type, update the right barrel.

**Widget → Painter split.** Each gauge is a thin `Gx*` widget (`GxProgressLinearGauge`, `GxStepperLinearGauge`, `GxScaleLinearGauge`, `GxLinearBarGauge`, `GxRadialGauge`) that passes its configuration to a matching `CustomPainter` in `painters/`. The painter does all the layout math and drawing. Helper math lives in `linear/utils/` (needle, tooltip, color, bar geometry) and `radial/utils/angle_utils.dart`. When you add a new option, you usually need to change the widget constructor, the painter's fields, **and** its `shouldRepaint`.

**Shared models** (`lib/src/common/models/`):
- `GaugeValue` (Equatable): value/min/max, with asserts that `min < max` and that value is in range.
- `GaugeLabel`, `GaugeTooltip`, `LinearBarPointer`, plus the enums in `enums.dart` (orientation, positions, tooltip types, etc.).
- `common/utils/typedef.dart` defines callbacks such as `ValueToLabelCallback` and `ValueToLabelFormatCallback`, which let callers style or format labels and ticks per value.

Per-gauge style objects are in `linear/models/` (`linear_gauge_style.dart`, `scale_linear_gauge_model.dart`, `linear_needle_model.dart`, …) and `radial/models/radial_gauge_style.dart`.

**Custom drawing hooks.** Needles can be replaced by user code through `customDrawNeedle: void Function(Canvas, Offset)`, which the painters call instead of their default drawing (added to `GxLinearBarGauge` in 0.0.5).

**Animation.** `GxAnimatedProgressLinearGauge` is a stateful wrapper. It tweens between the old and new value using a `GaugeAnimationType` curve and rebuilds `GxProgressLinearGauge` on every tick. This wrapper is slated for removal (PLAN.md D8), so don't copy the pattern. New animation work uses `ImplicitlyAnimatedWidget` with `duration` and `curve` parameters, and passes the animation to `CustomPainter(repaint:)`.

**Example app** (`example/lib/main.dart`) lists `FeatureItem` demos with one screen per gauge type under `example/lib/screens/`. README images are served from `example/assets/images/` through raw GitHub URLs.

## Conventions

- Public widgets use the `Gx` prefix. In `gx_gauge`, **every** public type does (PLAN.md D2).
- Rules for new or refactored code:
  - Models are `@immutable` with `const` constructors, hand-written `==`/`hashCode` (not `equatable`, PLAN.md D6), and a `copyWith` covering every field.
  - Painters take a single config object and compare it in `shouldRepaint`.
  - Value→position math goes through the shared scale helper using `(v - min) / (max - min)`, never `v / max`.
  - Take the text direction from `Directionality` and defaults from `Theme`, and wrap each gauge in `Semantics`.
  - Don't add parameters that aren't wired to rendering.
- `analysis_options.yaml` turns on `strict-casts`, `strict-raw-types`, `always_specify_types`, `always_use_package_imports` (`package:girix_code_gauge/...`, never relative imports), `prefer_single_quotes`, `sort_constructors_first`, `always_put_control_body_on_new_line`, `avoid_print`, and many more. Run `flutter analyze` after edits.
- Public model fields are documented with `///` doc comments that include a ```dart usage snippet. Keep this style, because pub.dev scoring and the README depend on it.
- Record user-visible changes in `CHANGELOG.md` and bump `version` in `pubspec.yaml`.
- `lib/src/linear/painters/linear_bar_painter copy.dart` is a stray, unreferenced backup file. Don't edit it thinking it's live code.
