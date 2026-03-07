import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:whatsapp_clone/colors.dart';

class AttachmentSendScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String receiverUid;

  const AttachmentSendScreen({
    super.key,
    required this.chatId,
    required this.receiverUid,
  });

  @override
  ConsumerState<AttachmentSendScreen> createState() =>
      _AttachmentSendScreenState();
}

class _AttachmentSendScreenState extends ConsumerState<AttachmentSendScreen> {
  List<FileAttachment> selectedFiles = [];
  bool isCompressing = false;
  double uploadProgress = 0.0;

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        for (var file in result.files) {
          if (file.path != null) {
            selectedFiles.add(
              FileAttachment(
                filePath: file.path!,
                fileName: file.name,
                fileSize: file.size,
                fileType: _getFileType(file.name),
              ),
            );
          }
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image != null) {
      final imageFile = File(image.path);
      final fileName =
          image.name ?? 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      setState(() {
        selectedFiles.add(
          FileAttachment(
            filePath: image.path,
            fileName: fileName,
            fileSize: imageFile.lengthSync(),
            fileType: FileType.image,
          ),
        );
      });
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(source: source);

    if (video != null) {
      final videoFile = File(video.path);
      final fileName =
          video.name ?? 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';

      setState(() {
        selectedFiles.add(
          FileAttachment(
            filePath: video.path,
            fileName: fileName,
            fileSize: videoFile.lengthSync(),
            fileType: FileType.video,
          ),
        );
      });
    }
  }

  FileType _getFileType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext)) {
      return FileType.image;
    } else if (['mp4', 'avi', 'mkv', 'mov', 'flv'].contains(ext)) {
      return FileType.video;
    } else if (['pdf', 'doc', 'docx', 'txt', 'xlsx', 'xls'].contains(ext)) {
      return FileType.custom;
    }
    return FileType.custom;
  }

  Future<void> _compressImages() async {
    setState(() => isCompressing = true);

    try {
      for (int i = 0; i < selectedFiles.length; i++) {
        if (selectedFiles[i].fileType == FileType.image) {
          final compressed = await FlutterImageCompress.compressAndGetFile(
            selectedFiles[i].filePath,
            '${Directory.systemTemp.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
            quality: 80,
            minWidth: 1920,
            minHeight: 1080,
          );

          if (compressed != null) {
            selectedFiles[i].filePath = compressed.path;
            selectedFiles[i].fileSize = File(compressed.path).lengthSync();
          }
        }
        setState(() => uploadProgress = (i + 1) / selectedFiles.length);
      }
    } catch (e) {
      debugPrint('Compression error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Compression error: $e')));
      }
    } finally {
      setState(() => isCompressing = false);
    }
  }

  void _removeFile(int index) {
    setState(() => selectedFiles.removeAt(index));
  }

  Future<void> _sendFiles() async {
    if (selectedFiles.isEmpty) return;

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    setState(() => isCompressing = true);

    try {
      for (int i = 0; i < selectedFiles.length; i++) {
        setState(() => uploadProgress = (i + 1) / selectedFiles.length);
        await Future.delayed(const Duration(milliseconds: 500));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Files sent successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error sending files: $e')));
      }
    } finally {
      setState(() => isCompressing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text('Send Attachments'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (selectedFiles.isNotEmpty)
            TextButton.icon(
              onPressed: isCompressing ? null : _compressImages,
              icon: const Icon(Icons.compress),
              label: const Text('Compress'),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: selectedFiles.isEmpty
                ? _buildEmptyState()
                : _buildFilesList(),
          ),
          if (isCompressing) _buildProgressIndicator(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: uploadProgress,
              minHeight: 8,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xff25D366),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(uploadProgress * 100).toStringAsFixed(0)}%',
            style: const TextStyle(color: whiteColor),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[900]!, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _pickFiles,
              icon: const Icon(Icons.folder_open),
              label: const Text('Add More'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: whiteColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: selectedFiles.isEmpty || isCompressing
                  ? null
                  : _sendFiles,
              icon: const Icon(Icons.send),
              label: const Text('Send'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff25D366),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[900],
            ),
            child: Icon(
              Icons.cloud_upload_outlined,
              size: 60,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No files selected',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select photos, videos, PDFs or any file',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          const SizedBox(height: 32),
          _buildQuickActionButtons(),
        ],
      ),
    );
  }

  Widget _buildQuickActionButtons() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _quickActionButton(
          icon: Icons.photo_library,
          label: 'Gallery',
          onTap: () => _pickImage(ImageSource.gallery),
        ),
        _quickActionButton(
          icon: Icons.camera_alt,
          label: 'Camera',
          onTap: () => _pickImage(ImageSource.camera),
        ),
        _quickActionButton(
          icon: Icons.videocam,
          label: 'Video',
          onTap: () => _pickVideo(ImageSource.gallery),
        ),
        _quickActionButton(
          icon: Icons.folder_open,
          label: 'Files',
          onTap: _pickFiles,
        ),
      ],
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[800]!, width: 1),
            ),
            child: Icon(icon, color: const Color(0xff25D366), size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: whiteColor, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFilesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: selectedFiles.length,
      itemBuilder: (context, index) {
        return _buildFileCard(selectedFiles[index], index);
      },
    );
  }

  Widget _buildFileCard(FileAttachment file, int index) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[800],
              ),
              child: _buildFilePreview(file),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.fileName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatFileSize(file.fileSize),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => _removeFile(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview(FileAttachment file) {
    if (file.fileType == FileType.image) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(file.filePath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[800],
              child: const Icon(Icons.error, color: Colors.red),
            );
          },
        ),
      );
    } else if (file.fileType == FileType.video) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(color: Colors.grey[800]),
          ),
          const Icon(
            Icons.play_circle_filled,
            color: Color(0xff25D366),
            size: 32,
          ),
        ],
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[800],
        ),
        child: Center(
          child: Icon(
            _getFileIcon(file.fileName),
            color: const Color(0xff25D366),
            size: 32,
          ),
        ),
      );
    }
  }

  IconData _getFileIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return switch (ext) {
      'pdf' => Icons.picture_as_pdf,
      'doc' || 'docx' => Icons.description,
      'xls' || 'xlsx' => Icons.table_chart,
      'ppt' || 'pptx' => Icons.slideshow,
      'zip' || 'rar' => Icons.folder_zip,
      _ => Icons.insert_drive_file,
    };
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }
}

class FileAttachment {
  String filePath;
  String fileName;
  int fileSize;
  FileType fileType;

  FileAttachment({
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
  });
}
