import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gx_gauge/gx_gauge.dart';

Shader _shader(Rect bounds) =>
    const LinearGradient(colors: <Color>[Colors.red, Colors.blue])
        .createShader(bounds);

/// For each model: a default instance and one variant per field. Every
/// variant must differ from the default, and `copyWith()` with no arguments
/// must return an equal object with the same hash code.
final Map<String, (Object, List<Object>)>
_cases = <String, (Object, List<Object>)>{
  'GxGaugeLabel': (
    const GxGaugeLabel(label: 'a'),
    const <Object>[
      GxGaugeLabel(label: 'b'),
      GxGaugeLabel(label: 'a', style: TextStyle(fontSize: 9)),
      GxGaugeLabel(label: 'a', textAlign: TextAlign.left),
      GxGaugeLabel(label: 'a', offset: Offset(1, 1)),
      GxGaugeLabel(label: 'a', spaceExtent: 2),
    ],
  ),
  'GxGaugeTooltip': (
    const GxGaugeTooltip(),
    const <Object>[
      GxGaugeTooltip(enabled: false),
      GxGaugeTooltip(label: 'x'),
      GxGaugeTooltip(color: Colors.red),
      GxGaugeTooltip(borderColor: Colors.red),
      GxGaugeTooltip(size: Size(1, 1)),
      GxGaugeTooltip(radius: Radius.circular(2)),
      GxGaugeTooltip(position: GxTooltipPosition.bottom),
      GxGaugeTooltip(paintingStyle: PaintingStyle.stroke),
      GxGaugeTooltip(thickness: 9),
      GxGaugeTooltip(offset: 1),
      GxGaugeTooltip(strokeCap: StrokeCap.round),
      GxGaugeTooltip(showPointer: false),
    ],
  ),
  'GxLinearNeedle': (
    const GxLinearNeedle(),
    const <Object>[
      GxLinearNeedle(shape: GxNeedleShape.circle),
      GxLinearNeedle(position: GxNeedlePosition.top),
      GxLinearNeedle(size: Size(1, 2)),
      GxLinearNeedle(color: Colors.red),
      GxLinearNeedle(enabled: false),
      GxLinearNeedle(label: GxNeedleLabel(label: 'n')),
      GxLinearNeedle(offset: 9),
      GxLinearNeedle(strokeCap: StrokeCap.round),
      GxLinearNeedle(paintingStyle: PaintingStyle.stroke),
      GxLinearNeedle(strokeWidth: 9),
    ],
  ),
  'GxLinearProgressStyle': (
    const GxLinearProgressStyle(),
    const <Object>[
      GxLinearProgressStyle(color: Colors.red),
      GxLinearProgressStyle(backgroundColor: Colors.red),
      GxLinearProgressStyle(thickness: 1),
      GxLinearProgressStyle(dense: false),
      GxLinearProgressStyle(radius: Radius.zero),
      GxLinearProgressStyle(strokeCap: StrokeCap.round),
      GxLinearProgressStyle(paintingStyle: PaintingStyle.stroke),
    ],
  ),
  'GxLinearBarPointer': (
    const GxLinearBarPointer(start: 0, end: 10),
    const <Object>[
      GxLinearBarPointer(start: 1, end: 10),
      GxLinearBarPointer(start: 0, end: 11),
      GxLinearBarPointer(start: 0, end: 10, color: Colors.red),
      GxLinearBarPointer(start: 0, end: 10, thickness: 1),
      GxLinearBarPointer(start: 0, end: 10, position: GxElementPosition.inside),
      GxLinearBarPointer(start: 0, end: 10, offset: 2),
      GxLinearBarPointer(start: 0, end: 10, shaderCallback: _shader),
      GxLinearBarPointer(start: 0, end: 10, borderColor: Colors.red),
      GxLinearBarPointer(start: 0, end: 10, borderWidth: 3),
      GxLinearBarPointer(start: 0, end: 10, radius: Radius.zero),
      GxLinearBarPointer(start: 0, end: 10, label: GxGaugeLabel(label: 'b')),
    ],
  ),
  'GxLinearTickStyle': (
    const GxLinearTickStyle(),
    const <Object>[
      GxLinearTickStyle(length: 1),
      GxLinearTickStyle(thickness: 3),
      GxLinearTickStyle(color: Colors.red),
    ],
  ),
  'GxLinearAxisStyle': (
    const GxLinearAxisStyle(),
    const <Object>[
      GxLinearAxisStyle(thickness: 1),
      GxLinearAxisStyle(color: Colors.red),
      GxLinearAxisStyle(strokeCap: StrokeCap.round),
      GxLinearAxisStyle(paintingStyle: PaintingStyle.fill),
    ],
  ),
  'GxLinearRange': (
    const GxLinearRange(start: 0, end: 1),
    const <Object>[
      GxLinearRange(start: 0, end: 2),
      GxLinearRange(start: 0, end: 1, color: Colors.blue),
      GxLinearRange(start: 0, end: 1, thickness: 1),
      GxLinearRange(start: 0, end: 1, position: GxElementPosition.inside),
      GxLinearRange(start: 0, end: 1, offset: 3),
      GxLinearRange(start: 0, end: 1, shaderCallback: _shader),
      GxLinearRange(start: 0, end: 1, borderColor: Colors.red),
      GxLinearRange(start: 0, end: 1, borderWidth: 4),
      GxLinearRange(start: 0, end: 1, radius: Radius.zero),
      GxLinearRange(start: 0, end: 1, label: GxGaugeLabel(label: 'x')),
    ],
  ),
  'GxStepperStep': (
    const GxStepperStep(label: GxGaugeLabel(label: 'a')),
    const <Object>[
      GxStepperStep(label: GxGaugeLabel(label: 'b')),
      GxStepperStep(
        marker: '✓',
        label: GxGaugeLabel(label: 'a'),
      ),
    ],
  ),
  'GxRadialGaugeStyle': (
    const GxRadialGaugeStyle(),
    const <Object>[
      GxRadialGaugeStyle(color: Colors.red),
      GxRadialGaugeStyle(backgroundColor: Colors.red),
      GxRadialGaugeStyle(thickness: 1),
      GxRadialGaugeStyle(strokeCap: StrokeCap.butt),
      GxRadialGaugeStyle(paintingStyle: PaintingStyle.fill),
      GxRadialGaugeStyle(
        gradient: SweepGradient(colors: <Color>[Colors.red, Colors.blue]),
      ),
    ],
  ),
  'GxRadialNeedle': (
    const GxRadialNeedle(),
    const <Object>[
      GxRadialNeedle(color: Colors.red),
      GxRadialNeedle(topOffset: 1),
      GxRadialNeedle(bottomOffset: 1),
      GxRadialNeedle(alignment: GxRadialElementAlignment.end),
      GxRadialNeedle(cap: GxNeedleCap(radius: 9)),
      GxRadialNeedle(thickness: 1),
      GxRadialNeedle(shape: GxRadialNeedleShape.line),
      GxRadialNeedle(strokeCap: StrokeCap.butt),
    ],
  ),
  'GxRadialTickStyle': (
    const GxRadialTickStyle(),
    const <Object>[
      GxRadialTickStyle(length: 1),
      GxRadialTickStyle(thickness: 3),
      GxRadialTickStyle(color: Colors.red),
      GxRadialTickStyle(alignment: GxRadialElementAlignment.start),
      GxRadialTickStyle(position: GxRadialElementPosition.outside),
    ],
  ),
  'GxRadialRange': (
    const GxRadialRange(start: 0, end: 1, label: GxGaugeLabel(label: 'r')),
    const <Object>[
      GxRadialRange(start: 0, end: 2, label: GxGaugeLabel(label: 'r')),
      GxRadialRange(start: 0, end: 1, label: GxGaugeLabel(label: 's')),
      GxRadialRange(
        start: 0,
        end: 1,
        label: GxGaugeLabel(label: 'r'),
        height: 1,
      ),
    ],
  ),
};

