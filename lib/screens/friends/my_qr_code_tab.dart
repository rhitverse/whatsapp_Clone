import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:vision_gallery_saver/vision_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/models/user_model.dart';

class MyQrCodeTab extends StatefulWidget {
  const MyQrCodeTab({super.key});

  @override
  State<MyQrCodeTab> createState() => _MyQrCodeTabState();
}

class _MyQrCodeTabState extends State<MyQrCodeTab> {
  final controller = ScreenshotController();
  String qrData = "";

  void regenerateQR() {
    setState(() {
      qrData =
          "${FirebaseAuth.instance.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}";
    });
  }

  Future<void> downloadQR() async {
    await Permission.photos.request();

    final image = await controller.capture();

    if (image != null) {
      await VisionGallerySaver.saveImage(
        image,
        name: "qr_${DateTime.now().millisecondsSinceEpoch}",
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("QR saved to gallery")));
    }
  }

  Future<void> shareQR() async {
    final image = await controller.capture();

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/my_qr.png");

    await file.writeAsBytes(image!);

    await Share.shareXFiles([
      XFile(file.path),
    ], text: "https://yourapp.com/user/$qrData");
  }

  void copyLink() {
    Clipboard.setData(ClipboardData(text: "https://yourapp.com/user/$qrData"));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Link Copied")));
  }

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  Future<void> loadUsername() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (doc.exists) {
      final user = UserModel.fromMap(doc.data()!);

      setState(() {
        qrData = user.username ?? user.displayname;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Screenshot(
              controller: controller,
              child: QrImageView(
                data: qrData,
                size: 220,
                backgroundColor: whiteColor,
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Show or send this QR code to friends\n"
              "to let them add you.",
              style: TextStyle(color: whiteColor, fontSize: 16),
            ),
            SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _action(Icons.link, "Copy link", copyLink),
                _action(Icons.share, "Share", shareQR),
                _action(Icons.download, "Save", downloadQR),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _action(IconData icon, String text, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(icon: Icon(icon), onPressed: onTap),
        Text(text),
      ],
    );
  }
}
