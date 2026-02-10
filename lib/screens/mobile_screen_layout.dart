import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/screens/Notifications/notification_screen.dart';
import 'package:whatsapp_clone/screens/friends/friends_newchat.dart';
import 'package:whatsapp_clone/screens/friends/qr_scanner.dart';
import 'package:whatsapp_clone/screens/friends/user_search.dart';
import 'package:whatsapp_clone/screens/meet/empty_server_screen.dart';
import 'package:whatsapp_clone/screens/setting_screen.dart';
import 'package:whatsapp_clone/screens/settings/calls/calls_screen.dart';
import 'package:whatsapp_clone/screens/updates/update_screen.dart';
import 'package:whatsapp_clone/widgets/contacts_list.dart';
import 'package:whatsapp_clone/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ContactsList(),
    EmptyServerScreen(),
    CallsScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: backgroundColor,
              scrolledUnderElevation: 0,
              elevation: 0,
              title: const Text(
                'Chats',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 40),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificaionScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.notifications_outlined,
                    size: 28,
                    color: whiteColor,
                  ),
                ),
                SizedBox(width: 2),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 40),
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UserSearch()),
                      );
                    });
                  },
                  icon: SvgPicture.asset(
                    "assets/svg/adduser.svg",
                    width: 29,
                    color: whiteColor,
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(35),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    width * 0.03,
                    0,
                    width * 0.03,
                    1,
                  ),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: searchBarColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      style: const TextStyle(color: whiteColor),
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(right: 15, left: 17),
                          child: SvgPicture.asset(
                            "assets/svg/search_icon.svg",
                            width: 20,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const QrScanner(),
                                ),
                              );
                            },
                            icon: SvgPicture.asset(
                              "assets/svg/scan.svg",
                              width: 20,
                              color: whiteColor,
                            ),
                          ),
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 9.6),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: IndexedStack(index: _currentIndex, children: _pages),

      floatingActionButton: _currentIndex == 0
          ? GestureDetector(
              onTap: () {
                print("clicked $GestureDetector");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FriendsNewchat()),
                );
              },
              child: Container(
                height: 58,
                width: 57,
                decoration: BoxDecoration(
                  color: uiColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SvgPicture.asset(
                    "assets/svg/newchat.svg",
                    width: 36,
                    color: whiteColor,
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
