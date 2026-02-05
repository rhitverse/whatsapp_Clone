import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class FriendsNewchat extends StatelessWidget {
  const FriendsNewchat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: Icon(Icons.arrow_back_ios, color: whiteColor),
        title: Row(
          children: [
            Text(
              "New Chat",
              style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
