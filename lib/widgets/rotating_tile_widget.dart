import 'dart:math';

import 'package:flutter/material.dart';

class RotatingTileWidget extends StatefulWidget {
  final Widget child;
  final bool shouldRotate;

  const RotatingTileWidget({
    Key? key,
    required this.child,
    required this.shouldRotate,
  }) : super(key: key);

  @override
  State<RotatingTileWidget> createState() => _RotatingTileWidgetState();
}

class _RotatingTileWidgetState extends State<RotatingTileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), // Adjust duration
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant RotatingTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger rotation if `shouldRotate` is true
    if (widget.shouldRotate && !_controller.isAnimating) {
      _controller.forward().then((_) {
        _controller.reverse(); // Optional: reverse the animation
      });
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
        double flip =0;
        if(_animation.value>0.50){
          flip = pi;
        }

        return Transform(
          transform: Matrix4.identity()
          ..setEntry(3, 2, 0.003)
          ..rotateX(_animation.value *pi)
          ..rotateX(flip),

          alignment: Alignment.center,
          child: widget.child,
        );
      },
    );
  }
}
