import 'package:flutter/material.dart';

class FadingCirclesButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final Widget? child;
  final double inset;
  const FadingCirclesButton({
    super.key,
    required this.onPressed,
    required this.color,
    this.child,
    this.inset = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        splashColor: Colors.white.withAlpha(100),
        child: SizedBox.expand(
          child: Circle(
            color: color,
            alpha: 50,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(inset),
              child: Circle(
                color: color,
                alpha: 100,
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.all(inset),
                  child: Circle(
                    color: color,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Circle extends StatelessWidget {
  const Circle({
    super.key,
    required this.color,
    this.alpha = 255,
    this.child,
  });

  final Color color;
  final int alpha;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: ColorTween(end: color.withAlpha(alpha)),
      duration: const Duration(milliseconds: 300),
      builder: (context, animatedColor, child) {
        return Ink(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: animatedColor,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
