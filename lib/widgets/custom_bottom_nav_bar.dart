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

  Widget navIcon({
    required String unselectedAsset,
    required String selectedAsset,
    required int index,
    double size = 24,
  }) {
    final bool isSelected = currentIndex == index;

    return SvgPicture.asset(
      isSelected ? selectedAsset : unselectedAsset,
      width: size,
      height: size,
      colorFilter: const ColorFilter.mode(whiteColor, BlendMode.srcIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: whiteColor,
        unselectedItemColor: whiteColor,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            icon: navIcon(
              unselectedAsset: 'assets/svg/chat2.svg',
              selectedAsset: 'assets/svg/chats2.svg',
              index: 0,
              size: 25,
            ),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: navIcon(
              unselectedAsset: 'assets/svg/update3.svg',
              selectedAsset: 'assets/svg/update2.svg',
              index: 1,
              size: 26,
            ),
            label: "Updates",
          ),
          BottomNavigationBarItem(
            icon: navIcon(
              unselectedAsset: 'assets/svg/meet.svg',
              selectedAsset: 'assets/svg/groups2.svg',
              index: 2,
              size: 26,
            ),
            label: "Meet",
          ),
          BottomNavigationBarItem(
            icon: navIcon(
              unselectedAsset: 'assets/svg/call.svg',
              selectedAsset: 'assets/svg/call1.svg',
              index: 3,
              size: 26,
            ),
            label: "Calls",
          ),
          BottomNavigationBarItem(
            icon: navIcon(
              unselectedAsset: 'assets/svg/setting.svg',
              selectedAsset: 'assets/svg/settings2.svg',
              index: 4,
              size: 25,
            ),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
