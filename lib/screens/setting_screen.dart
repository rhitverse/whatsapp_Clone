import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/app/welcome/welcome_page.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_providers.dart';
import 'package:whatsapp_clone/screens/settings/account_screen.dart';
import 'package:whatsapp_clone/screens/settings/chats_screen.dart';
import 'package:whatsapp_clone/screens/settings/help_screen.dart';
import 'package:whatsapp_clone/screens/settings/invite_screen.dart';
import 'package:whatsapp_clone/screens/settings/notifications_screen.dart';
import 'package:whatsapp_clone/screens/settings/privacy_screen.dart';
import 'package:whatsapp_clone/screens/settings/profile_screen.dart';
import 'package:whatsapp_clone/screens/settings/starrted_message_screen.dart';
import 'package:whatsapp_clone/screens/settings/storage_screen.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xff1e2023),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
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
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const WelcomePage()),
          (_) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: searchBarColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.green,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 6),
                  child: Icon(Icons.search_rounded, color: Colors.grey),
                ),
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 9.6),
              ),
            ),
          ),
          SizedBox(height: 18),
          _profileTile(context),
          SizedBox(height: 20),

          Text(
            "Personal info",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          SizedBox(height: 2),
          _svgTile(
            "assets/svg/account.svg",
            "Account",
            onTap: () => _go(context, const AccountScreen()),
          ),

          _svgTile(
            "assets/svg/privacy1.svg",
            "Privacy",
            onTap: () => _go(context, const PrivacyScreen()),
          ),

          SizedBox(height: 16),
          Text('General', style: TextStyle(color: Colors.grey, fontSize: 13)),
          _svgTile(
            "assets/svg/notification.svg",
            "Notifications",
            onTap: () => _go(context, const NotificationsScreen()),
          ),

          _svgTile(
            "assets/svg/storage.svg",
            "Storage and data",
            onTap: () => _go(context, const StorageScreen()),
          ),
          _svgTile(
            "assets/svg/chat_icon.svg",
            "Chats",
            onTap: () => _go(context, const ChatsScreen()),
          ),
          _svgTile(
            "assets/svg/call.svg",
            "Call",
            onTap: () => _go(context, const HelpScreen()),
          ),
          _svgTile(
            "assets/svg/friends.svg",
            "Friends",
            onTap: () => _go(context, const StarrtedMessageScreen()),
          ),
          _svgTile(
            "assets/svg/star.svg",
            "Starred messages",
            onTap: () => _go(context, const StarrtedMessageScreen()),
          ),
          _svgTile(
            "assets/svg/help.svg",
            "Help",
            onTap: () => _go(context, const HelpScreen()),
          ),

          _svgTile(
            "assets/svg/invite.svg",
            "Invite a friend",
            onTap: () => _go(context, const InviteScreen()),
          ),

          _svgTile(
            "assets/svg/logout.svg",
            "Logout",
            onTap: () => _handleLogout(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _profileTile(BuildContext context) {
    return InkWell(
      onTap: () => _go(context, const ProfileScreen()),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(
              'https://upload.wikimedia.org/wikipedia/en/thumb/9/91/Mike_Wheeler.png/250px-Mike_Wheeler.png',
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Robin",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  "Dunia ki ma ki chut!",
                  style: TextStyle(color: Colors.white60),
                ),
              ],
            ),
          ),
          Icon(Icons.qr_code, color: uiColor),
        ],
      ),
    );
  }

  Widget _svgTile(String icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: SvgPicture.asset(icon, width: 22, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
    );
  }

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}
