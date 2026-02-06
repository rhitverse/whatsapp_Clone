import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner>
    with SingleTickerProviderStateMixin {
  late TabController tabCon;

  @override
  void initState() {
    super.initState();
    tabCon = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          TabBarView(
            controller: tabCon,
            children: const [
              Center(child: Text("Scan QR Code")),
              Center(child: Text("My QR Code")),
            ],
          ),
        ],
      ),
    );
  }
}
