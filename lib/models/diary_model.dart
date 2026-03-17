import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryModel {
  final String id;
  final String text;
  final String title;
  final String day;
  final String month;
  final String weekday;
  final String time;
  final DateTime createdAt;
  final int weatherIndex;
  final int moodIndex;
  final List<String> mediaTypes;
  final List<String> mediaUrls;

  DiaryModel({
    required this.id,
    required this.text,
    this.title = '',
    required this.day,
    required this.month,
    required this.weekday,
    required this.time,
    required this.createdAt,
    this.weatherIndex = 0,
    this.moodIndex = 0,
    this.mediaTypes = const [],
    this.mediaUrls = const [],
  });

  DiaryModel copyWith({
    String? id,
    String? text,
    String? title,
    String? day,
    String? month,
    String? weekday,
    String? time,
    DateTime? createdAt,
    int? weatherIndex,
    int? moodIndex,
    List<String>? mediaTypes,
    List<String>? mediaUrls,
  }) {
    return DiaryModel(
      id: id ?? this.id,
      text: text ?? this.text,
      title: title ?? this.title,
      day: day ?? this.day,
      month: month ?? this.month,
      weekday: weekday ?? this.weekday,
      time: time ?? this.time,
      createdAt: createdAt ?? this.createdAt,
      weatherIndex: weatherIndex ?? this.weatherIndex,
      moodIndex: moodIndex ?? this.moodIndex,
      mediaTypes: mediaTypes ?? this.mediaTypes,
      mediaUrls: mediaUrls ?? this.mediaUrls,
    );
  }

  factory DiaryModel.fromMap(String id, Map<String, dynamic> map) {
    return DiaryModel(
      id: id,
      text: map['text'] ?? '',
      title: map['title'] ?? '',
      day: map['day'] ?? '',
      month: map['month'] ?? '',
      weekday: map['weekday'] ?? '',
      time: map['time'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      weatherIndex: map['weatherIndex'] ?? 0,
      moodIndex: map['moodIndex'] ?? 0,
      mediaTypes: List<String>.from(map['mediaTypes'] ?? []),
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    final now = DateTime.now();
    final monthNames = [
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
    final weekdays = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return {
      'text': text,
      'title': title,
      'day': now.day.toString(),
      'month': monthNames[now.month],
      'weekday': weekdays[now.weekday],
      'time':
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      'createdAt': Timestamp.fromDate(now),
      'weatherIndex': weatherIndex,
      'moodIndex': moodIndex,
    };
  }
}
