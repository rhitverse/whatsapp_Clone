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
            color: whiteColor,
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
                  color: whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 6),

            ListTile(
              contentPadding: const EdgeInsets.only(left: 16, right: 6),
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  favUser['profilePic']?.toString() ?? '',
                ),
              ),
              title: Text(
                favUser['name']?.toString() ?? '',
                style: const TextStyle(
                  color: whiteColor,
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
                    favUser['time']?.toString() ?? '',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(width: 12),
                  SvgPicture.asset("assets/svg/info.svg", color: whiteColor),
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
                  color: whiteColor,
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

                  return ListTile(
                    contentPadding: const EdgeInsets.only(left: 16, right: 6),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        user['profilePic']?.toString() ?? '',
                      ),
                    ),
                    title: Text(
                      user['name']?.toString() ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.5,
                        color: isMissed ? Colors.red : whiteColor,
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
                          user['time']?.toString() ?? '',
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
                            color: whiteColor,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
