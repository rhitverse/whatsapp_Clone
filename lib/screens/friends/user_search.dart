import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class UserSearch extends StatelessWidget {
  const UserSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: whiteColor),
        ),
        title: Text("Add friends", style: TextStyle(color: whiteColor)),
      ),
    );
  }
}
