# Modernisation plan: `girix_code_gauge` → `gx_gauge`

Status: **All phases are done and committed** (`064d6cf`, `7c81892`, `b38d233`, `61b9e9c`, `efddbee`, `ef42510`). **CI has been added** (uncommitted, on branch `ci/github-actions`). **Only the owner release steps in `docs/RELEASE.md` remain.**

References:
- `docs/code_review.md` lists the confirmed defects. It is cited below as **CR**, followed by the section and item, e.g. *CR Radial 1*.
- The baseline is `v0.0.6` at commit `c5e74a7`, analysed with Flutter 3.44 / Dart 3.x.

---

## 0. Where the package stands today

| Area | Finding |
|---|---|
| Analyzer | `flutter analyze` reports 54 issues: 6 removed lint rules and 1 duplicate rule in `analysis_options.yaml`, 17 deprecated APIs (`withOpacity`, `Color.red/green/blue/value`), 15 `sort_constructors_first`, 4 unused variables, 1 private type in a public API, and the `Math` prefix. |
| Correctness | 24 confirmed defects (CR). The main themes are: normalisation ignores `min`, `shouldRepaint` is incomplete everywhere, the animation wrapper leaks listeners and trips its own assert, and some tick calculations divide by zero. |
| Public API | 62 exported types, 40 of which lack a `Gx` prefix (`GaugeValue`, `LinearNeedle`, …). Painters and `*Utils` classes are exported, although they are implementation details. `LinearGaugeOrientation` and `LinearGaugeDirection` are duplicate enums with one value each. |
| Half-built features | About 15 options are accepted but never used. The main ones are: vertical orientation, `multiRange` and `ranges`, radial range labels, needle labels, `LinearMarkerPointer.marker`, the bar pointer `shaderCallback`/`offset`/`position`, fill-area borders, stepper `value` positioning, `showTooltip`, `alignment`, `onPointerTap`, and custom needles on the scale gauge. |
| Tests | One empty placeholder test. |
| README | 1,293 lines, mostly exhaustive property lists. Several examples don't compile (CR Hygiene 2–3). It contains placeholder links (`yourusername`), `girix_code_gauge: latest`, and wrong defaults. |
| Tooling | No CI, no automated publishing, and no `screenshots:` or `topics` hygiene for pub.dev. The environment constraint `flutter: ">=1.17.0"` is wrong, because the code needs Dart 3. |
| Repo hygiene | Contains `linear_bar_painter copy.dart`, `example/flutter_0*.log` committed, a malformed `.gitignore` line (`*.// log`), an unused `bar_linear_gauge_model.dart`, an unused `BasePainter`, and an unused `AnimationUtils`. |
| Accessibility / RTL | No `Semantics` anywhere, and `TextDirection.ltr` hard-coded in 9 places. |

---

## 1. Decisions

Each decision has a recommended default. The plan below assumes these defaults, so please override any you disagree with before execution starts.

| # | Decision | Recommended default | Why |
|---|---|---|---|
| D1 | How to "rename" on pub.dev | Publish **a new package `gx_gauge`**. Release a final `girix_code_gauge 0.0.7` whose README points to `gx_gauge`, then mark it *discontinued, replaced by gx_gauge* in the pub.dev admin UI. | pub.dev cannot rename packages. This is the standard migration path. |
| D2 | Type naming | **Every public type gets the `Gx` prefix**, and names are ordered as `Gx<Kind><Thing>` (see §3.2). | Avoids collisions with other gauge packages (`GaugeValue` and `LinearGauge*` are common names) and makes the API easy to discover. |
| D3 | Backward compatibility | **None in `gx_gauge`.** It is a clean API, and a `MIGRATION.md` maps old names to new ones. | It is a new package, so deprecation shims across packages are impossible. |
| D4 | First version of `gx_gauge` | `1.0.0-dev.N` prereleases while the phases land, then **`1.0.0`** once phases 1–5 are complete. | Semver-stable from day one of general availability, while still leaving room to iterate. |
| D5 | Minimum SDK | **Latest stable**: `sdk: ^3.13.0`, `flutter: ">=3.47.0"`. The toolchain is pinned to Flutter 3.47.5 in `.fvmrc`, and CI reads that file. | Owner decision (2026-09-29): target the latest SDK for compatibility. It allows the modern `Color` API (`withValues`, `.r`/`.g`/`.b`). The trade-off is that apps on older Flutter can't upgrade to `gx_gauge`. |
| D6 | Runtime dependencies | **Zero**: drop `equatable` and write `==`/`hashCode` with `Object.hash`. | Pub.dev best practice for UI leaf packages: no transitive dependency for consumers. |
| D7 | Lint set | `flutter_lints` (latest), plus `strict-casts`, `strict-inference` and `strict-raw-types`, plus a curated rule list that includes `public_member_api_docs`. **Drop `always_specify_types`.** | `always_specify_types` conflicts with the recommended Dart style (`omit_local_variable_types`) and adds noise. |
| D8 | Animation API | Every gauge becomes implicitly animated through `duration` and `curve` parameters (the `ImplicitlyAnimatedWidget` pattern). **Remove `GxAnimatedProgressLinearGauge` and the `GaugeAnimationType` enum.** | This matches Flutter's own `AnimatedContainer`-style API, lets users pass any `Curve`, and fixes CR Progress 1–3 by construction. |
| D9 | Features that can't be done well | Implement them or remove them. **Don't ship accepted-but-ignored parameters.** See §5 for the decision on each feature. | An ignored parameter is a silent bug. |
| D10 | GitHub repo | Rename `GirixCode/girix-code-gauge` to `GirixCode/gx-gauge`. GitHub redirects the old URL. | Keeps the repo URL, the package name and the issue tracker consistent. |

