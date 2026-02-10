import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatsapp_clone/colors.dart';

class ServerListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> servers;

  const ServerListScreen({super.key, required this.servers});

  @override
  State<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends State<ServerListScreen> {
  bool isExpanded = false;
  int selectedServerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedServer = widget.servers.isNotEmpty
        ? widget.servers[selectedServerIndex]
        : null;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: CircleAvatar(
              backgroundColor: tabColor,
              child: Text(
                selectedServer?['name']?[0]?.toUpperCase() ?? 'S',
                style: const TextStyle(
                  color: whiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              selectedServer?['name'] ?? 'Server',
              style: const TextStyle(
                color: whiteColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.chevron_right, color: whiteColor, size: 20),
          ],
        ),
      ),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isExpanded ? 50 : 0,
            color: backgroundColor,
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Add Server Button - TOP
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      // Add server functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Create new server'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Icon(Icons.add, color: whiteColor, size: 30),
                  ),
                ),
                const SizedBox(height: 5),
                // Server List
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.servers.length,
                    itemBuilder: (context, index) {
                      final server = widget.servers[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12.0,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedServerIndex = index;
                            });
                          },
                          child: CircleAvatar(
                            radius: 27,
                            backgroundColor: selectedServerIndex == index
                                ? tabColor
                                : Colors.grey.shade700,
                            child: Text(
                              server['name']?[0]?.toUpperCase() ?? '?',
                              style: const TextStyle(
                                color: whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(Icons.search, color: whiteColor),
                          SizedBox(width: 10),
                          Text("Search", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Text Channels",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.tag, color: whiteColor),
                    title: const Text(
                      "general",
                      style: TextStyle(color: whiteColor),
                    ),
                    onTap: () {},
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Voice Channels",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      "assets/svg/speaker.svg",
                      color: whiteColor,
                      width: 23,
                      height: 23,
                    ),
                    title: const Text(
                      "Voice Channel",
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
