/// Customizable linear and radial gauges for Flutter.
///
/// Import this library to use every gauge widget and its style models.
// The library name works around a dartdoc 9.0.x stack overflow that occurs
// when this barrel uses an unnamed `library;` directive. Remove the name once
// dartdoc is fixed (tracked in docs/PLAN.md, Phase 2).
// ignore: unnecessary_library_name
library girix_code_gauge;

// Common exports
export 'src/common/animations/animations.dart';
export 'src/common/models/models.dart';
// Linear gauge exports
export 'src/linear/models/models.dart';
export 'src/linear/painters/painters.dart';
export 'src/linear/widgets/widgets.dart';
// Radial gauge exports
export 'src/radial/models/models.dart';
export 'src/radial/painters/painters.dart';
export 'src/radial/widgets/widgets.dart';