---

## 2. Phase 0: Tooling and hygiene (no behaviour change)

Goal: a green, trustworthy baseline before anything moves.

1. **Clean up `analysis_options.yaml`** as described in D7. Remove the 6 removed rules and the duplicate. Enable `strict-*`.
2. **Environment** (D5): bump `sdk` and `flutter`. Replace all deprecated `Color` APIs (`withOpacity` → `withValues(alpha:)`, `.red` → `.r`, etc.).
3. **Delete** the following:
   - `linear_bar_painter copy.dart` (CR Hygiene 1)
   - `bar_linear_gauge_model.dart`
   - `BasePainter`
   - `AnimationUtils`
   - `common/widgets/gauge_label.dart`, which is entirely commented out
   - `example/flutter_0*.log`
4. **`.gitignore`:** fix the `*.// log` line, add `*.log` and `coverage/`, and stop ignoring `.vscode/` only where it's useful.
5. **CI (deferred by the owner on 2026-09-29, then done after Phase 5; see the post-release log below).** `.github/workflows/ci.yaml` runs the following on each PR and on `main`, for the package and for `example/`:
   - `dart format --set-exit-if-changed`
   - `flutter analyze --fatal-infos`
   - `flutter test --coverage`
   - `dart pub publish --dry-run`
   - `pana` (fail on score regression)
6. **Publishing (done together with CI)** (`.github/workflows/publish.yaml`): use pub.dev *automated publishing* through GitHub OIDC, triggered by `v*` tags. No personal credentials are needed. It needs a one-time admin setup on pub.dev. pub.dev can't auto-publish a package that doesn't exist yet, so the **first `gx_gauge` release must be published manually**.
6a. **`.pubignore`**: keep `docs/`, `.github/`, `.fvm*`, `CLAUDE.md` and editor files out of the published archive.
7. **Characterisation tests.** Before refactoring, add unit tests that pin the current *correct* behaviour of the pure math (see §6.1). They act as a safety net for phases 1–2.

Exit criteria: run locally, `dart format`, `flutter analyze --fatal-infos` and both test suites are clean. Until CI exists, these local checks gate every phase.

### Phase 0 progress log

- Done:
  - Flutter 3.47.5 / Dart 3.13 pinned via fvm, with the constraints bumped.
  - `analysis_options.yaml` rewritten.
  - Deprecated `Color` APIs replaced.
  - Dead files deleted: the painter copy, `bar_linear_gauge_model`, `BasePainter`, `AnimationUtils`, the commented-out `gauge_label`, and the logs.
  - `.gitignore` fixed and `.pubignore` added.
  - `.pubignore` also drops README-only images and `doc/api/` from the archive, which was 10 MB.
- Deferred: CI and publish workflows (owner decision). Both were added after Phase 5.
  - 35 characterisation tests (1 skipped on purpose as the known bug CR Radial 1).
  - Example smoke test replaced.
  - pubspec description shortened, which fixes a pana penalty.
- Baseline pana score: 140/160. The two failures are the description length (fixed) and dartdoc crashing (below).
- **Known issue:** dartdoc 9.0.x (shipped with Dart 3.13) crashes with a stack overflow on this package, which costs 10 pana points for API docs. An unnamed `library;` directive in the barrel is one trigger, so the barrel keeps a named library with an `ignore`. The Phase 0 tree still overflows with the named library. A bisect showed that no single changed file causes it on its own; reverting any one file still crashes. The trigger is therefore an interaction between changes, most likely the file deletions. **Deferred to Phase 2 (§4.6)**, where the export surface and doc comments are rewritten anyway. Re-check with `fvm dart doc --dry-run` after each Phase 1–2 PR. **Resolved in Phase 2:** after the rewrite, dartdoc reports 0 warnings, even with an unnamed `library;`, so the workaround was removed.

---

## 3. Phase 1: Rename to `gx_gauge` and reshape the public API

### 3.1 Package-level changes

