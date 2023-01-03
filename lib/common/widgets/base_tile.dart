import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseTile extends StatelessWidget {
  const BaseTile(
      {Key? key, this.margin = const EdgeInsets.all(16), this.padding = const EdgeInsets.all(8), required this.child})
      : super(key: key);

  final EdgeInsets margin;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          color: CupertinoColors.black,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
