import 'dart:math';

import 'package:flutter/material.dart';

class RotatingTileWidget extends StatefulWidget {
  final Widget Function(double flipValue) childBuilder;
  final bool shouldRotate;
  final Duration duration;
  final double delay;

  const RotatingTileWidget({
    Key? key,
    required this.childBuilder, // Update to use the builder function
    required this.shouldRotate,
    required this.duration,
    required this.delay,
  }) : super(key: key);

  @override
  _RotatingTileWidgetState createState() => _RotatingTileWidgetState();
}

class _RotatingTileWidgetState extends State<RotatingTileWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
  }

  late final Animation<double> _animation = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: _controller, curve: const Interval(
        0, 1, curve: Curves.easeInOut),
    ),
  );

  @override
  void didUpdateWidget(RotatingTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.shouldRotate && !_controller.isAnimating) {
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double flipValue = (_animation.value > 0.5) ? pi : 0;
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003) // Perspective effect
            ..rotateX(_animation.value * pi + flipValue),
          alignment: Alignment.center,
          child: widget.childBuilder(_animation.value), // Pass `flipValue` to the builder
        );
      },
    );
  }
}
