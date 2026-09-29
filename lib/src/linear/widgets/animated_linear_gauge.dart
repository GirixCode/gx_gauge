// lib/src/linear/widgets/animated_progress_linear_gauge.dart

import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class GxAnimatedProgressLinearGauge extends StatefulWidget {
  final double value;
  final GaugeAnimationType animationType;
  final Duration duration;
  final ProgressLinearStyle style;
  final LinearNeedle? needle;
  final void Function(Canvas canvas, Offset position)? customDrawNeedle;
  final bool reverse;
  final bool showLabel;
  final double? height;
  final GaugeLabel? label;
  const GxAnimatedProgressLinearGauge({
    super.key,
    required this.value,
    this.animationType = GaugeAnimationType.linear,
    this.duration = const Duration(milliseconds: 1000),
    required this.style,
    this.needle,
    this.customDrawNeedle,
    this.reverse = false,
    this.showLabel = false,
    this.height,
    this.label,
  });

  @override
  _AnimatedProgressLinearGaugeState createState() =>
      _AnimatedProgressLinearGaugeState();
}

class _AnimatedProgressLinearGaugeState
    extends State<GxAnimatedProgressLinearGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _oldValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return GxProgressLinearGauge(
      value: GaugeValue(value: _animation.value),
      style: widget.style,
      needle: widget.needle,
      customDrawNeedle: widget.customDrawNeedle,
      reverse: widget.reverse,
      showLabel: widget.showLabel,
      height: widget.height,
      label: widget.label,
    );
  }

  @override
  void didUpdateWidget(covariant GxAnimatedProgressLinearGauge oldWidget) {
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
      case GaugeAnimationType.easeIn:
        curve = Curves.easeIn;
        break;
      case GaugeAnimationType.easeOut:
        curve = Curves.easeOut;
        break;
      case GaugeAnimationType.easeInOut:
        curve = Curves.easeInOut;
        break;
      case GaugeAnimationType.bounce:
        curve = Curves.bounceInOut;
        break;
      case GaugeAnimationType.elastic:
        curve = Curves.elasticOut;
        break;
      case GaugeAnimationType.linear:
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
