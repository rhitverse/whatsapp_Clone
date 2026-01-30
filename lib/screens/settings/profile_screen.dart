import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/screens/Profile/bio_screen.dart';
import 'package:whatsapp_clone/screens/Profile/display_edit_screen.dart';
import 'package:whatsapp_clone/screens/Profile/qr_screen.dart';
import 'package:whatsapp_clone/screens/Profile/username_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 66,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: 62,
                        backgroundImage: AssetImage("assets/profile.jpg"),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 12,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              _tile(
                "Display name",
                onTap: () => _go(context, const DisplayEditScreen()),
              ),
              _tile("Bio", onTap: () => _go(context, const BioScreen())),

              SizedBox(height: 4),
              InkWell(
                onTap: () => _go(context, const QrScreen()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: const [
                      Text(
                        "My QR code",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Spacer(),
                      Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              const Divider(),

              _tile(
                "MINE ID",
                onTap: () => _go(context, const UsernameScreen()),
              ),
              SizedBox(height: 12),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Allow others to add me by ID",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Others can add you as a friend searching your ID",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
                trailing: Switch(
                  value: false,
                  onChanged: (_) {},
                  activeThumbColor: uiColor,
                ),
              ),
              SizedBox(height: 10),
              const Divider(),
              SizedBox(height: 6),
              InkWell(
                onTap: () => _go(context, const QrScreen()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: const [
                      Text(
                        "Birthday",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Spacer(),
                      Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(String title, {VoidCallback? onTap, bool showNotSet = true}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
      subtitle: showNotSet
          ? const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                "Not set",
                style: TextStyle(color: Colors.grey, fontSize: 17),
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}
