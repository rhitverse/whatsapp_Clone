import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/widgets/chat_filter_items.dart';
import 'package:whatsapp_clone/widgets/contacts_list.dart';
import 'package:whatsapp_clone/widgets/web_profile_bar.dart';
import 'package:whatsapp_clone/widgets/web_search_bar.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: webBackgroundColor,
      body: Row(
        children: [
          // ✅ LEFT ICON BAR
          Container(
            width: 70,
            color: const Color(0xFF1d1f1f),
            child: Column(
              children: const [
                SizedBox(height: 20),
                Icon(Icons.chat, color: Colors.white),
                SizedBox(height: 25),
                Icon(Icons.update_outlined, color: Colors.grey),
                SizedBox(height: 25),
                Icon(Icons.groups, color: Colors.grey),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/backgroundImage.png'),
                  ),
                ),
              ],
            ),
          ),

          // ✅ CHAT LIST PANEL
          Container(
            width: 520,
            color: webBackgroundColor,
            child: Column(
              children: [
                // Top bar
                const WebProfileBar(),

                // Search bar
                const WebSearchBar(),
                const ChatFilterItems(isWeb: true),

                // Chat list
                SizedBox(height: 17),
                Expanded(child: ContactsList()),
              ],
            ),
          ),

          // ✅ RIGHT CHAT / EMPTY SCREEN
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/backgroundImage.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
