import 'package:flutter/foundation.dart';

/// Base class for the immutable configuration a gauge painter draws from.
///
/// Subclasses list every field in [props]. Equality compares them in order,
/// with `List` fields compared element-wise, so `shouldRepaint` can simply be
/// `oldDelegate.config != config` and can't forget a field.
///
/// Callbacks compare by identity. Callers should pass stable (top-level or
/// static) functions, otherwise every rebuild repaints.
@immutable
abstract class PainterConfig {
  /// Const constructor for subclasses.
  const PainterConfig();

  /// Every field that affects painting.
  List<Object?> get props;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType || other is! PainterConfig) {
      return false;
    }
    final List<Object?> a = props;
    final List<Object?> b = other.props;
    if (a.length != b.length) {
      return false;
    }
    for (int i = 0; i < a.length; i++) {
      final Object? x = a[i];
      final Object? y = b[i];
      if (x is List<Object?> && y is List<Object?>) {
        if (!listEquals(x, y)) {
          return false;
        }
      } else if (x != y) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(
    props.map((Object? p) => p is List<Object?> ? Object.hashAll(p) : p),
  );
}
