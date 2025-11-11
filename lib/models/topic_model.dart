import 'package:flutter/material.dart';
import 'question_model.dart'; // Add this import

class Topic {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String difficulty;
  final int estimatedTime;
  final int questionsCount;
  final bool isActive;
  final List<String> learningObjectives;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Question> questions;

  Topic({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.difficulty,
    required this.estimatedTime,
    required this.questionsCount,
    required this.isActive,
    required this.learningObjectives,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '📚',
      difficulty: json['difficulty'] ?? 'beginner',
      estimatedTime: json['estimatedTime'] ?? 10,
      questionsCount: json['questionsCount'] ?? (json['questions'] != null ? (json['questions'] as List).length : 0),
      isActive: json['isActive'] ?? true,
      learningObjectives: List<String>.from(json['learningObjectives'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
      questions: (json['questions'] as List? ?? [])
          .map((question) => Question.fromJson(question))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'difficulty': difficulty,
      'estimatedTime': estimatedTime,
      'isActive': isActive,
      'learningObjectives': learningObjectives,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  Color get difficultyColor {
    switch (difficulty) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get difficultyText {
    switch (difficulty) {
      case 'beginner':
        return 'Beginner';
      case 'intermediate':
        return 'Intermediate';
      case 'advanced':
        return 'Advanced';
      default:
        return 'Unknown';
    }
  }

  List<Question> get questionsList => questions;
  int get questionCount => questionsCount;
}