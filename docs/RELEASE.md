# Releasing gx_gauge 1.0.0

These are the owner's steps (PLAN.md §7.3). They are outward-facing, so no automated tool runs them. Do them in order.

## 0. Pre-flight

CI (`.github/workflows/ci.yaml`) runs all of these on every push to `main`, so a green CI run on the release commit covers them. To run them by hand, from the repo root on the release commit with a clean working tree:

```sh
fvm dart format --output=none --set-exit-if-changed lib test example/lib example/test
fvm flutter analyze --fatal-infos
fvm flutter test && (cd example && fvm flutter test)
fvm flutter pub publish --dry-run          # must report 0 warnings
dart pub global run pana --no-warning .    # must score 160/160
```

pana checks the screenshots with the `webp` command-line tools (`brew install webp`). Without them it reports "No such file or directory" and loses 10 points, although pub.dev itself has the tools.

## 1. Rename the GitHub repository (D10)

GitHub → `GirixCode/girix-code-gauge` → Settings → rename it to **`gx-gauge`**. GitHub redirects the old URL.

This must happen first:
- `pubspec.yaml` already points at `https://github.com/GirixCode/gx-gauge`.
- pana's only remaining note is that this URL is unreachable.
- pub.dev resolves the README's relative image links through it.

Update your local remote afterwards:

```sh
git remote set-url public https://github.com/GirixCode/gx-gauge.git
```

## 2. Publish gx_gauge 1.0.0 (manually)

pub.dev can't auto-publish a package that doesn't exist yet, so the first release is published by hand:

```sh
# on main, at the release commit
# CHANGELOG.md: replace "Unreleased" with today's date for [1.0.0]
git tag v1.0.0
git push public main --tags
fvm flutter pub publish
```

Then, on pub.dev → `gx_gauge` → Admin:
- Add the `GirixCode` verified publisher, if you have one.
- Enable automated publishing from GitHub Actions with the tag pattern `v{{version}}`, so that later releases publish when a tag is pushed (`.github/workflows/publish.yaml`). After that, releasing is: bump `version`, date the CHANGELOG entry, push a `vX.Y.Z` tag.

## 3. Final girix_code_gauge release (0.0.7)

Create a `legacy` branch from the last `girix_code_gauge` release and change only the README and version:

```sh
git switch -c legacy c5e74a7        # 0.0.6
```

1. In `pubspec.yaml`, set `version: 0.0.7`.
2. At the top of `README.md`, directly under the title, add:

   ```markdown
   > **This package has moved to [gx_gauge](https://pub.dev/packages/gx_gauge).**
   > `girix_code_gauge` receives no further updates. See the
   > [migration guide](https://github.com/GirixCode/gx-gauge/blob/main/doc/MIGRATION.md).
   ```

3. In `CHANGELOG.md`, add:

   ```markdown
   ## 0.0.7
   - Deprecated: this package has moved to `gx_gauge`.
   ```

Then commit and publish it:

```sh
git commit -am "chore: deprecate in favour of gx_gauge"
git push public legacy
fvm flutter pub publish
```

## 4. Discontinue girix_code_gauge

On pub.dev → `girix_code_gauge` → Admin → **Discontinued**, set *Replaced by* to `gx_gauge`.

## 5. GitHub release

Create a GitHub release for the `v1.0.0` tag:
- Paste the `[1.0.0]` section of `CHANGELOG.md` into the notes.
- Link [doc/MIGRATION.md](../doc/MIGRATION.md) at the top.
