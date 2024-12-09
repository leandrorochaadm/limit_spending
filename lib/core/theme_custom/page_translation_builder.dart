import 'package:flutter/material.dart';

class PageTransitionBuilderCustom extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const curve = Curves.easeInOut;

    // Define transitions
    final opacityAnimation = CurvedAnimation(parent: animation, curve: curve);
    final scaleAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 1, curve: curve),
    );
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1), // Slide from bottom
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: curve));

    return FadeTransition(
      opacity: opacityAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      ),
    );
  }
}
