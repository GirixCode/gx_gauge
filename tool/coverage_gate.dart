// Fails when line coverage in coverage/lcov.info is below the targets from
// docs/PLAN.md §6: lib/src/core ≥ 90% and the whole package ≥ 80%.
//
//   fvm flutter test --coverage && dart run tool/coverage_gate.dart

import 'dart:io';

const double _coreTarget = 90;
const double _overallTarget = 80;

void main(List<String> args) {
  final File lcov = File(args.isEmpty ? 'coverage/lcov.info' : args.first);
  if (!lcov.existsSync()) {
    stderr.writeln('No ${lcov.path}; run `flutter test --coverage` first.');
    exit(2);
  }

  int total = 0;
  int hit = 0;
  int coreTotal = 0;
  int coreHit = 0;
  bool inCore = false;
  for (final String line in lcov.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      inCore = line.contains('lib/src/core/');
    } else if (line.startsWith('DA:')) {
      final bool covered = int.parse(line.substring(3).split(',')[1]) > 0;
      total++;
      if (covered) {
        hit++;
      }
      if (inCore) {
        coreTotal++;
        if (covered) {
          coreHit++;
        }
      }
    }
  }

  double pct(int h, int t) => t == 0 ? 100 : 100 * h / t;
  final double overall = pct(hit, total);
  final double core = pct(coreHit, coreTotal);
  stdout
    ..writeln(
      'lib/src/core: ${core.toStringAsFixed(1)}% (target $_coreTarget%)',
    )
    ..writeln(
      'overall:      ${overall.toStringAsFixed(1)}% (target $_overallTarget%)',
    );

  if (core < _coreTarget || overall < _overallTarget) {
    stderr.writeln('Coverage is below target.');
    exit(1);
  }
}
