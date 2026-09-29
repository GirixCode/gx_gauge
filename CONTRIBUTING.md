# Contributing to gx_gauge

Thanks for helping! Bug reports, fixes and features are all welcome.

## Setup

The Flutter version is pinned in [`.fvmrc`](.fvmrc). Use [fvm](https://fvm.app) so everyone builds with the same SDK:

```sh
fvm install
fvm flutter pub get
(cd example && fvm flutter pub get)
```

## Before opening a pull request

Run the same checks the maintainers run:

```sh
fvm dart format lib test example/lib example/test
fvm flutter analyze --fatal-infos      # must report "No issues found!"
fvm flutter test                       # package tests
(cd example && fvm flutter test)       # example app tests
fvm flutter pub publish --dry-run      # package validation
```

Coverage targets are ≥ 90% for `lib/src/core` and ≥ 80% overall (`fvm flutter test --coverage`).

## How the code is organised

- `lib/gx_gauge.dart` is the only public library. It lists every public symbol explicitly, so add new public types there.
- Each gauge follows the same pipeline:
  1. **Widget** (`lib/src/*/widgets/`). An `ImplicitlyAnimatedWidget` that resolves theme defaults and builds an immutable config.
  2. **Config** (`*PainterConfig`). It lists every drawn field in `props`, and `shouldRepaint` compares the whole config.
  3. **Painter.** It does all value→position math through `GaugeScale`/`LinearTrack` (`lib/src/core/`).
- Models are immutable, with `copyWith`, `==`/`hashCode` and diagnostics. When you add a field, add a row for it to `test/models/model_equality_test.dart`.
- Every public member needs a doc comment (`public_member_api_docs` is on).
- Don't add parameters that aren't wired to rendering.

## Tests

- Painter tests draw into a recording canvas (`test/helpers/recording_canvas.dart`) and assert on the recorded calls.
- Widget tests live in `test/widgets/`. `edge_cases_test.dart` runs every gauge through the size and value edge cases, so add new gauges or major options to it.
- A known bug gets a test marked `skip: 'Known bug …'` until it's fixed.

## README and screenshots

- Every README code block comes from [`example/lib/readme_snippets.dart`](example/lib/readme_snippets.dart), which `flutter analyze` compiles.
- The screenshots in `doc/screenshots/` are rendered from those snippets. After changing a snippet or anything visual, regenerate them:

```sh
cd example && fvm flutter test tool/screenshots_test.dart
```

## Commits and changes

- Use [Conventional Commits](https://www.conventionalcommits.org/), e.g. `fix: clamp radial needle angle`.
- Record user-visible changes under an `Unreleased` heading in [CHANGELOG.md](CHANGELOG.md). Breaking changes also go in [doc/MIGRATION.md](doc/MIGRATION.md).
