import 'dart:math';

import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  final double width;
  final double height;

  const Loader({
    Key? key,
    this.height = 50,
    this.width = 50,
  }) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  late Tween scaleTween;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      reverseDuration: const Duration(milliseconds: 300),
    );
    scaleTween = Tween<double>(begin: 1, end: 0);

    animation = scaleTween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );

    controller.repeat(
      reverse: true,
      period: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.rotate(
            angle: (pi / 2) * animation.value,
            child: Transform.scale(
              scale: animation.value,
              child: child,
            ),
          ),
        );
      },
      child: Center(
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: Image.asset(
            "assets/images/pokeball.png",
          ),
        ),
      ),
    );
  }
}
