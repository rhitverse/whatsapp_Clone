import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/screens/friends/my_qr_code_tab.dart';
import 'package:whatsapp_clone/screens/friends/scan_qr_tab.dart';
import 'package:whatsapp_clone/screens/friends/qr_bottom_nav.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          TabBarView(
            controller: tabController,
            children: const [
              ScanQrTab(), // ✅ Correct widget
              MyQrCodeTab(),
            ],
          ),
          QrBottomNav(controller: tabController),
        ],
      ),
    );
  }
}
