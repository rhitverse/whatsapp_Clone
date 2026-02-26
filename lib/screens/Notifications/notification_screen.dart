import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class NotificaionScreen extends StatelessWidget {
  const NotificaionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,

        title: Text(
          "Notifications",
          style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: const [
          NotificationTile(
            displayName: "Mizuhara",
            message: "accepted your friend request.",
            time: "21d",
            isRequest: false,
          ),
          NotificationTile(
            displayName: "Uryu Ishida",
            message: "sent you a friend request",
            time: "1m",
            isRequest: true,
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String displayName;
  final String message;
  final String time;
  final bool isRequest;
  final String? iamgeurl;
  const NotificationTile({
    super.key,
    required this.displayName,
    required this.message,
    required this.time,
    required this.isRequest,
    this.iamgeurl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 25, backgroundColor: Colors.grey.shade800),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: " $message",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                if (isRequest)
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: uiColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Accept",
                          style: TextStyle(color: whiteColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Ignore",
                          style: TextStyle(color: whiteColor),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(time, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
