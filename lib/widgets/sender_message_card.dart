import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  const SenderMessageCard({
    super.key,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 1),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          decoration: BoxDecoration(
            color: senderMessageColor,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 55, 18),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 6,
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
