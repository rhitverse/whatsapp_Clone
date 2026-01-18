import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/info.dart';
import 'package:whatsapp_clone/screens/settings/calls/info_screen.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favUser = info[0];
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
      body: Transform.translate(
        offset: Offset(0, -6),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Favourites",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 6),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: uiColor,
                child: Icon(Icons.add, color: Colors.white, size: 26),
              ),
              title: const Text(
                "Add favourite",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 16, right: 6),
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(favUser['profilePic']!),
              ),
              title: Text(
                favUser['name']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              subtitle: Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/outgoing.svg",
                    width: 16,
                    height: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  const Text("Outgoing", style: TextStyle(color: Colors.grey)),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    favUser['time']!,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(width: 12),
                  SvgPicture.asset("assets/svg/info.svg", color: Colors.white),
                ],
              ),
              onTap: () {},
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Recent",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -6),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: info.length,
                itemBuilder: (context, index) {
                  final user = info[index];
                  final bool isMissed = index % 3 == 1;
                  // final bool isVideo = index % 3 == 0;

                  return ListTile(
                    contentPadding: const EdgeInsets.only(left: 16, right: 6),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(user['profilePic']!),
                    ),
                    title: Text(
                      user['name']!,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.5,
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
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const InfoScreen(),
                              ),
                            );
                          },
                          child: SvgPicture.asset(
                            "assets/svg/info.svg",
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {},
                  );
                },
              ),
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
                    " end-to-end encrypted",
                    style: TextStyle(color: uiColor, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
