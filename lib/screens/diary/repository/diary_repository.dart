import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp_clone/common/utils/common_cloudinary_repository.dart';
import 'package:whatsapp_clone/models/diary_model.dart';

class DiaryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CommonCloudinaryRepository _cloudinary = CommonCloudinaryRepository();

  String get _uid => _auth.currentUser!.uid;
  CollectionReference get _diaryRef =>
      _firestore.collection('users').doc(_uid).collection('diary');

  static const _monthNames = [
    '',
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];
  static const _weekdays = [
    '',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  Future<void> addEntry(
    String text, {
    int weatherIndex = 0,
    int moodIndex = 0,
    List<File> mediaFiles = const [],
    List<String> mediaTypes = const [],
  }) async {
    final now = DateTime.now();
    final List<String> uploadedUrls = [];
    final List<String> uploadedTypes = [];

    for (int i = 0; i < mediaFiles.length; i++) {
      final url = await _cloudinary.storeFileToCloudinary(mediaFiles[i]);
      if (url != null) {
        uploadedUrls.add(url);
        uploadedTypes.add(i < mediaTypes.length ? mediaTypes[i] : 'images');
      }
    }
    await _diaryRef.add({
      'text': text,
      'day': now.day.toString(),
      'month': _monthNames[now.month],
      'weekday': _weekdays[now.weekday],
      'time':
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      'createdAt': Timestamp.fromDate(now),
      'weatherIndex': weatherIndex,
      'moodIndex': moodIndex,
      'mediaUrls': uploadedUrls,
      'mediaTypes': uploadedTypes,
    });
  }

  Future<void> deleteEntry(String entryId) async {
    final doc = await _diaryRef.doc(entryId).get();
    final data = doc.data() as Map<String, dynamic>?;
    if (data != null) {
      final urls = List<String>.from(data['mediaUrls'] ?? []);
      for (final url in urls) {
        await _cloudinary.deleteFileFromCloudinary(url);
      }
    }
    await _diaryRef.doc(entryId).delete();
  }

  Stream<List<DiaryModel>> getEntriesStream() {
    return _diaryRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => DiaryModel.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Future<void> updateEntry(String entryId, String newText) async {
    await _diaryRef.doc(entryId).update({'text': newText});
  }
}