1. In `pubspec.yaml`:
   - Set `name: gx_gauge` and write a new description (60–180 chars, which is pana's requirement).
   - Update the `homepage`/`repository`/`issue_tracker` URLs for D10.
   - Keep `topics` to at most 5 valid ones: `gauge`, `chart`, `progress-indicator`, `stepper`, `widget`.
   - Add `screenshots:` entries so pub.dev shows images natively.
2. Move `lib/girix_code_gauge.dart` to `lib/gx_gauge.dart`, and update every `package:girix_code_gauge/...` import in `lib/`, `test/` and `example/`.
3. **Shrink the export surface.** Export only widgets, style/config models, enums and callback typedefs. Painters and `*Utils` become internal: they stay under `lib/src/`, are not exported, and are annotated `@internal` where cross-file access is needed. This fixes the incomplete-barrel problem by removing the barrels' public role entirely: `gx_gauge.dart` uses explicit `export ... show ...` lists.
4. **Export the callback typedefs.** They are currently unexported but used in public constructors.
5. In the example app, rename `examples` to `gx_gauge_example`, and move `example/lib/main.dart` to a minimal single-screen demo so pub.dev's *Example* tab is useful. The full showcase stays under `example/lib/showcase/`.

### 3.2 Type renames

The pattern is `Gx` + `Linear|Radial|` + `Thing`. Widgets end in `Gauge`, and styles end in `Style`.

| Current | New |
|---|---|
| `GxProgressLinearGauge` | `GxLinearProgressGauge` |
| `GxAnimatedProgressLinearGauge` | *removed* (D8) |
| `GxStepperLinearGauge` | `GxLinearStepperGauge` |
| `GxScaleLinearGauge` | `GxLinearScaleGauge` |
| `GxLinearBarGauge` | `GxLinearBarGauge` *(unchanged)* |
| `GxRadialGauge` | `GxRadialGauge` *(unchanged)* |
| `GaugeValue` | `GxGaugeValue` |
| `GaugeLabel` / `GaugeTooltip` | `GxGaugeLabel` / `GxGaugeTooltip` |
| `ProgressLinearStyle` | `GxLinearProgressStyle` |
| `LinearNeedle` / `LinearNeedleLabel` | `GxLinearNeedle` / `GxNeedleLabel` |
| `LinearBarPointer` / `LinearMarkerPointer` / `FillAreaPointer` | `GxLinearBarPointer` / `GxLinearMarkerPointer` / `GxLinearFillArea` |
| `LinearAxisTrackStyle` / `LinearTickStyle` | `GxLinearAxisStyle` / `GxLinearTickStyle` |
| `StepperPointer` | `GxStepperStep` |
| `RadialGaugeStyle` / `RadialTickStyle` / `RadialTickLabelStyle` | `GxRadialGaugeStyle` / `GxRadialTickStyle` / `GxRadialTickLabelStyle` |
| `RadialNeedle` / `NeedleCircle` / `RadialPointer` / `RadialPointerStyle` / `RadialBarRange` | `GxRadialNeedle` / `GxNeedleCap` / `GxRadialPointer` / `GxRadialPointerStyle` / `GxRadialRange` |
| `LinearGaugeOrientation` + `LinearGaugeDirection` | merged into **`Axis`** (Flutter's own enum) |
| `ScaleLinearGaugeType` | *removed*. Ranges become a `ranges:` parameter instead of a mode switch (§5). |
| other enums (`LinearElementPosition`, `LinearGaugeNeedleType`, …) | `Gx`-prefixed, with names aligned (`GxElementPosition`, `GxNeedleShape`, `GxTooltipPosition`, …) |
| `ValueTo*Callback` typedefs | `GxValueLabelFormatter`, `GxValueLabelStyler`, `GxValueTickStyler` (a single set shared by linear and radial) |

Parameter hygiene across all widgets:
- Take one `GxGaugeValue value` (or `min`/`max`/`value` doubles) consistently, instead of mixing `minimum`/`maximum` and `GaugeValue`.
- Use consistent names: `showMajorTicks`/`showMinorTicks`/`showLabels`, `needle`, `ranges`, `pointers`.
- Make `customDrawNeedle` a proper typedef, `GxNeedlePainter = void Function(Canvas canvas, Offset anchor, GxLinearNeedle needle)`, so the needle's style reaches the callback.

### 3.3 Deliverables

- `doc/MIGRATION.md` maps every old symbol to its new one, with before/after snippets.
- The final `girix_code_gauge 0.0.7` release, published from a `legacy` branch. Its README carries a banner: "This package has moved to `gx_gauge`", with a link to the migration guide.

Exit criteria: CI is green, and the example builds on the new names. (CI is deferred, so the local checks from Phase 0 apply.)

### Phase 1 progress log

- Done:
  - Package renamed to `gx_gauge` 1.0.0-dev.1, with repository URLs pointing to `GirixCode/gx-gauge` (D10).
  - The `platforms:` restriction removed, so pana detects all 6 platforms.
  - Topics set per §3.1, and `documentation:` dropped (pub.dev hosts the API docs).
  - All §3.2 renames applied, plus `GxLinearNeedle.needleType` → `shape` and enum value `tapperedLine` → `taperedLine`.
  - Parameter renames: `bars`, `markers`, `fillAreas`, `ranges`, `steps`, `labelFormatter`, `labelStyler`, `majorTickStyler`, `needlePainter`.
  - `GxNeedlePainter(canvas, anchor, needle)` wired through.
  - `GxLinearScaleGauge` takes a `GxGaugeValue`.
  - `lib/gx_gauge.dart` uses explicit `show` lists, so painters and utils are no longer exported.
  - Unused `ValueToLabelCallback` and `LinearGaugeAxisPosition` deleted.
  - Example restructured into a minimal `main.dart` plus `showcase/`.
  - `doc/MIGRATION.md` and a CHANGELOG entry added.
- Deviations from the plan, all behaviour-preserving:
  - `GxAnimatedProgressLinearGauge` was renamed to `GxAnimatedLinearProgressGauge` instead of being removed. Removing it before the implicit-animation replacement (§4.3) would drop a working feature, so it is removed in Phase 2 with its `GxAnimationType` enum.
  - `LinearGaugeOrientation`/`LinearGaugeDirection` and `ScaleLinearGaugeType` were **removed without a replacement parameter**. Adding `Axis direction` or `ranges:` now would mean shipping parameters that are ignored, so they arrive in Phase 3 (§5) together with their implementations.
  - No `@internal` annotations. They need `package:meta` as a dependency, which D6 rules out. Not exporting from `lib/src/` is the standard pub convention and is sufficient.
  - `screenshots:` in the pubspec moved to Phase 5, together with moving the images to `doc/screenshots/`.
- **Owner actions (not done by Claude):** rename the GitHub repo to `gx-gauge`, and create the `legacy` branch and publish `girix_code_gauge 0.0.7` (§3.3). Both are outward-facing.
- The root `README.md` still documents the old API. It is rewritten in Phase 5, as planned.

---

## 4. Phase 2: Code quality and correctness

Fix every CR item. The fixes are grouped by technique, so each fix lands once rather than per widget.

### 4.1 Shared value/geometry core (fixes CR Radial 1–2, Scale 2, Stepper 1, and the linear-bar `min` issue)

- Create a single internal `GaugeScale` class. It maps `value ⇄ fraction ⇄ pixel/angle` using `(v - min) / (max - min)`, clamps, and generates ticks (`niceTicks(min, max, interval)`).
- `niceTicks` guards `interval <= 0`, `interval > range` and floating-point drift, for example by using `i * interval` from `min` and stopping at `max + epsilon` instead of `floor(range / interval)`.
- Every painter uses `GaugeScale` rather than its own math, and all painters use the same track extent (fixes CR Scale 2).
- `GxLinearBarPointer.value` gets explicit semantics: each bar is `[start, end]`, or else `value` is absolute and bars stack. The doc comment must say which. The decision is to use `start`/`end` explicitly, which removes the ambiguity.

### 4.2 Immutable models and repaint correctness (fixes CR Radial 3, Scale 1/5, Bar 2, Progress 4, Stepper 2)

- Every model is `@immutable` and has a `const` constructor, hand-written `==`/`hashCode` (D6), `copyWith` covering **all** fields (fixes CR Radial 6), and `lerp` for styles that animate.
- Each painter takes **one config object**, `_XxxPainterConfig`, which holds every field it draws with. `shouldRepaint` becomes `old.config != config || old.animation != animation`. This makes it structurally impossible to forget a field.
- Use `listEquals` for list fields.
- Callbacks can't be compared meaningfully, so document that callers should pass stable (top-level or `static`) functions, the same pattern Flutter uses for `CustomPainter` delegates.

### 4.3 Animation (fixes CR Progress 1–3)

- Each gauge becomes an `ImplicitlyAnimatedWidget` (D8). It tweens `value`, and also pointers/needles through `lerp`. Pass `Animation<double>` to `CustomPainter(repaint:)` instead of calling `setState` every frame.
- Overshoot curves (elastic, back) are clamped before being converted to a fraction. Asserts are never evaluated with intermediate animation values.

### 4.4 Painting performance and robustness

- **`TextPainter` caching.** Lay out labels once per config change, not on every paint, and `dispose()` them. This is Flutter's documented best practice as of 3.10.
- Reuse `Paint` objects inside a paint pass. Hoist constant `Path`s.
- Wrap each gauge's `CustomPaint` in a `RepaintBoundary`.
- Replace `!` null-assertions with pattern matching or local promotion. For example, `label!.textAlign!` becomes a non-nullable `textAlign`.
- Size contract: every gauge sizes itself from parent constraints, with a documented `intrinsic` fallback. Remove the conflicting `height` vs `size` parameters (`GxStepperLinearGauge`).

### 4.5 Platform correctness

- **Accessibility:** each gauge wraps its paint in `Semantics(value: …, label: semanticLabel)`. Add a `semanticLabel`/`semanticValueFormatter` parameter.
- **RTL:** read the text direction with `Directionality.maybeOf(context)` instead of hard-coding `ltr`. Linear gauges mirror in RTL, with a `reverse` override.
- **Theming:** style defaults come from `Theme.of(context).colorScheme`, for example `primary` for fills and `outlineVariant` for tracks, rather than hard-coded `Colors.blue`/`Colors.grey`. This makes dark mode work out of the box.
- `Diagnosticable`: implement `debugFillProperties` on widgets and styles so they show up in DevTools.

### 4.6 Documentation in code

- Enable `public_member_api_docs`. Every public member gets a doc comment with its real default. Doc snippets must compile (see §6.4).
- Remove every stale doc: `ranges`, `LinearGaugeRange`, `shape`, `foregroundColor`, the swapped defaults (CR Radial 7), and the mislabelled enum docs.

Exit criteria: all 24 CR items and the 14 below-threshold items are closed, `flutter analyze --fatal-infos` is clean, and pana scores 160/160.

### Phase 2 progress log

- **Result:**
  - `flutter analyze --fatal-infos` is clean, with `public_member_api_docs` on.
  - 116 package tests and 2 example tests pass.
  - `dart doc` reports 0 warnings.
  - **pana scores 160/160.** The only note is that the `gx-gauge` repo URL is unreachable, which clears once the repo is renamed (D10).
  - Version bumped to 1.0.0-dev.2.
- **Done:**
  - §4.1: `core/gauge_scale.dart` (`GaugeScale`, `LinearTrack`, `formatGaugeValue`), with every painter moved onto it. Bars, fill areas and radial ranges use explicit `start`/`end`.
  - §4.2:
    - All models are `@immutable` + `Diagnosticable`, with hand-written `==`/`hashCode` and complete `copyWith`. `equatable` is removed.
    - One `*PainterConfig` per painter, with `shouldRepaint` = config equality.
    - Table-driven equality tests and per-painter `shouldRepaint` tests.
  - §4.3: every gauge is an `ImplicitlyAnimatedWidget` (`duration`, `curve`, `onEnd`), sharing `AnimatedGaugeState`. The animation is passed via `CustomPainter(repaint:)`. `GxAnimatedLinearProgressGauge` and `GxAnimationType` are removed.
  - §4.4:
    - `RepaintBoundary` around every gauge, and no `!` assertions in painters.
    - Sizing comes from constraints: linear gauges get `height` and full width, the radial gauge gets `diameter` or the shortest side, with a fallback of 200.
    - The stepper's `height`/`size` conflict is removed.
  - §4.5:
    - `Semantics` with `semanticLabel`/`semanticValueFormatter`.
    - RTL mirroring with `reverse` on every linear gauge.
    - Theme-derived defaults through `GaugeDefaults`.
    - `debugFillProperties` on widgets and models.
  - §4.6: every public member is documented, and the stale docs (`ranges`, `LinearGaugeRange`, `shape`, `foregroundColor`, swapped defaults, misaligned enum docs) are removed.
  - Review items closed:
    - Radial 1–4, 6, 7.
    - Scale 1–5.
    - Bar 1–2.
    - Progress 1–4.
    - Stepper 2, plus the divide-by-zero part of Stepper 1.
    - The rectangle-height part of Needle 1.
    - Hygiene 1.
    - Below the threshold: bar value semantics, scale tick NaN, scale `shouldRepaint`, radial minor ticks past the arc, progress `shouldRepaint`, the `textAlign!` crash, the hairline `strokeWidth` default, and the stale `ranges` docs.
  - Pulled forward from Phase 3 because they fell out of the rewrite: `showMinorTicks` without major ticks, the rectangle needle's height, and removal of `showTooltip`/`alignment` (plus `showNeedleInsideBar`, `GxRadialTickLabelStyle.offset`, `GxRadialPointerShape.custom`).
- **Deviations from the plan:**
  - **TextPainter caching** (§4.4) became create → paint → `dispose()` per paint (`paintText`). A `CustomPainter` has no dispose hook, so a cache would hold native paragraphs until garbage collection. Painting only happens on config changes and animation frames, so the cost is small.
  - **`lerp` for styles and pointers** (§4.2/§4.3) was not added. Only the gauge value animates; `GxGaugeValue.lerp` exists. Animating pointers and styles can be added later without breaking changes.
  - Gauges don't animate on their first build, which is standard `ImplicitlyAnimatedWidget` behaviour. The old animated wrapper swept in from 0.
  - Scale tick alternation (`inAndOut`/`outAndIn`) is now keyed on the tick index, not `min + i`.
  - The radial z-order is now arcs → ranges → ticks → value → needle → pointers. Previously ranges were drawn over the needle.
- **Left for Phase 3 (per §5):**
  - Radial range labels (CR Radial 5).
  - The needle label (the rest of CR Needle 1).
  - Stepper value positioning (the rest of CR Stepper 1).
  - Bar pointer and fill-area `shaderCallback`/`offset`/`position`/`thickness`/border, and marker widgets. These are documented as "Not applied yet".
  - Custom needles on the scale gauge.
  - Vertical orientation, linear ranges, and interaction.
  - README examples (Hygiene 2–3) are rewritten in Phase 5.

---

## 5. Phase 3: Finish the incomplete features

Each feature is either **implemented** (I) or **removed** (R).

| Feature | Decision | Notes |
|---|---|---|
| Vertical orientation for linear gauges | **I** | Controlled by `Axis direction`. `GaugeScale` handles the main/cross axis, and painters draw in main/cross coordinates, so the vertical case needs no duplicated code. |
| Linear ranges (the old `multiRange` / `LinearGaugeRange`) | **I** | Adds `List<GxLinearRange> ranges` (start, end, color, optional label), drawn beneath pointers. This replaces the `ScaleLinearGaugeType` enum. |
| Radial range labels (CR Radial 5) | **I** | Draws the commented-out label code properly. `label` becomes optional. |
| Needle label (`LinearNeedleLabel`) | **I** | Draws the label above or below the needle, with the same positioning rules as the tooltip. |
| Rectangle needle ignoring height (CR Needle 1) | **I** | Uses `size.height`. |
| Custom needle on the scale gauge and marker pointers | **I** | Uses the shared `GxNeedlePainter` typedef (§3.2). |
| `GxLinearMarkerPointer.marker` (Widget) | **I** | Renders the widget through a `Stack` overlay positioned by `GaugeScale`. Widgets can't be painted inside `CustomPainter`. |
| Bar pointer `shaderCallback` (gradient) | **I** | Applied through `Paint.shader`. The same applies to fill areas and radial ranges, for consistency. |
| Bar pointer `offset` / `position` / `thickness` | **I** | `thickness` becomes the bar's cross-axis size. `position` is inside/outside/cross relative to the axis. |
| Fill-area `borderColor` / `borderWidth` | **I** | A second stroke pass. |
| Stepper `value` positioning (CR Stepper 1) | **R** (positioning) | A stepper uses discrete steps. Steps become evenly spaced by design, and `value` is replaced by `currentStep` (an int). The one-step case gets a guard. |
| `showTooltip` | **R** | This is duplicated by `tooltip.enabled`/`tooltip == null`. |
| `alignment` on `GxLinearBarGauge` | **R** | The parent layout should control this. |
| `onPointerTap` | **I** as `onChanged` | Adds interactive linear and radial gauges. Tapping or dragging sets the value through `GaugeScale.valueAt(offset)`, like `Slider`. Opt-in: gauges are read-only when `onChanged` is null. |
| `showMinorTicks` without major ticks (CR Radial 4) | **I** | Tick passes become independent. |
| `GaugeAnimationType` custom curves | **R** → `Curve curve` (D8) | |

Each implemented feature gets a showcase screen in the example app and README coverage (one snippet).

### Phase 3 progress log

- **Result:**
  - `flutter analyze --fatal-infos` is clean.
  - 139 package tests and 3 example tests pass. They include a test file per feature (`test/features_test.dart`) and `test/core/linear_frame_test.dart`.
  - Version bumped to 1.0.0-dev.3.
- **Implemented:**
  - Vertical orientation (`Axis direction`) on all four linear gauges, via `core/linear_frame.dart`. Painters keep drawing in horizontal logical coordinates and the canvas is rotated a quarter turn. `paintText(upright: true)` keeps text readable, and the tooltip bubble keeps its on-screen size.
  - Linear ranges (`GxLinearRange`), with label, shader, border, radius, thickness, position and offset.
  - Radial range labels (CR Radial 5), with `label` now optional, and radial range shaders.
  - Needle labels with `{value}` (the rest of CR Needle 1).
  - `needlePainter` on the scale gauge, for the value needle and marker needles.
  - Marker widgets, drawn as a `Stack` overlay positioned with the painter's own `trackFor` geometry.
  - Bar pointer `thickness`/`position`/`offset`/`shaderCallback`, plus a border.
  - Stepper `currentStep` (CR Stepper 1), with the step `value` becoming a `marker` string.
  - Interaction: `onChanged`/`onChangeEnd` on progress, scale, bar and radial, and `onStepTapped` on the stepper.
    - `GaugeInteraction` maps positions back through the same `LinearTrack`/`LinearFrame`, and through `RadialGaugePainter.valueAt` for the radial gauge.
    - Drags are restricted to the gauge's axis so they don't steal list scrolling.
    - Interactive gauges become adjustable semantics nodes, stepping 5% at a time.
  - A showcase "Features" screen in the example app.
- **Deviations:**
  - **Fill areas were merged into ranges.** `GxLinearFillArea` is removed rather than kept alongside `GxLinearRange`. A range is a strict superset (start/end/color/thickness plus label, border, gradient), so the plan's "linear ranges" and "fill-area border" rows are delivered by one type.
  - **Bars and ranges share one fill-and-border model.** `GxLinearBarPointer.paintingStyle`/`strokeCap` are replaced by `borderColor`/`borderWidth`. `thickness` couldn't mean both stroke width and cross-axis size.
  - `onChanged` gives no snapping to divisions. It can be added later without breaking changes.
  - The stepper's `semanticValueFormatter` was removed. Steps are announced as "Step N of M".
- **Remaining for Phase 5:** README coverage, one snippet per feature.

---

## 6. Phase 4: Tests

The pyramid is sized for a painting library. Target **≥ 90% line coverage for `lib/src/core`** and **≥ 80% overall**, enforced in CI.

### 6.1 Unit tests (`test/core/`)

These are pure Dart and fast:
- `GaugeScale`: value↔fraction↔pixel/angle mapping for positive, negative and offset ranges; clamping; RTL mirroring.
- `niceTicks`: interval 0, negative, larger than the range, a non-multiple range, float drift (0.1 steps), and a single tick.
- Models: `==`/`hashCode`/`copyWith` covering every field (a table-driven test per model that flips each field in turn), `lerp` endpoints, and assert messages matching the conditions.

### 6.2 Widget tests (`test/widgets/`)

- Each gauge pumps its default and fully configured forms without throwing, including at 0×0, infinite-width parents, and `min == value == max`.
- Repaint: changing each config field triggers a repaint. Use a painter-level `shouldRepaint` test per field (table-driven), which prevents regressions of CR Radial 3.
- Animation: interrupting mid-animation continues from the current value; elastic curves near `max` don't assert; disposal leaves no listeners or tickers (`tester.binding.hasScheduledFrame` is false after settle).
- Semantics: `tester.getSemantics` exposes the value and label.
- Interaction: drag or tap on an interactive gauge calls `onChanged` with the expected value.

### 6.3 Golden tests (`test/goldens/`)

- Use `matchesGoldenFile` with a `flutter_test_config.dart` that loads a bundled font (Roboto), so text renders deterministically.
- Cover one golden per gauge × {default, ranges, vertical, RTL, dark theme}.
- Goldens run **only on the Linux CI runner**, tagged `golden` and excluded locally by default. Update them with `flutter test --update-goldens --tags golden` in CI or a container.

### 6.4 Documentation tests

- `example/lib/readme_snippets.dart` contains every README snippet verbatim. CI's `flutter analyze example/` then fails if a README example stops compiling, which prevents CR Hygiene 2–3 from recurring.

Test naming: test files mirror `lib/src/`, e.g. `lib/src/core/gauge_scale.dart` → `test/core/gauge_scale_test.dart`. Delete `test/girix_shape_test.dart`.

### Phase 4 progress log

- **Scope (owner decision, 2026-09-29): only the required cases.** Phase 4 closes the §6.1/§6.2 gaps and meets the coverage targets. §6.3 (goldens) is skipped, because it is Linux-CI-only and CI is deferred. §6.4 (README snippet compile check) moves to Phase 5, where the README it checks is written.
- **Result:**
  - 152 package tests pass, and the analyzer is clean.
  - Coverage is **98.3% for `lib/src/core`** (target 90%) and **90.3% overall** (target 80%). Measure with `fvm flutter test --coverage` and read `coverage/lcov.info`. There is no enforcing gate until CI exists.
- **Added:**
  - `test/core/core_equality_test.dart`: `GaugeScale`/`LinearTrack`/`PainterConfig`/`GaugeDefaults` equality, the edge input of `clamp`/`fractionAt`/`formatGaugeValue`, and theme-driven defaults (light vs dark).
  - `test/widgets/edge_cases_test.dart`, run for every gauge fully configured:
    - value at `min` and at `max` (`min == value == max` is impossible, because `GxGaugeValue` asserts `min < max`);
    - a 0×0 box;
    - fully unbounded constraints in both directions (falls back to 200);
    - a radial gauge with a single bounded side;
    - unmounting mid-animation leaves no ticker;
    - vertical drag and tap mapping;
    - DevTools diagnostics.
- **Layout:** widget tests moved to `test/widgets/` (`smoke_test.dart`, `behavior_test.dart`, `features_test.dart`, `edge_cases_test.dart`).
- **Already covered by Phases 2–3 (unchanged):**
  - `GaugeScale` and tick edge cases.
  - The table-driven model `==`/`copyWith` test.
  - Per-painter `shouldRepaint`.
  - Animation interruption, overshoot and settling.
  - Semantics.
  - Interaction.

---

## 7. Phase 5: README and release

### 7.1 README structure

The target is about 250 lines, down from 1,293. Exhaustive property lists move to the dartdoc API reference, which pub.dev hosts automatically.

1. Title, one-sentence pitch, badges (pub version, CI, coverage, license).
2. Hero screenshot (a GIF of the showcase).
3. Features (5–7 bullets).
4. Install: `flutter pub add gx_gauge`.
5. Quick start: one minimal snippet per gauge (linear progress, stepper, scale, bar, radial), each with a screenshot.
6. Common recipes: ranges, custom needle, animation, interaction, vertical orientation, theming.
7. Migration from `girix_code_gauge` (a link to `doc/MIGRATION.md`).
8. Links to the API reference, example app, contributing guide, changelog, and license.

The README must not contain a manually maintained table of contents (pub.dev and GitHub generate one), wrong defaults, placeholder links, or bold-wrapped headings.

### 7.2 Supporting files

- `CHANGELOG.md` in Keep a Changelog format, starting at `1.0.0`, with a "Moved from girix_code_gauge" note.
- `CONTRIBUTING.md` covering the setup, the test/golden workflow, and commit style (Conventional Commits).
- `.github/ISSUE_TEMPLATE/` (bug report and feature request) and `pull_request_template.md`.
- Screenshots move from `example/assets/images/...` to `doc/screenshots/` and are referenced from the `pubspec.yaml` `screenshots:` field. Keep them under 4 MB total.

### 7.3 Release checklist

1. `dart pub publish --dry-run` passes with 0 warnings, and `pana` scores 160/160.
2. Publish `gx_gauge 1.0.0` **manually** (`flutter pub publish`), because pub.dev only allows automated publishing for existing packages. Then enable automated publishing (tag pattern `v{{version}}`) for later releases.
3. Publish `girix_code_gauge 0.0.7` from the `legacy` branch. It changes only the README and adds a deprecation notice.
4. In the pub.dev admin UI, mark `girix_code_gauge` as discontinued and replaced by `gx_gauge`.
5. Create a GitHub release with notes linking to `MIGRATION.md`.

### Phase 5 progress log

- **README:**
  - Rewritten from 1,293 lines to about 245: pitch, badges, features, install, a quick start per gauge with a screenshot, recipes (ranges, animation, interaction, vertical, custom needle, theming, accessibility), migration, and links.
  - No manual table of contents and no bold headings. Images use relative `doc/screenshots/` paths, which pub.dev resolves through `repository:`.
- **§6.4 (moved here from Phase 4):** every README snippet lives in `example/lib/readme_snippets.dart`, which `flutter analyze` compiles.
- **Screenshots:**
  - 8 PNGs (200 KB total) in `doc/screenshots/`, rendered from those same snippets by `example/tool/screenshots_test.dart`, using Roboto from the Flutter SDK.
  - Listed in the pubspec's `screenshots:`.
  - The outdated README-only images in `example/assets/images/{banner,features/linear,features/radial}` are deleted. The showcase's own thumbnails stay.
- **Rendering fixes found through the screenshots:**
  - Scale-gauge needles and marker needles are now positioned relative to the axis. They used to sit at the edge of the whole widget.
  - A `bottom` needle now sits fully below the track, mirroring `top`.
  - The radial center value moves below the needle's hub when a needle is shown.
  - Radial range labels go inside inward-shifted bands.
- **CHANGELOG:** Keep a Changelog format. The dev pre-releases are consolidated into one `[1.0.0]` entry, and the old `girix_code_gauge` history is kept at the bottom. The version is `1.0.0`.
- **Supporting files:**
  - `CONTRIBUTING.md` covers setup, checks, architecture, tests, the README/screenshot workflow and Conventional Commits.
  - `.github/ISSUE_TEMPLATE/` has bug and feature forms (blank issues disabled), plus `pull_request_template.md`.
  - `docs/RELEASE.md` is a step-by-step owner guide for §7.3.
- **Result:**
  - Analyzer clean; 152 package tests and 3 example tests pass; dartdoc reports 0 warnings.
  - `pub publish --dry-run` is clean apart from the uncommitted-files note.
  - **pana scores 160/160** once the webp tools are installed.
- **Deviations:**
  - The hero image is a static PNG, not a GIF of the showcase. It is deterministic and regenerated by the tool, where a GIF would need a screen recording.
  - The README has no CI or coverage badges, because CI is deferred.
- **Owner actions remaining:** everything in `docs/RELEASE.md`: rename the repo, tag and publish 1.0.0, release `girix_code_gauge` 0.0.7 from a `legacy` branch, mark the old package discontinued, and create the GitHub release.

---

### CI (the item deferred from Phase 0)

- `.github/workflows/ci.yaml` runs two jobs, with the Flutter version read from `.fvmrc`:
  - **Format, analyze, test:** `dart format` (including `tool/` and `example/tool/`), `flutter analyze --fatal-infos` (which also compiles the README snippets), `flutter test --coverage`, the coverage gate `tool/coverage_gate.dart` (core ≥ 90%, overall ≥ 80%, verified to fail below target), and the example tests.
  - **Package health:** `flutter pub publish --dry-run`, then pana with the `webp` tools installed and `--exit-code-threshold 0`, so any lost point fails the build.
- `.github/workflows/publish.yaml` publishes on `v*` tags via OIDC. It checks that the tag matches the pubspec version and runs the tests before publishing. It needs the one-time pub.dev admin setup, and the first release is still manual (`docs/RELEASE.md`).
- Every step was run locally on this commit and passes: the coverage gate reports 98.3% / 90.3%, the clean-tree dry run exits 0, pana exits 0 at 160/160, and the workflow YAML parses.
- Not done: golden tests (§6.3), which can now be added on the Linux runner.

## 8. Execution order and PR slicing

Use one PR per row. Each PR leaves `main` green.

| PR | Content | Depends on |
|---|---|---|
| 1 | Phase 0: lints, SDK, deprecated APIs, deletions, `.gitignore`, CI | none |
| 2 | Characterisation tests for the current math (§2.7) | 1 |
| 3 | Rename to `gx_gauge`, type renames, export surface, migration doc (Phase 1) | 2 |
| 4 | `GaugeScale` core, including unit tests (§4.1, §6.1) | 3 |
| 5 | Immutable models, painter config objects, and `shouldRepaint` tests (§4.2) | 4 |
| 6 | Implicit animations (§4.3) | 5 |
| 7 | Performance, a11y, RTL, theming, Diagnosticable (§4.4–4.5) | 5 |
| 8–12 | Phase 3 features, one PR per group: orientation; ranges and labels; needles and markers; shaders and borders; interaction | 5–7 |
| 13 | Goldens and coverage gate (§6.3) | 8–12 |
| 14 | README, supporting docs, screenshots, snippet compile check (Phase 5) | 13 |
| 15 | Release `1.0.0` and the legacy deprecation release | 14 |

The README is deliberately last: it documents the final API, so writing it earlier would mean rewriting it.

## 9. Risks

| Risk | Mitigation |
|---|---|
| Golden tests fail on different platforms | Run them only on Linux CI, with a bundled font. |
| Existing users are stranded on `girix_code_gauge` | The discontinued/replaced-by flag, the README banner, and `MIGRATION.md` with a name-mapping table. |
| Scope creep in Phase 3 | Every feature has a keep/remove decision up front (§5). Anything new goes to the post-1.0 backlog. |
| Behaviour changes hidden inside refactors | The characterisation tests (PR 2) run before any structural change, and CHANGELOG entries note intentional behaviour changes. |
