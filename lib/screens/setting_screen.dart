import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_clone/colors.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            titleSpacing: 0,
            backgroundColor: backgroundColor,
            pinned: true,
            floating: false,
            elevation: 0,
            expandedHeight: 160,
            title: const Text(
              "Settings",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
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
                  child: _divider(indent: 1),
                ),
                _svgTile(
                  "assets/svg/avtar.svg",
                  "Avatar",
                  onTap: () {
                    print("Avtar clicked");
                  },
                ),
              ]),
              SizedBox(height: 18),
              _section([
                _svgTile("assets/svg/list.svg", "List", onTap: () {}),
                _divider(indent: 50),
                _svgTile(
                  "assets/svg/star.svg",
                  "Starred messages",
                  onTap: () {},
                ),
                _divider(indent: 50),
                _svgTile(
                  "assets/svg/linked.svg",
                  "Linked devices",
                  onTap: () {},
                ),
              ]),
              SizedBox(height: 18),
              _section([
                _svgTile("assets/svg/account.svg", "Account", onTap: () {}),
                _divider(indent: 50),
                _svgTile("assets/svg/privacy1.svg", "Privacy", onTap: () {}),
                _divider(indent: 50),
                _svgTile("assets/svg/chat_icon.svg", "Chats", onTap: () {}),
                _divider(indent: 50),
                _svgTile(
                  "assets/svg/notification.svg",
                  "Notifications",
                  onTap: () {},
                ),
                _divider(indent: 50),
                _svgTile(
                  "assets/svg/storage.svg",
                  "Storage and data",
                  onTap: () {},
                ),
              ]),
              SizedBox(height: 18),
              _section([
                _svgTile("assets/svg/help.svg", "Help", onTap: () {}),
                _divider(indent: 50),
                _svgTile(
                  "assets/svg/invite.svg",
                  "Invite a friend",
                  onTap: () {},
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
          color: searchBarColor,
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
    double thickness = 0.8,
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
