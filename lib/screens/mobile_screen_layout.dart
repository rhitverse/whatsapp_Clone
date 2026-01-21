import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/app/welcome/welcome_page.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_providers.dart';
import 'package:whatsapp_clone/screens/setting_screen.dart';
import 'package:whatsapp_clone/screens/settings/calls/calls_screen.dart';
import 'package:whatsapp_clone/screens/updates/update_screen.dart';
import 'package:whatsapp_clone/widgets/chat_filter_items.dart';
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

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1e2023),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (shouldLogout == true) {
      await ref.read(firebaseAuthProvider).signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: backgroundColor,
              scrolledUnderElevation: 0,
              elevation: 0,
              title: const Text(
                'WhatsApp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
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
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  color: const Color(0xff1e2023),
                  onSelected: (value) {
                    if (value == 'logout') {
                      _handleLogout();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red, size: 20),
                          SizedBox(width: 12),
                          Text('Logout', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(105),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.03,
                        right: width * 0.03,
                        bottom: height * 0.03,
                      ),
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: searchBarColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 6,
                              ),
                              child: SvgPicture.asset(
                                "assets/svg/search_icon.svg",
                              ),
                            ),
                            hintText: 'Ask Gemini AI or Search',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -6),
                      child: const ChatFilterItems(isWeb: false),
                    ),
                  ],
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
