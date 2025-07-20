import 'dart:math';

import 'package:flutter/material.dart';
class ArcPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double sweepAngle; // Góc vẽ bao nhiêu radian (pi = 180 độ)

  ArcPainter({required this.color, required this.strokeWidth, required this.sweepAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final startAngle = - pi / 2;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
