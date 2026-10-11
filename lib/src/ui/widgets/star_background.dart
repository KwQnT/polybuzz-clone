import 'dart:math';
import 'package:flutter/material.dart';

class StarBackground extends StatelessWidget {
  final Widget child;
  const StarBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Градиент
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.3, -0.8),
              radius: 1.4,
              colors: [Color(0xFF2A1A4D), Color(0xFF0E0E12)],
            ),
          ),
        ),
        // Звёзды
        Positioned.fill(child: CustomPaint(painter: _StarPainter())),
        // Контент
        child,
      ],
    );
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rand = Random(42);
    final paint = Paint()..color = Colors.white;
    for (int i = 0; i < 80; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height * 0.6;
      final r = rand.nextDouble() * 1.5 + 0.3;
      final opacity = rand.nextDouble() * 0.6 + 0.2;
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
