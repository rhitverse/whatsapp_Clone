import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/screens/settings/account_screen.dart';
import 'package:whatsapp_clone/screens/settings/avatar_screen.dart';
import 'package:whatsapp_clone/screens/settings/chats_screen.dart';
import 'package:whatsapp_clone/screens/settings/help_screen.dart';
import 'package:whatsapp_clone/screens/settings/invite_screen.dart';
import 'package:whatsapp_clone/screens/settings/linked_devices.dart';
import 'package:whatsapp_clone/screens/settings/list_screen.dart';
import 'package:whatsapp_clone/screens/settings/notifications_screen.dart';
import 'package:whatsapp_clone/screens/settings/privacy_screen.dart';
import 'package:whatsapp_clone/screens/settings/profile_screen.dart';
import 'package:whatsapp_clone/screens/settings/starrted_message_screen.dart';
import 'package:whatsapp_clone/screens/settings/storage_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverLayoutBuilder(
            builder: (context, constraints) {
              final scrolled = constraints.scrollOffset > 80;

              return SliverAppBar(
                automaticallyImplyLeading: false,
                scrolledUnderElevation: 0,
                titleSpacing: 0,
                backgroundColor: backgroundColor,
                pinned: true,
                floating: false,
                elevation: 0,
                expandedHeight: 160,
                centerTitle: true,

                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: scrolled ? 1.0 : 0.0,
                  child: const Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 38,
                            decoration: BoxDecoration(
                              color: searchBarColor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search",
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10),
              _section([
                SizedBox(height: 6),
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    print("Profile clicked");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/commons/2/22/Joe_Keery_by_Gage_Skidmore.jpg',
                          ),
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Robin",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),

                              Text(
                                "Dunia ki ma ki chut!",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            print("QR clicked");
                          },
                          icon: Icon(Icons.qr_code_outlined, color: uiColor),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Transform.translate(
                  offset: Offset(0, 6),
                  child: _divider(indent: 0.1),
                ),
                _svgTile(
                  "assets/svg/avtar.svg",
                  "Avatar",
                  onTap: () {
                    print("Avtar clicked");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AvatarScreen()),
                    );
                  },
                ),
              ]),
              SizedBox(height: 18),
              _section([
                _svgTile(
                  "assets/svg/list.svg",
                  "List",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ListScreen()),
                    );
                  },
                ),
                _divider(indent: 50),
                _svgTile(
                  "assets/svg/star.svg",
                  "Starred messages",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StarrtedMessageScreen(),
                      ),
                    );
                  },
                ),
                _divider(indent: 50),
                _svgTile(
                  "assets/svg/linked.svg",
                  "Linked devices",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LinkedDevices()),
                    );
                  },
                ),
              ]),
              SizedBox(height: 18),
              _section([
                _svgTile(
                  "assets/svg/account.svg",
                  "Account",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AccountScreen()),
                    );
                  },
                ),
                _divider(indent: 50),
                _svgTile(
                  "assets/svg/privacy1.svg",
                  "Privacy",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                    );
                  },
                ),
                _divider(indent: 50),
                _svgTile(
                  "assets/svg/chat_icon.svg",
                  "Chats",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatsScreen()),
                    );
                  },
                ),
                _divider(indent: 50),
                _svgTile(
                  "assets/svg/notification.svg",
                  "Notifications",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    );
                  },
                ),
                _divider(indent: 50),
                _svgTile(
                  "assets/svg/storage.svg",
                  "Storage and data",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StorageScreen()),
                    );
                  },
                ),
              ]),
              SizedBox(height: 18),
              _section([
                _svgTile(
                  "assets/svg/help.svg",
                  "Help",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HelpScreen()),
                    );
                  },
                ),
                _divider(indent: 50),
                _svgTile(
                  "assets/svg/invite.svg",
                  "Invite a friend",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const InviteScreen()),
                    );
                  },
                ),
              ]),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _section(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Material(
          color: container,
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _svgTile(
    String iconpath,
    String title, {
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.only(left: 16, right: 0),
      leading: SvgPicture.asset(
        iconpath,
        width: 24,
        height: 24,
        color: Colors.white70,
      ),
      title: Text(title),
      textColor: Colors.white,
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Icon(Icons.chevron_right, color: Colors.white),
      ),
    );
  }

  Widget _divider({
    double indent = 56,
    double endIndent = 0,
    double thickness = 1.0,
    Color color = backgroundColor,
  }) {
    return Divider(
      color: color,
      thickness: thickness,
      height: 1,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
