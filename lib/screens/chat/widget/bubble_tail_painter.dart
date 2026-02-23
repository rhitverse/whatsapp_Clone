import 'package:flutter/material.dart';

class BubbleTailPainter extends CustomPainter {
  final Color color;
  final bool isMe;

  BubbleTailPainter({required this.color, required this.isMe});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isMe) {
      path.moveTo(4, 4);
      path.quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.9,
        size.width * 1.2,
        size.height * 1.2,
      );
      path.lineTo(0, size.height - 2);
      path.close();
    } else {
      path.moveTo(size.width - 4, 4);
      path.quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.9,
        -size.width * 0.2,
        size.height * 1.2,
      );
      path.lineTo(size.width, size.height - 2);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
