import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final commonCloudinaryRepositoryProvider = Provider(
  (ref) => CommonCloudinaryRepository(),
);

class CommonCloudinaryRepository {
  final String cloudName = "dova6pnyl";
  final String uploadPreset = "ChatApp";

  CommonCloudinaryRepository();

  Future<String?> storeFileToCloudinary(File file) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/auto/upload",
      );

      var request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        final resData = await response.stream.bytesToString();
        final data = jsonDecode(resData);

        return data['secure_url'];
      } else {
        print('Cloudinary upload failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Cloudinary upload error: $e');
      return null;
    }
  }
}
