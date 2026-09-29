# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`gx_gauge` (formerly `girix_code_gauge` on pub.dev) is a Flutter package of linear progress, stepper, scale and bar gauges plus a radial gauge, all drawn with `CustomPainter`. It has no runtime dependencies beyond Flutter (PLAN.md D6), so don't add any.

## Modernisation in progress: read `docs/PLAN.md` first

The package is being rebuilt and republished as **`gx_gauge`**. `docs/PLAN.md` is the source of truth for the target API, the phase order and the PR slicing. `docs/code_review.md` lists the known defects that the plan cites as "CR <section> <n>".
- Execute only the phase or PR you were asked to do. Don't pull later-phase work forward. The README rewrite is deliberately last.
- The decisions in PLAN.md §1 (D1–D10) are settled defaults. Don't re-litigate them in code. If one needs changing, update PLAN.md first.
- Phases 1 (the rename) and 2 (quality and correctness) have landed. `doc/MIGRATION.md` maps every old name to its new one. When you change a public name or parameter, update MIGRATION.md and CHANGELOG.md in the same change.
- Directory roles: `docs/` holds internal planning and review, which is not published. `doc/` holds user-facing docs such as `MIGRATION.md`, which is published with the package.

## Commands

The Flutter version is pinned in `.fvmrc` (currently 3.47.5 / Dart 3.13). Always run the toolchain through `fvm`. The global `flutter` on this machine is an older, locally modified SDK.

```bash
fvm flutter pub get                                   # install deps (also run in example/)
fvm flutter analyze --fatal-infos                     # must report "No issues found!"
fvm dart format lib test example/lib example/test     # keep everything formatted
fvm flutter test                                      # all package tests
fvm flutter test test/linear/needle_utils_test.dart   # single file
fvm flutter test --plain-name "clamps values"         # single test by name
(cd example && fvm flutter test)                      # example app smoke test
fvm flutter pub publish --dry-run                     # package validation
fvm dart doc --dry-run                                # must report 0 warnings

# Demo app (depends on the package via `path: ../`)
cd example && fvm flutter run                          # minimal demo (lib/main.dart)
cd example && fvm flutter run -t lib/showcase/main.dart  # full showcase
```

There is no CI yet (deferred, see PLAN.md Phase 0). Before handing work back, run format, `analyze --fatal-infos`, and both test suites locally.

**Tests.** Painter tests draw into `test/helpers/recording_canvas.dart` (a `Canvas` that records calls) and assert on recorded arguments, e.g. `canvas.callsTo('drawArc')`. `test/widgets_smoke_test.dart` pumps every public gauge. `test/helpers/configs.dart` builds painter configs with fixed colors. `test/widgets_behavior_test.dart` covers animation, semantics, RTL, theming and sizing, and `test/models/model_equality_test.dart` is a table of one variant per field for every model; add a row when you add a field. A known bug gets a test with `skip: 'Known bug CR <ref> …'` rather than a test that pins the wrong behaviour; the phase that fixes the bug removes the `skip`. Compare colors read back from `Paint` with `toARGB32()`, not `==`. Test files mirror `lib/src/` without the `src/` segment. The target layout, including Linux-only goldens tagged `golden`, is in PLAN.md §6.

## Architecture

**Public API surface.** `lib/gx_gauge.dart` is the only public library. It lists every public symbol with `export 'src/…' show …`, so nothing becomes public by accident. When you add a public type, add it to a `show` list there. Everything else under `lib/src/` is internal: `core/`, `*/painters/` and `*/utils/`. Tests import internal files by their `package:gx_gauge/src/…` paths. Inside `lib/src/`, import other `src` files directly and never `package:gx_gauge/gx_gauge.dart`.

