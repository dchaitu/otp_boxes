import 'package:flutter/material.dart';

class DanceAnimation extends StatefulWidget {
  final Widget child;
  final bool isDancing;
  final int delay;

  const DanceAnimation(
      {super.key, required this.child, required this.isDancing, required this.delay});

  @override
  State<DanceAnimation> createState() => _DanceAnimationState();
}

class _DanceAnimationState extends State<DanceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _animation = TweenSequence<Offset>([
      TweenSequenceItem(tween: Tween(begin: const Offset(0, 0), end: const Offset(0, -0.8)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: const Offset(0, -0.8), end: const Offset(0, 0)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: const Offset(0, 0), end: const Offset(0, -0.3)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: const Offset(0, -0.3), end: const Offset(0, 0)), weight: 1),
    ]).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DanceAnimation oldWidget) {
    if(widget.isDancing)
      {
        Future.delayed(Duration(milliseconds: widget.delay), () {
          if(mounted) {
            _animationController.forward();
          }

        });
      }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,

    );
  }
}
