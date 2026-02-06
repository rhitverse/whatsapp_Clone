import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class QrBottomNav extends StatelessWidget {
  final TabController contoller;
  const QrBottomNav({super.key, required this.contoller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 120,
        decoration: const BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: TabBar(
          controller: contoller,
          tabs: const [
            Tab(text: "Scan QR code"),
            Tab(text: "My QR code"),
          ],
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.teal, width: 3),
          ),
        ),
      ),
    );
  }
}
