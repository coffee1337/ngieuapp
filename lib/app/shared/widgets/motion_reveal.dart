import 'package:flutter/material.dart';

import 'package:ngieuapp/app/features/settings/data/motion_settings_provider.dart';
import 'package:ngieuapp/app/features/settings/domain/app_motion_style.dart';

class MotionReveal extends StatefulWidget {
  const MotionReveal({required this.child, this.order = 0, super.key});

  final Widget child;
  final int order;

  @override
  State<MotionReveal> createState() => _MotionRevealState();
}

class _MotionRevealState extends State<MotionReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final double _delayFraction;

  @override
  void initState() {
    super.initState();
    final style = AppMotionSettings.currentStyle;
    final motionMillis = style == AppMotionStyle.expressive ? 360 : 240;
    final delayMillis = widget.order.clamp(0, 5) * 28;
    _delayFraction = delayMillis / (motionMillis + delayMillis);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: motionMillis + delayMillis),
      value: style == AppMotionStyle.reduced ? 1 : 0,
    );
    if (style != AppMotionStyle.reduced) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Interval(_delayFraction, 1, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.055),
          end: Offset.zero,
        ).animate(curved),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.985, end: 1).animate(curved),
          child: widget.child,
        ),
      ),
    );
  }
}