Object _copy(Object model) => switch (model) {
  final GxGaugeLabel m => m.copyWith(),
  final GxGaugeTooltip m => m.copyWith(),
  final GxLinearNeedle m => m.copyWith(),
  final GxLinearProgressStyle m => m.copyWith(),
  final GxLinearBarPointer m => m.copyWith(),
  final GxLinearTickStyle m => m.copyWith(),
  final GxLinearAxisStyle m => m.copyWith(),
  final GxLinearRange m => m.copyWith(),
  final GxStepperStep m => m.copyWith(),
  final GxRadialGaugeStyle m => m.copyWith(),
  final GxRadialNeedle m => m.copyWith(),
  final GxRadialTickStyle m => m.copyWith(),
  final GxRadialRange m => m.copyWith(),
  _ => throw ArgumentError(model),
};

void main() {
  for (final MapEntry<String, (Object, List<Object>)> entry in _cases.entries) {
    final (Object base, List<Object> variants) = entry.value;
    group(entry.key, () {
      test('copyWith() returns an equal object', () {
        final Object copy = _copy(base);
        expect(copy, base);
        expect(copy.hashCode, base.hashCode);
      });

      test('every field takes part in ==', () {
        for (final Object variant in variants) {
          expect(variant, isNot(base), reason: '$variant');
          expect(_copy(variant), variant, reason: 'copyWith() of $variant');
        }
      });
    });
  }

  test('GxRadialTickStyle.copyWith keeps alignment and position', () {
    const GxRadialTickStyle style = GxRadialTickStyle(
      alignment: GxRadialElementAlignment.end,
      position: GxRadialElementPosition.outside,
    );
    final GxRadialTickStyle copy = style.copyWith(length: 20);
    expect(copy.alignment, GxRadialElementAlignment.end);
    expect(copy.position, GxRadialElementPosition.outside);
    expect(copy.length, 20);
  });

  test('models are Diagnosticable', () {
    expect(
      const GxLinearNeedle(color: Colors.red).toString(),
      contains('color'),
    );
  });
}
