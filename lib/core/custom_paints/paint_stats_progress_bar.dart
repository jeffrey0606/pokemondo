import 'package:flutter/material.dart';

class PaintStatsProgressBar extends CustomPainter {
  final double percentage;
  final Color color;
  final Color bgColor;
  PaintStatsProgressBar({
    required this.percentage,
    required this.color,
    required this.bgColor,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint paintBg = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;

    Paint paintProgress = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
        const Radius.circular(30),
      ),
      paintBg,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0,
          0,
          size.width * percentage,
          size.height,
        ),
        const Radius.circular(30),
      ),
      paintProgress,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}