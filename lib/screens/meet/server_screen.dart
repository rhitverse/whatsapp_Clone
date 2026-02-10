import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatsapp_clone/colors.dart';

class ServerScreen extends StatefulWidget {
  const ServerScreen({super.key});

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  List<Map<String, dynamic>> servers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: servers.length + 1,
                    itemBuilder: (context, index) {
                      if (index == servers.length) {
                        return Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 0.8,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.add,
                                    color: uiColor,
                                    size: 30,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Create Server",
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final server = servers[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CircleAvatar(
                          radius: 26,
                          backgroundImage: server['image'] != null
                              ? NetworkImage(server['image'])
                              : null,
                          child: server['image'] == null
                              ? Text(
                                  server['name'][0].toUpperCase(),
                                  style: const TextStyle(color: whiteColor),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),

              if (servers.length > 1)
                const Icon(Icons.expand_more, color: whiteColor),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search_outlined, color: whiteColor, size: 27),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.person_add_alt_1, color: whiteColor, size: 26),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),

      body: servers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/svg/server.svg",
                    width: 150,
                    height: 150,
                    color: whiteColor,
                  ),

                  SizedBox(height: 16),
                  Text(
                    'No servers yet',
                    style: TextStyle(fontSize: 18, color: whiteColor),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Join a Server or Create your own Server',
                    style: TextStyle(color: whiteColor, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: servers.length,
              itemBuilder: (context, index) {
                final server = servers[index];
                final isText = server['type'] == 'text';

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isText ? Colors.blue : Colors.green,
                      child: Icon(
                        isText ? Icons.chat : Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      server['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      isText ? 'Text Server' : 'Voice Server',
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          servers.removeAt(index);
                        });
                      },
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening ${server['name']}...')),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
