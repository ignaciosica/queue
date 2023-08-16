import 'package:flutter/material.dart';

class CustomAnimatedIcon extends StatelessWidget {
  const CustomAnimatedIcon(
      {Key? key, required this.iconA, required this.iconB, required this.showA})
      : super(key: key);
  final Widget iconA;
  final Widget iconB;
  final bool showA;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) => RotationTransition(
        turns: child.key == iconA.key
            ? Tween<double>(begin: 0.5, end: 1).animate(anim)
            : Tween<double>(begin: 1.5, end: 1).animate(anim),
        child: ScaleTransition(scale: anim, child: child),
      ),
      child: showA ? iconA : iconB,
    );
  }
}
