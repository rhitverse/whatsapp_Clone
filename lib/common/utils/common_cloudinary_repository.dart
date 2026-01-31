import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:whatsapp_clone/secret/secret.dart';
import 'package:crypto/crypto.dart';

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

  String _generateSignature(String publicId, int timestamp) {
    final params = 'public_id=$publicId&timestamp=$timestamp$apiSecret';
    final bytes = utf8.encode(params);
    final digest = sha1.convert(bytes);
    return digest.toString();
  }

  String _extractPublicId(String fileUrl) {
    try {
      final uri = Uri.parse(fileUrl);
      final path = uri.path;
      final uploadIndex = path.indexOf('/upload/');
      if (uploadIndex == -1) {
        throw Exception('Invalid Cloudinary URL');
      }

      final afterUpload = path.substring(uploadIndex + 8);

      final parts = afterUpload.split('/');
      final withoutVersion = parts
          .where((part) => !part.startsWith('v'))
          .toList();

      final publicIdWithExt = withoutVersion.join('/');
      final publicId = publicIdWithExt.substring(
        0,
        publicIdWithExt.lastIndexOf('.'),
      );

      print('Extracted public_id: $publicId');
      return publicId;
    } catch (e) {
      print('Error extracting public_id: $e');
      rethrow;
    }
  }

  Future<void> deleteFileFromCloudinary(String fileUrl) async {
    try {
      final publicId = _extractPublicId(fileUrl);

      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final signature = _generateSignature(publicId, timestamp);

      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/destroy",
      );

      print('Attempting to delete with public_id: $publicId');

      final response = await http.post(
        url,
        body: {
          'public_id': publicId,
          'timestamp': timestamp.toString(),
          'api_key': apiKey,
          'signature': signature,
        },
      );

      print('Delete response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['result'] == 'ok') {
          print('✅ Successfully deleted from Cloudinary: $publicId');
        } else {
          print('❌ Delete failed: ${data['result']}');
          throw Exception('Failed to delete: ${data['result']}');
        }
      } else {
        throw Exception(
          'Failed to delete file from Cloudinary: ${response.body}',
        );
      }
    } catch (e) {
      print('Cloudinary delete error: $e');
      throw Exception('Cloudinary delete error: $e');
    }
  }
}
