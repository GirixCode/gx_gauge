/// Where a tooltip sits relative to a linear gauge.
enum GxTooltipPosition {
  /// Above the gauge.
  top,

  /// Below the gauge.
  bottom,
}

/// The kind of tooltip a linear gauge shows.
enum GxTooltipType {
  /// A bubble with the value, optionally connected to the gauge by a pointer
  /// line (see `GxGaugeTooltip.showPointer`).
  normal,
}

/// Where ticks (and, opposite to them, bars) sit relative to a linear axis.
enum GxElementPosition {
  /// Ticks below the axis. Bars are drawn above it.
  inside,

  /// Ticks above the axis. Bars are drawn below it.
  outside,

  /// Ticks cross the axis, centered on it. Bars are centered on the axis.
  cross,

  /// Alternating: even ticks below the axis, odd ticks above it.
  inAndOut,

  /// Alternating: even ticks above the axis, odd ticks below it.
  outAndIn,
}

/// Where a linear scale's tick labels sit.
enum GxLabelPosition {
  /// Centered above each major tick.
  topCenter,

  /// Centered below each major tick.
  bottomCenter,
}

/// Where a linear gauge's needle sits vertically.
enum GxNeedlePosition {
  /// Above the track.
  top,

  /// Below the track.
  bottom,

  /// Centered on the track.
  center,
}

/// The shape of a linear gauge's needle.
enum GxNeedleShape {
  /// Drawn by the gauge's `needlePainter` callback.
  custom,

  /// A circle ●, `size.width` in diameter.
  circle,

  /// A triangle ▲, `size.width` wide and tall.
  triangle,

  /// A diamond ◆, `size.width` wide and tall.
  diamond,

  /// A rectangle ■ of `size`.
  rectangle,

  /// A thin bar |, `size.width` wide and `size.height` tall.
  pipe,
}

/// How a radial element aligns across the thickness of the gauge arc.
enum GxRadialElementAlignment {
  /// Starts at the arc's outer edge.
  start,

  /// Starts at the arc's inner edge.
  end,

  /// Centered on the arc's center line.
  center,
}

/// Which side of the radial arc an element is drawn on.
enum GxRadialElementPosition {
  /// Towards the center of the gauge.
  inside,

  /// Away from the center of the gauge.
  outside,
}

/// The shape of a radial gauge's needle.
enum GxRadialNeedleShape {
  /// A straight line of the needle's thickness.
  line,

  /// A kite shape that tapers from the center to the tip.
  taperedLine,
}

/// The marker shape of a radial pointer.
enum GxRadialPointerShape {
  /// A circle on the arc.
  circle,

  /// A triangle pointing at the arc.
  triangle,
}

/// The marker shape of each step on a stepper gauge.
enum GxStepperShape {
  /// A circle ●.
  circle,

  /// A square ■.
  rectangle,

  /// A diamond ◆.
  diamond,
}
