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
import 'package:whatsapp_clone/widgets/helpful_widgets/custom_messenger.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/regenerate_dialog.dart';

class MyQrCodeTab extends StatefulWidget {
  const MyQrCodeTab({super.key});

  @override
  State<MyQrCodeTab> createState() => _MyQrCodeTabState();
}

class _MyQrCodeTabState extends State<MyQrCodeTab> {
  final controller = ScreenshotController();
  String qrData = "";

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
        qrData = doc.data()!.containsKey('qrData')
            ? doc.data()!['qrData']
            : (user.username ?? user.displayname);
      });
    }
  }

  void regenerateQR() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (doc.exists) {
      final user = UserModel.fromMap(doc.data()!);
      final newQR =
          "${user.username ?? user.displayname}_${DateTime.now().millisecondsSinceEpoch}";

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'qrData': newQR,
      });

      setState(() {
        qrData = newQR;
      });
    }
  }

  Future<void> downloadQR() async {
    await Permission.photos.request();

    final image = await controller.capture();

    if (image != null) {
      await VisionGallerySaver.saveImage(
        image,
        name: "qr_${DateTime.now().millisecondsSinceEpoch}",
      );

      CustomMessenger.show(context, "QR Saved");
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
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: QrImageView(
                  data: qrData.isEmpty
                      ? FirebaseAuth.instance.currentUser!.uid
                      : qrData,
                  size: 220,
                  backgroundColor: whiteColor,
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Show or send this QR code to friends\n"
              "to let them add you.",
              style: TextStyle(color: whiteColor, fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _action(Icons.link, "Copy", copyLink),
                _action(Icons.share, "Share", shareQR),
                _action(Icons.download, "Save", downloadQR),
              ],
            ),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                showRegenerateDialog(context, regenerateQR);
              },
              icon: const Icon(Icons.refresh, color: whiteColor),
              label: const Text(
                "Regenerate",
                style: TextStyle(color: whiteColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _action(IconData icon, String text, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: whiteColor),
          onPressed: onTap,
        ),
        Text(text, style: const TextStyle(color: whiteColor)),
      ],
    );
  }
}
