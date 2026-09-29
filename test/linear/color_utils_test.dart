import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:girix_code_gauge/src/linear/utils/color_utils.dart';

void main() {
  const Color base = Color(0xFF3366CC);

  group('ColorUtils', () {
    test('shadeColor darkens each channel towards black', () {
      final Color shaded = ColorUtils.shadeColor(base, 0.5);
      expect(shaded.r, closeTo(base.r * 0.5, 1e-6));
      expect(shaded.g, closeTo(base.g * 0.5, 1e-6));
      expect(shaded.b, closeTo(base.b * 0.5, 1e-6));
      expect(shaded.a, 1);
      expect(ColorUtils.shadeColor(base, 1).toARGB32(), 0xFF000000);
    });

    test('tintColor lightens each channel towards white', () {
      final Color tinted = ColorUtils.tintColor(base, 0.5);
      expect(tinted.r, closeTo(base.r + (1 - base.r) * 0.5, 1e-6));
      expect(ColorUtils.tintColor(base, 1).toARGB32(), 0xFFFFFFFF);
    });

    test('factor 0 leaves the color unchanged', () {
      expect(ColorUtils.shadeColor(base, 0).toARGB32(), base.toARGB32());
      expect(ColorUtils.tintColor(base, 0).toARGB32(), base.toARGB32());
    });

    test('getMaterialColor uses the base color as shade 500', () {
      final MaterialColor swatch = ColorUtils.getMaterialColor(base);
      expect(swatch.shade500.toARGB32(), base.toARGB32());
      expect(swatch.toARGB32(), base.toARGB32());
      expect(
        swatch.shade50.computeLuminance(),
        greaterThan(swatch.shade900.computeLuminance()),
      );
    });
  });
}
