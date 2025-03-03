import 'package:flutter/material.dart';

class BounceAnimation extends StatefulWidget {
  final Widget child;
  final bool isBouncing;

  const BounceAnimation({super.key, required this.child, required this.isBouncing});

  @override
  State<BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1), weight: 1),
    ]).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.bounceOut));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  // creates new instance of same widget
  @override
  void didUpdateWidget(covariant BounceAnimation oldWidget) {
    if (widget.isBouncing && mounted) {
      _animationController.reset();
      _animationController.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
