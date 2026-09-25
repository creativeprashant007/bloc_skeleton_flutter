import 'package:flutter/material.dart';

class ShimmerLine extends StatelessWidget {
  final AnimationController controller;
  final Color base;
  final Color highlight;
  final double width;
  final double height;
  final double radius;

  const ShimmerLine({super.key, 
    required this.controller,
    required this.base,
    required this.highlight,
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment(-1.4 + controller.value * 2.8, -0.4),
              end: Alignment(-0.2 + controller.value * 2.8, 0.4),
              colors: [base, highlight, base],
              stops: const [0.25, 0.5, 0.75],
            ),
          ),
        );
      },
    );
  }
}
