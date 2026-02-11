import 'package:flutter/material.dart';
import 'package:whatsapp_clone/screens/meet/empty_server_screen.dart';
import 'package:whatsapp_clone/screens/meet/server_list_screen.dart';

class ServerScreen extends StatefulWidget {
  const ServerScreen({super.key});

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  List<Map<String, dynamic>> servers = [];
  void _onServerListChnaged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (servers.isEmpty) {
      return EmptyServerScreen(
        servers: servers,
        onServerCreated: _onServerListChnaged,
      );
    } else {
      return ServerListScreen(
        servers: servers,
        onServerDeleted: _onServerListChnaged,
      );
    }
  }
}
