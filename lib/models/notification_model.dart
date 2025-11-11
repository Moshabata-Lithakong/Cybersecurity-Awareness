import 'package:flutter/material.dart';

enum NotificationType {
  quizAdded,
  challenge,
  system,
  achievement,
  reminder
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? data;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.data,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  IconData get icon {
    switch (type) {
      case NotificationType.quizAdded:
        return Icons.quiz_rounded;
      case NotificationType.challenge:
        return Icons.emoji_events_rounded;
      case NotificationType.system:
        return Icons.info_rounded;
      case NotificationType.achievement:
        return Icons.star_rounded;
      case NotificationType.reminder:
        return Icons.notifications_active_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.quizAdded:
        return Colors.orange;
      case NotificationType.challenge:
        return Colors.amber;
      case NotificationType.system:
        return Colors.blue;
      case NotificationType.achievement:
        return Colors.green;
      case NotificationType.reminder:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}