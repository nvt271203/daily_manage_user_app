import 'package:flutter/material.dart';
import 'dart:math';


class Temp extends StatelessWidget {
  const Temp({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient nền
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF8A80F2), // Xanh tím
                Color(0xFFF296E0), // Hồng nhạt
                Color(0xFFEAF6FC), // Nền nhạt phía dưới
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.3, 0.7],
            ),
          ),
        ),

        // Vẽ sóng trắng
        CustomPaint(
          size: Size.infinite,
          painter: WhiteWavePainter(),
        ),

        // Các vòng tròn, đường tròn trắng
        Positioned.fill(
          child: CustomPaint(
            painter: CosmicPainter(),
          ),
        ),
      ],
    );
  }
}

class WhiteWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    final path = Path();
    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(
        size.width * 0.2, size.height * 0.07, size.width * 0.5, size.height * 0.2);
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.33, size.width, size.height * 0.2);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CosmicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final dotPaint = Paint()..color = Colors.white;

    // Vòng tròn ngoài cùng bên phải
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.9, size.height * 0.1), radius: 100),
      pi,
      pi / 2,
      false,
      linePaint,
    );

    // Vòng tròn bên trái
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.2, size.height * 0.1), radius: 80),
      -pi / 2,
      pi / 1.5,
      false,
      linePaint,
    );

    // Vòng tròn nhỏ hơn bên phải
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.12), 10, linePaint);
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.12), 3, dotPaint);

    // Dot phía trên
    canvas.drawCircle(Offset(size.width * 0.82, size.height * 0.06), 4, dotPaint);

    // Dot nhỏ giữa vòng tròn trái
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.12), 4, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.26, size.height * 0.08), 3, dotPaint);

    // Đường nối dot trái
    final path = Path();
    path.moveTo(size.width * 0.26, size.height * 0.08);
    path.quadraticBezierTo(
      size.width * 0.28,
      size.height * 0.10,
      size.width * 0.3,
      size.height * 0.12,
    );
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
