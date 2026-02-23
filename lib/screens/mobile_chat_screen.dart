import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/screens/chat/widget/bottom_chat_field.dart';
import 'package:whatsapp_clone/screens/chat/widget/receiver_message.dart';
import 'package:whatsapp_clone/screens/chat/widget/sender_message.dart';

class MobileChatScreen extends StatefulWidget {
  final String chatId;
  final String receiverUid;
  final String receiverDisplayName;
  final String receiverProfilePic;

  const MobileChatScreen({
    super.key,
    required this.chatId,
    required this.receiverUid,
    required this.receiverDisplayName,
    required this.receiverProfilePic,
  });

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool showEmoji = false;
  FocusNode focusNode = FocusNode();
  String receiverDisplayName = '';
  String receiverProfilePic = '';

  @override
  void initState() {
    super.initState();
    receiverDisplayName = widget.receiverDisplayName;
    receiverProfilePic = widget.receiverProfilePic;

    focusNode.addListener(() {
      if (focusNode.hasFocus && showEmoji) {
        setState(() => showEmoji = false);
      }
    });
  }

  void onEmojiTap() {
    setState(() {
      showEmoji = !showEmoji;
    });
    if (showEmoji) {
      focusNode.unfocus();
    } else {
      focusNode.requestFocus();
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) return;
    final messageText = _messageController.text.trim();
    _messageController.clear();
    focusNode.unfocus();

    try {
      FirebaseFirestore.instance
          .collection('Chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
            'senderId': currentUserId,
            'text': messageText,
            'time': FieldValue.serverTimestamp(),
          });

      FirebaseFirestore.instance.collection('Chats').doc(widget.chatId).update({
        'lastMessage': messageText,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSenderId': currentUserId,
        'unreadCount_${widget.receiverUid}': FieldValue.increment(1),
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to send message')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: !showEmoji,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        backgroundColor: backgroundColor,
        elevation: 0,
        titleSpacing: 0,
        leadingWidth: 40,
        leading: IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundImage: receiverProfilePic.isNotEmpty
                  ? NetworkImage(receiverProfilePic)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                receiverDisplayName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: whiteColor),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: whiteColor),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: whiteColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet\nSay hi! 👋',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData =
                        messages[index].data() as Map<String, dynamic>;
                    final senderId = messageData['senderId'] ?? '';
                    final text = messageData['text'] ?? '';
                    final timestamp = messageData['time'] as Timestamp?;

                    final isMe = senderId == currentUserId;
                    final timeString = timestamp != null
                        ? DateFormat('h:mm a').format(timestamp.toDate())
                        : '';

                    bool showTail = true;
                    bool isGrouped = false;
                    if (index > 0) {
                      final prevMessageData =
                          messages[index - 1].data() as Map<String, dynamic>;
                      final prevSenderId = prevMessageData['senderId'] ?? '';

                      if (senderId == prevSenderId) {
                        showTail = false;
                        isGrouped = true;
                      }
                    }

                    return isMe
                        ? SenderMessage(
                            text: text,

                            time: timeString,
                            showTail: showTail,
                            isGrouped: isGrouped,
                          )
                        : ReceiverMessage(
                            text: text,
                            time: timeString,
                            showTail: showTail,
                            isGrouped: isGrouped,
                          );
                  },
                );
              },
            ),
          ),
          BottomChatField(
            controller: _messageController,
            focusNode: focusNode,
            showEmoji: showEmoji,
            onEmojiTap: onEmojiTap,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
