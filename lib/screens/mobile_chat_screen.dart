import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/info.dart';
import 'package:whatsapp_clone/widgets/chat_list.dart';

class MobileChatScreen extends StatefulWidget {
  const MobileChatScreen({super.key});

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isTyping = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.054,
                  width: MediaQuery.of(context).size.width * 0.88,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: mobileChatBoxColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 12),
                      SvgPicture.asset(
                        'assets/svg/Sticker.svg',
                        color: Colors.white,
                        width: 26,
                        height: 26,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          cursorColor: Colors.green,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          onChanged: (value) {
                            setState(() {
                              isTyping = value.trim().isNotEmpty;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Message',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.attach_file_rounded),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.camera_alt_outlined),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 23,
                  backgroundColor: const Color(0xFF00C357),
                  child: IconButton(
                    icon: Icon(
                      isTyping ? Icons.send : Icons.mic,
                      color: Colors.black,
                      size: 23,
                    ),
                    onPressed: () {
                      if (isTyping) {
                        print("Send: ${_controller.text}");
                      } else {
                        print("Mic pressed");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
