import 'package:flutter/material.dart';
import 'package:whatsapp_clone/screens/chat/widget/bubble_tail_painter.dart';

class ReceiverMessage extends StatelessWidget {
  final String text;
  final String time;
  final bool showTail;
  final bool isGrouped;
  const ReceiverMessage({
    super.key,
    required this.text,
    required this.time,
    this.showTail = true,
    this.isGrouped = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isGrouped ? 1 : 4, horizontal: 1),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 8, right: 40, bottom: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF262626),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: showTail
                        ? const Radius.circular(5)
                        : const Radius.circular(20),
                    bottomRight: const Radius.circular(20),
                  ),
                ),
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),

            if (showTail)
              Positioned(
                bottom: 0,
                left: -1,
                child: CustomPaint(
                  painter: BubbleTailPainter(
                    color: const Color(0xFF262626),
                    isMe: false,
                  ),
                  size: const Size(13, 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
