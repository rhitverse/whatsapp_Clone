import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/info.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: backgroundColor,
        title: Text(
          "Calls",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_outlined, size: 26),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert_outlined, size: 26),
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Favourites",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: uiColor,
              child: Icon(Icons.add, color: Colors.white, size: 26),
            ),
            title: const Text("Add favourite"),
            onTap: () {},
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Recent",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: info.length,
            itemBuilder: (context, index) {
              final user = info[index];
              final bool isMissed = index % 3 == 1;
              final bool isVideo = index % 3 == 0;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['profilePic']!),
                ),
                title: Text(
                  user['name']!,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isMissed ? Colors.red : Colors.white,
                  ),
                ),
                subtitle: Row(
                  children: [
                    SvgPicture.asset(
                      isMissed
                          ? "assets/svg/missed.svg"
                          : "assets/svg/outgoing.svg",
                      width: 16,
                      height: 16,
                      color: isMissed ? Colors.grey : Colors.grey,
                    ),
                    SizedBox(width: 6),
                    Text(
                      isMissed ? "Missed" : "Outgoing",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user['time']!,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    SvgPicture.asset(
                      "assets/svg/info.svg",
                      color: Colors.white,
                    ),
                  ],
                ),
                onTap: () {},
              );
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, size: 14, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  "Your personal calls are",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  "end-to-end encrypted",
                  style: TextStyle(color: uiColor, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
