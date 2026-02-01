import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  try {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,

      imageQuality: 70,
      maxHeight: 1080,
      maxWidth: 1080,
    );

    if (pickedImage != null) {
      return File(pickedImage.path);
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
  return null;
}
