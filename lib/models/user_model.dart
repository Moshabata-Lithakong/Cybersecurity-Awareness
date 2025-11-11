import 'package:flutter/material.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserProgress? progress;
  final bool isActive;
  final bool isVerified; // ADDED: Email verification status
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.progress,
    this.isActive = true,
    this.isVerified = false, // DEFAULT TO FALSE
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'student',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
      progress: json['progress'] != null ? UserProgress.fromJson(json['progress']) : null,
      isActive: json['isActive'] ?? true,
      isVerified: json['isVerified'] ?? false, // ADDED
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'role': role,
      'isActive': isActive,
      'isVerified': isVerified, // ADDED
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  // Check if user is admin
  bool get isAdmin => role == 'admin';

  // Get user display name
  String get displayName => username.isNotEmpty ? username : email.split('@').first;

  // Get user initial for avatar
  String get initial {
    if (username.isNotEmpty) {
      return username[0].toUpperCase();
    } else if (email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return 'U';
  }
}

class UserProgress {
  final int totalQuizzesTaken;
  final double averageScore;
  final int totalQuestionsAnswered;
  final int correctAnswers;
  final int learningStreak;
  final Map<String, dynamic> stats;
  final List<CompletedTopic> completedTopics;

  UserProgress({
    required this.totalQuizzesTaken,
    required this.averageScore,
    required this.totalQuestionsAnswered,
    required this.correctAnswers,
    required this.learningStreak,
    required this.stats,
    required this.completedTopics,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      totalQuizzesTaken: json['totalQuizzesTaken'] ?? 0,
      averageScore: (json['averageScore'] ?? 0).toDouble(),
      totalQuestionsAnswered: json['totalQuestionsAnswered'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      learningStreak: json['learningStreak'] ?? 0,
      stats: json['stats'] ?? {},
      completedTopics: (json['completedTopics'] as List? ?? [])
          .map((topic) => CompletedTopic.fromJson(topic))
          .toList(),
    );
  }

  double get accuracy {
    if (totalQuestionsAnswered == 0) return 0.0;
    return (correctAnswers / totalQuestionsAnswered * 100);
  }

  int get totalTimeSpent {
    return stats['totalTimeSpent'] ?? 0;
  }

  double get bestScore {
    return (stats['bestScore'] ?? 0).toDouble();
  }

  int get topicsMastered {
    return stats['topicsMastered'] ?? completedTopics.length;
  }
}

class CompletedTopic {
  final String topicId;
  final String topicName;
  final String? topicIcon;
  final double bestScore;
  final int timesCompleted;
  final DateTime completedAt;
  final DateTime lastCompleted;

  CompletedTopic({
    required this.topicId,
    required this.topicName,
    this.topicIcon,
    required this.bestScore,
    required this.timesCompleted,
    required this.completedAt,
    required this.lastCompleted,
  });

  factory CompletedTopic.fromJson(Map<String, dynamic> json) {
    final topic = json['topic'] is Map ? json['topic'] : {};
    return CompletedTopic(
      topicId: topic['_id'] ?? json['topicId'] ?? '',
      topicName: topic['name'] ?? json['topicName'] ?? 'Unknown Topic',
      topicIcon: topic['icon'],
      bestScore: (json['bestScore'] ?? 0).toDouble(),
      timesCompleted: json['timesCompleted'] ?? 1,
      completedAt: DateTime.parse(json['completedAt'] ?? DateTime.now().toString()),
      lastCompleted: DateTime.parse(json['lastCompleted'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topicId': topicId,
      'topicName': topicName,
      'bestScore': bestScore,
      'timesCompleted': timesCompleted,
      'completedAt': completedAt.toIso8601String(),
      'lastCompleted': lastCompleted.toIso8601String(),
    };
  }
}