import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_clone/colors.dart';
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
    UpdateScreen(),
    Center(
      child: Text("Groups", style: TextStyle(color: Colors.white)),
    ),
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
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      debugPrint("Circular icon tapped");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: SvgPicture.asset(
                        "assets/svg/circular.svg",
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    width * 0.03,
                    0,
                    width * 0.03,
                    8,
                  ),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: searchBarColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 6),
                          child: SvgPicture.asset("assets/svg/search_icon.svg"),
                        ),
                        hintText: 'Ask Gemini AI or Search',
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
