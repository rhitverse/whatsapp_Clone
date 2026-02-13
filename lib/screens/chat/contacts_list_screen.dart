import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/screens/mobile_chat_screen.dart';

class ContactsListScreen extends StatelessWidget {
  final List<ChatContact> contacts;

  const ContactsListScreen({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final chat = contacts[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MobileChatScreen(
                        chatId: chat.chatId,
                        otherUid: chat.otherUid,
                      ),
                    ),
                  );
                },
                splashColor: websearchBarColor,
                hoverColor: Colors.white10,
                child: ListTile(
                  title: Text(
                    chat.otherUserName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: whiteColor,
                    ),
                  ),
                  subtitle: Text(
                    chat.lastMessage,
                    style: const TextStyle(fontSize: 14),
                  ),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(chat.otherUserProfilePic),
                  ),
                  trailing: Text(
                    chat.lastMessageTime.toString().split(' ')[0],
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
