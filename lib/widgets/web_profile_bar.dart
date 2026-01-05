import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatsapp_clone/colors.dart';

class WebProfileBar extends StatelessWidget {
  const WebProfileBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.077,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(color: webBackgroundColor),

      child: Row(
        children: [
          const Text(
            "WhatsApp",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              SvgPicture.asset('assets/svg/add2.svg', height: 26, width: 26),

              SizedBox(width: 25),
              Icon(Icons.more_vert, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
