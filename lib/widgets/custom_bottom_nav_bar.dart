import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_clone/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget navSvgIcon(
    String assetPath,
    int index, {
    double width = 24,
    double height = 24,
  }) {
    final bool isSelected = currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1F3D2B) : Colors.transparent,
        borderRadius: BorderRadius.circular(40),
      ),
      child: SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }

  Widget _navIcon(IconData icon, int index, {double size = 24}) {
    final bool isSelected = currentIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1F3D2B) : Colors.transparent,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Icon(icon, color: Colors.white, size: size),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
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
          icon: navSvgIcon('assets/svg/chat2.svg', 0, width: 25, height: 25),
          label: "Chats",
        ),
        BottomNavigationBarItem(
          icon: navSvgIcon('assets/svg/update3.svg', 1, width: 20, height: 20),
          label: "Updates",
        ),
        BottomNavigationBarItem(
          icon: navSvgIcon('assets/svg/meet.svg', 2, width: 26, height: 26),
          label: "Meet",
        ),
        BottomNavigationBarItem(
          icon: _navIcon(Icons.call_outlined, 3),
          label: "Calls",
        ),
        BottomNavigationBarItem(
          icon: navSvgIcon("assets/svg/setting.svg", 4, width: 25, height: 25),
          label: "Settings",
        ),
      ],
    );
  }
}
