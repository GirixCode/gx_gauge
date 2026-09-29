enum GxTooltipPosition {
  /// Tooltip position at the top of the gauge
  top,

  /// Tooltip position at the bottom of the gauge
  bottom,
}

enum GxTooltipType {
  /// Shows the tooltip for the gauge
  normal,
}

enum GxElementPosition {
  /// Element position inside the gauge bounds
  ///
  /// Horizontal: bottom of the Gauge.
  ///
  /// Vertical: Left of the Gauge.
  inside,

  /// Element position outside the gauge bounds.
  /// Horizontal: Top of the Gauge.
  ///
  /// Vertical: Right of the Gauge.
  outside,

  /// Element position at the start of the gauge
  ///
  cross,

  /// Element position
  inAndOut,

  /// Element position
  outAndIn,
}

enum GxLabelPosition { topCenter, bottomCenter }

enum GxNeedlePosition {
  top,

  /// Needle position at the start of the gauge
  bottom,

  /// Needle position at the end of the gauge
  center,

  /// Needle position at the center of the gauge
}

/// Enum for the type of needle to be used in the gauge
/// The needle can be a circle, triangle, diamond, rectangle, or a custom shape
enum GxNeedleShape {
  /// Custom needle type such as this ✒
  custom,

  /// Circle needle type such as this ●
  circle,

  /// Triangle needle type such as this ▲
  triangle,

  /// Diamond needle type such as this ◆
  diamond,

  /// Rectangle needle type such as this ■
  rectangle,

  /// Pipe needle type such as this |
  pipe,
}

enum GxRadialElementAlignment {
  /// Allign the ticks at the start of the gauge
  start,

  /// Allign the ticks at the end of the gauge
  end,

  /// Allign the ticks at the center of the gauge
  center,
}

enum GxRadialElementPosition {
  /// Position the ticks to the inside of the gauge
  inside,

  /// Position the ticks to the outside of the gauge
  outside,
}

/// Radial Gause
///
///
///
///
enum GxRadialNeedleShape {
  /// Needle with a line shape
  line,

  /// Needle with a taperedLine (triangle shape)
  taperedLine,
}

enum GxRadialPointerShape { circle, triangle, custom }

enum GxStepperShape {
  /// Stepper shape is a circle shape ●
  circle,

  /// Stepper shape is a rectangle shape ■
  rectangle,

  /// Stepper shape is a diamond shape ✦
  diamond,
}
