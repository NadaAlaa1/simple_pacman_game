import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  const Pixel({
    super.key,
    this.innerColor,
    this.outerColor,
    this.child,
  });

  final Color? innerColor;
  final Color? outerColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(4),
          color: outerColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4), //10
            child: Container(
              color: innerColor,
              child: Center(
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
