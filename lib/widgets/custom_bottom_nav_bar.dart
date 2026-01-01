import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _navIcon(IconData icon, int index) {
    final bool isSelected = currentIndex == index;

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
        BottomNavigationBarItem(icon: _navIcon(Icons.chat, 0), label: "Chats"),
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
    );
  }
}
