import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _currentIndex = 0;

  String _getPageText() {
    switch (_currentIndex) {
      case 0:
        return "This is Chats";
      case 1:
        return "This is Updates";
      case 2:
        return "This is Communities";
      case 3:
        return "This is Calls";
      default:
        return "";
    }
  }

  Widget _navIcon(IconData icon, int index) {
    final bool isSelected = _currentIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1F3D2B) : Colors.transparent,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
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
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.qr_code_scanner_outlined,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: searchBarColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 26, right: 6),
                    child: Icon(Icons.search, color: Colors.grey),
                  ),
                  hintText: 'Ask Meta AI or Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 11),
                ),
              ),
            ),
          ),
        ),
      ),

      body: Center(
        child: Text(
          _getPageText(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,

        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,

        selectedFontSize: 12,
        unselectedFontSize: 12,

        selectedLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        items: [
          BottomNavigationBarItem(
            icon: _navIcon(Icons.chat, 0),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: _navIcon(Icons.update_outlined, 1),
            label: "Updates",
          ),
          BottomNavigationBarItem(
            icon: _navIcon(Icons.groups_3_outlined, 2),
            label: "Communities",
          ),
          BottomNavigationBarItem(
            icon: _navIcon(Icons.call_outlined, 3),
            label: "Calls",
          ),
        ],
      ),
    );
  }
}
