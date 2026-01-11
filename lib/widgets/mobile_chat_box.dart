import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatsapp_clone/colors.dart';

class MobileChatBox extends StatefulWidget {
  const MobileChatBox({super.key});

  @override
  State<MobileChatBox> createState() => _MobileChatBoxState();
}

class _MobileChatBoxState extends State<MobileChatBox> {
  final TextEditingController _controller = TextEditingController();
  bool isTyping = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      isTyping = value.trim().isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
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
    );
  }
}
