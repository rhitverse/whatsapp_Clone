import 'package:flutter/material.dart';

class MyQrCodeTab extends StatelessWidget {
  const MyQrCodeTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111B21),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_2, size: 200, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "Your Name",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "WhatsApp Contact",
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }
}
