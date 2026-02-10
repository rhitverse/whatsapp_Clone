import 'package:flutter/material.dart';
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
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _createNewServer() {
    TextEditingController serverNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        title: const Text(
          'Create New Server',
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
                setState(() {
                  widget.servers.add({
                    'name': serverNameController.text,
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'channels': [
                      {'name': 'general', 'type': 'text'},
                      {'name': 'General', 'type': 'voice'},
                    ],
                  });
                  selectedServerIndex = widget.servers.length - 1;
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Server "${serverNameController.text}" created!',
                    ),
                    duration: const Duration(seconds: 2),
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

  @override
  Widget build(BuildContext context) {
    if (selectedServerIndex >= widget.servers.length) {
      selectedServerIndex = 0;
    }

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
            padding: const EdgeInsets.only(left: 10),
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
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add member'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(
              Icons.person_add_alt_1_outlined,
              color: whiteColor,
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: isExpanded ? 70 : 0,
            color: backgroundColor,
            child: ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: isExpanded ? 1 : 0,
                child: SizedBox(
                  width: 70,
                  child: Column(
                    children: [
                      const SizedBox(height: 1),
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.servers.length + 1,
                          itemBuilder: (context, index) {
                            if (index == widget.servers.length) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 4,
                                  bottom: 20,
                                  left: 7.0,
                                  right: 7.0,
                                ),
                                child: InkWell(
                                  onTap: _createNewServer,
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade700,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: whiteColor,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              );
                            }
                            if (index == selectedServerIndex) {
                              return const SizedBox.shrink();
                            }

                            final server = widget.servers[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                                horizontal: 7.0,
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedServerIndex = index;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.grey.shade700,
                                  child: Text(
                                    server['name']?[0]?.toUpperCase() ?? '?',
                                    style: const TextStyle(
                                      color: whiteColor,
                                      fontSize: 16,
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
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xff373a43),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: whiteColor),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: whiteColor),
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Text Channels",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.tag, color: whiteColor),
                    title: const Text(
                      "general",
                      style: TextStyle(color: whiteColor, fontSize: 16),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening general channel'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Voice Channels",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.volume_up,
                      color: whiteColor,
                      size: 23,
                    ),
                    title: const Text(
                      "General",
                      style: TextStyle(color: whiteColor, fontSize: 16),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Joining voice channel'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
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
