import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_clone/colors.dart';

class EmptyServerScreen extends StatefulWidget {
  final List<Map<String, dynamic>> servers;
  final VoidCallback? onServerCreated;
  const EmptyServerScreen({
    super.key,
    required this.servers,
    this.onServerCreated,
  });

  @override
  State<EmptyServerScreen> createState() => _EmptyServerScreenState();
}

class _EmptyServerScreenState extends State<EmptyServerScreen> {
  void _createServer(BuildContext context) {
    TextEditingController serverNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        title: const Text(
          'Create Server',
          style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: serverNameController,
          style: const TextStyle(color: whiteColor),
          decoration: InputDecoration(
            hintText: 'Enter server name',
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: tabColor),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (serverNameController.text.isNotEmpty) {
                widget.servers.add({
                  'name': serverNameController.text,
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'channels': [
                    {'name': 'general', 'type': 'text'},
                    {'name': 'General', 'type': 'voice'},
                  ],
                });

                Navigator.pop(context);
                if (widget.onServerCreated != null) {
                  widget.onServerCreated!();
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Server"${serverNameController.text}" created!',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter server name'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            child: const Text(
              'Create',
              style: TextStyle(color: tabColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _joinServer(BuildContext context) {
    if (widget.servers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No servers available to join'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      if (widget.onServerCreated != null) {
        widget.onServerCreated!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,

        title: const Text(
          "Server",
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Center(
                child: SvgPicture.asset(
                  "assets/svg/server.svg",
                  height: 200,
                  width: 200,
                  colorFilter: const ColorFilter.mode(
                    whiteColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "No server yet",
                style: TextStyle(
                  fontSize: 22,
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Join a Server or Create your own Server",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _createServer(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteColor,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: const Text(
                    "Create Server",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _joinServer(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: uiColor,
                    foregroundColor: whiteColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: const Text(
                    "Join Server",
                    style: TextStyle(
                      fontSize: 16,
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