**How a gauge renders.** Each gauge follows the same pipeline, and a new option has to go through all of it:
1. **Widget** (`*/widgets/`). An `ImplicitlyAnimatedWidget` whose state extends `AnimatedGaugeState` (`core/gauge_widgets.dart`). That state tweens `value.value` whenever it changes, continuing from the value on screen if a previous animation is still running.
   - `build` resolves theme fallbacks through `GaugeDefaults.of(context)` (`core/gauge_defaults.dart`) and the text direction through `Directionality`. For linear gauges, `reversed = (rtl) != reverse`.
   - It builds one immutable `*PainterConfig`, then wraps the paint in `gaugeSemantics` (`Semantics` plus `RepaintBoundary`) and in `LinearGaugeBox` (full width, fixed height) or `RadialGaugeBox` (square).
2. **Config** (`*PainterConfig extends PainterConfig`, in the painter file). It holds every drawn field, with colors already resolved. It lists all of them in `props`, which drives `==`, so `shouldRepaint` is just `old.config != config || old.value != value`. A field missing from `props` means the gauge won't repaint when it changes.
3. **Painter.** `CustomPainter(repaint: value)`, so animation frames repaint without rebuilding. All value-to-position math goes through `GaugeScale` (`core/gauge_scale.dart`):
   - `fractionOf` is clamped, so overshooting curves are safe.
   - `ticks(interval)` is the only tick generator.
   - Linear x positions come from `LinearTrack.xOf`, which handles RTL. Radial angles are `start + fraction * sweep`.
   - Text is drawn with `paintText` (`core/text_utils.dart`), which disposes each `TextPainter`, and values are displayed with `formatGaugeValue`.

**Models** live in `common/models/` (`GxGaugeValue`, `GxGaugeLabel`, `GxGaugeTooltip`, enums), `linear/models/` and `radial/models/radial_gauge_style.dart`.
- Each model is `@immutable`, mixes in `Diagnosticable`, and has hand-written `==`/`hashCode` and a `copyWith` covering every field.
- Color fields are nullable: null means the theme default, resolved in the widget, never in the model.
- Bars, fill areas and radial ranges cover explicit `start`..`end` values.
- Callbacks live in `common/utils/typedef.dart`: `GxValueLabelFormatter`, the generic `GxValueLabelStyler<T>`/`GxValueTickStyler<T>`, and `GxNeedlePainter`. `GxSemanticValueFormatter` is in `core/semantics.dart`.

**Custom needles.** When `GxLinearNeedle.shape` is `GxNeedleShape.custom`, `NeedleUtils.drawIt` calls `needlePainter(canvas, anchor, needle)`, with the needle's color already resolved. This is wired for the progress and bar gauges; the scale gauge gets it in Phase 3.

**Example app** (package `gx_gauge_example`). `example/lib/main.dart` is a deliberately minimal demo, because pub.dev shows it on the Example tab. Keep it short. The full showcase is `example/lib/showcase/`: `showcase_app.dart` lists `FeatureItem` demos, with one screen per gauge type under `showcase/screens/`. README images are served from `example/assets/images/` through raw GitHub URLs.

## Conventions

- Public widgets use the `Gx` prefix. In `gx_gauge`, **every** public type does (PLAN.md D2).
- Rules for new or refactored code:
  - Follow the rendering pipeline above. Never do value math outside `GaugeScale`/`LinearTrack`, and never hard-code a color or `TextDirection.ltr` in a painter.
  - Don't add parameters that aren't wired to rendering. Parameters that are still ignored are documented as "Not applied yet (docs/PLAN.md Phase 3)".
  - `public_member_api_docs` is on: every public member needs a `///` doc comment that states its real default.
- `analysis_options.yaml` builds on `flutter_lints` and adds `strict-casts`/`strict-inference`/`strict-raw-types`, `always_use_package_imports` (in `lib/`, use `package:gx_gauge/src/...`, never relative imports), `prefer_single_quotes`, `sort_constructors_first` and a curated rule list. `always_specify_types` was intentionally dropped (PLAN.md D7), but existing code still spells out types, so match the surrounding style.
- Record user-visible changes in `CHANGELOG.md` and bump `version` in `pubspec.yaml`.
