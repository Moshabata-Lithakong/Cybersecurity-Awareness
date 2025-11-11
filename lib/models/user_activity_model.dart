import 'package:flutter/material.dart';

enum ActivityType {
  quizCompleted,
  topicMastered,
  streakExtended,
  achievementUnlocked,
  profileUpdated
}

class UserActivity {
  final String id;
  final String title;
  final String subtitle;
  final ActivityType type;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  UserActivity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.timestamp,
    this.metadata,
  });

  factory UserActivity.fromJson(Map<String, dynamic> json) {
    return UserActivity(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      type: _parseActivityType(json['type'] ?? 'quizCompleted'),
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toString()),
      metadata: json['metadata'],
    );
  }

  static ActivityType _parseActivityType(String type) {
    switch (type) {
      case 'quizCompleted':
        return ActivityType.quizCompleted;
      case 'topicMastered':
        return ActivityType.topicMastered;
      case 'streakExtended':
        return ActivityType.streakExtended;
      case 'achievementUnlocked':
        return ActivityType.achievementUnlocked;
      case 'profileUpdated':
        return ActivityType.profileUpdated;
      default:
        return ActivityType.quizCompleted;
    }
  }

  IconData get icon {
    switch (type) {
      case ActivityType.quizCompleted:
        return Icons.quiz;
      case ActivityType.topicMastered:
        return Icons.emoji_events;
      case ActivityType.streakExtended:
        return Icons.local_fire_department;
      case ActivityType.achievementUnlocked:
        return Icons.star;
      case ActivityType.profileUpdated:
        return Icons.person;
    }
  }

  Color get color {
    switch (type) {
      case ActivityType.quizCompleted:
        return Colors.blue;
      case ActivityType.topicMastered:
        return Colors.orange;
      case ActivityType.streakExtended:
        return Colors.red;
      case ActivityType.achievementUnlocked:
        return Colors.yellow;
      case ActivityType.profileUpdated:
        return Colors.green;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }
}