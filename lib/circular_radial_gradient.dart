import 'dart:math';

import 'package:flutter/material.dart';


class CircularRadialGradient extends StatefulWidget {
  final double size;
  final Animation<double> rotateAnimation;
  final ColorTween colorTween;
  const CircularRadialGradient({
    Key? key,
    required this.size,
    required this.rotateAnimation,
    required this.colorTween,
  }) : super(key: key);

  @override
  State<CircularRadialGradient> createState() => _CircularRadialGradientState();
}

class _CircularRadialGradientState extends State<CircularRadialGradient> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: widget.rotateAnimation,
      child: Transform.rotate(
        angle: pi / 2,
        child: TweenAnimationBuilder(
          tween: widget.colorTween,
          duration: const Duration(milliseconds: 800),
          builder: (ctx, Color? color, _) => ShaderMask(
            shaderCallback: (rect) {
              return SweepGradient(startAngle: pi, endAngle: pi * 2, colors: [
                color ?? Colors.black,
                Colors.white,
              ]).createShader(rect);
            },
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
