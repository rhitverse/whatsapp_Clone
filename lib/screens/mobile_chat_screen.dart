import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/info.dart';
import 'package:whatsapp_clone/widgets/chat_list.dart';
import 'package:whatsapp_clone/widgets/mobile_chat_box.dart';

class MobileChatScreen extends StatefulWidget {
  const MobileChatScreen({super.key});

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                "https://upload.wikimedia.org/wikipedia/en/8/8b/ST3_Steve_Harrington_portrait.jpg?20191213000350",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                info[0]['name'].toString(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          SvgPicture.asset(
            'assets/svg/videocall.svg',
            color: Colors.white,
            width: 25,
            height: 25,
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.call_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/backgroundImage.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ChatList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MobileChatBox(),
          ),
        ],
      ),
    );
  }
}
