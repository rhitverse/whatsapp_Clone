import 'dart:io';

import 'package:flutter/material.dart';

Widget profileAvatar({required double radius, File? image, String? photoUrl}) {
  if (image != null) {
    return CircleAvatar(radius: radius, backgroundImage: FileImage(image));
  }

  if (photoUrl != null && photoUrl.isNotEmpty) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(photoUrl),
    );
  }

  return CircleAvatar(
    radius: radius,
    backgroundImage: const NetworkImage(
      'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
    ),
  );
}
