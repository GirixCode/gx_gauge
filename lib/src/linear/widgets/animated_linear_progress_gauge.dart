// lib/src/linear/widgets/animated_progress_linear_gauge.dart

import 'package:flutter/material.dart';
import 'package:gx_gauge/src/common/animations/animation_types.dart';
import 'package:gx_gauge/src/common/models/linear_gauge_common_model.dart';
import 'package:gx_gauge/src/common/utils/typedef.dart';
import 'package:gx_gauge/src/linear/models/linear_gauge_style.dart';
import 'package:gx_gauge/src/linear/models/linear_needle_model.dart';
import 'package:gx_gauge/src/linear/widgets/linear_progress_gauge.dart';

class GxAnimatedLinearProgressGauge extends StatefulWidget {
  const GxAnimatedLinearProgressGauge({
    super.key,
    required this.value,
    this.animationType = GxAnimationType.linear,
    this.duration = const Duration(milliseconds: 1000),
    required this.style,
    this.needle,
    this.needlePainter,
    this.reverse = false,
    this.showLabel = false,
    this.height,
    this.label,
  });
  final double value;
  final GxAnimationType animationType;
  final Duration duration;
  final GxLinearProgressStyle style;
  final GxLinearNeedle? needle;
  final GxNeedlePainter? needlePainter;
  final bool reverse;
  final bool showLabel;
  final double? height;
  final GxGaugeLabel? label;

  @override
  State<GxAnimatedLinearProgressGauge> createState() =>
      _AnimatedProgressLinearGaugeState();
}

class _AnimatedProgressLinearGaugeState
    extends State<GxAnimatedLinearProgressGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _oldValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return GxLinearProgressGauge(
      value: GxGaugeValue(value: _animation.value),
      style: widget.style,
      needle: widget.needle,
      needlePainter: widget.needlePainter,
      reverse: widget.reverse,
      showLabel: widget.showLabel,
      height: widget.height,
      label: widget.label,
    );
  }

  @override
  void didUpdateWidget(covariant GxAnimatedLinearProgressGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.animationType != widget.animationType) {
      _oldValue = oldWidget.value;
      _controller.reset();
      _animation = _createAnimation(_oldValue, widget.value);
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _oldValue = 0;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = _createAnimation(_oldValue, widget.value);
    _controller.forward();
  }

  Animation<double> _createAnimation(double begin, double end) {
    Curve curve;
    switch (widget.animationType) {
      case GxAnimationType.easeIn:
        curve = Curves.easeIn;
        break;
      case GxAnimationType.easeOut:
        curve = Curves.easeOut;
        break;
      case GxAnimationType.easeInOut:
        curve = Curves.easeInOut;
        break;
      case GxAnimationType.bounce:
        curve = Curves.bounceInOut;
        break;
      case GxAnimationType.elastic:
        curve = Curves.elasticOut;
        break;
      case GxAnimationType.linear:
        curve = Curves.linear;
        break;
    }

    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: _controller, curve: curve),
    )..addListener(() {
      setState(() {});
    });
  }
}
