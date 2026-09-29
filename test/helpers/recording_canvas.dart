import 'dart:ui';

/// A [Canvas] that records every call instead of drawing.
///
/// Painters under test draw into this canvas, and tests then assert on the
/// recorded [Invocation]s, e.g. the sweep angle passed to `drawArc`.
class RecordingCanvas implements Canvas {
  final List<Invocation> calls = <Invocation>[];

  /// All recorded calls to the canvas method named [name].
  Iterable<Invocation> callsTo(String name) =>
      calls.where((Invocation i) => i.memberName == Symbol(name));

  @override
  Object? noSuchMethod(Invocation invocation) {
    calls.add(invocation);
    return null;
  }
}
