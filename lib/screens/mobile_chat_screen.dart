import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:intl/intl.dart';

class MobileChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUid;

  const MobileChatScreen({
    super.key,
    required this.chatId,
    required this.otherUid,
  });

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String otherUserName = '';
  String otherUserProfilePic = '';

  @override
  void initState() {
    super.initState();
    _loadOtherUserData();
  }

  Future<void> _loadOtherUserData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.otherUid)
        .get();

    if (userDoc.exists) {
      setState(() {
        otherUserName = userDoc.data()?['name'] ?? 'Unknown';
        otherUserProfilePic = userDoc.data()?['profilePic'] ?? '';
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    try {
      final messageText = _messageController.text.trim();

      await FirebaseFirestore.instance
          .collection('Chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
            'senderId': currentUserId,
            'text': messageText,
            'time': FieldValue.serverTimestamp(),
          });

      await FirebaseFirestore.instance
          .collection('Chats')
          .doc(widget.chatId)
          .update({
            'lastMessage': messageText,
            'lastMessageTime': FieldValue.serverTimestamp(),
          });

      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send message')));
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: otherUserProfilePic.isNotEmpty
                  ? NetworkImage(otherUserProfilePic)
                  : null,
              child: otherUserProfilePic.isEmpty
                  ? const Icon(Icons.person, size: 20)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                otherUserName,
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
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet\nSay hi! 👋',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: whiteColor.withOpacity(0.5),
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
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
                        ? DateFormat('HH:mm').format(timestamp.toDate())
                        : '';

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? uiColor : messageColor,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isMe
                                ? const Radius.circular(12)
                                : const Radius.circular(0),
                            bottomRight: isMe
                                ? const Radius.circular(0)
                                : const Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              text,
                              style: const TextStyle(
                                color: whiteColor,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              timeString,
                              style: TextStyle(
                                color: whiteColor.withOpacity(0.6),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: appBarColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: searchBarColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(color: whiteColor),
                            decoration: const InputDecoration(
                              hintText: 'Message',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.newline,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: uiColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: whiteColor, size: 22),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
