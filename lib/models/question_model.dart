import 'package:flutter/material.dart';

class Question {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final String difficulty;
  final int points;
  final String? topicId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.difficulty = 'medium',
    this.points = 10,
    this.topicId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'] ?? json['id'] ?? '',
      questionText: json['questionText'] ?? json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? json['correctAnswerIndex'] ?? 0,
      explanation: json['explanation'] ?? '',
      difficulty: json['difficulty'] ?? 'medium',
      points: json['points'] ?? 10,
      topicId: json['topicId'] ?? json['topic'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'difficulty': difficulty,
      'points': points,
      'topicId': topicId,
    };
  }

  // Check if answer is correct
  bool isCorrect(int selectedAnswer) {
    return selectedAnswer == correctAnswer;
  }

  // Get the correct answer text
  String get correctAnswerText {
    if (correctAnswer >= 0 && correctAnswer < options.length) {
      return options[correctAnswer];
    }
    return '';
  }
}

class QuizResult {
  final String id;
  final String userId;
  final String topicId;
  final String topicName;
  final String? topicIcon;
  final int score;
  final int totalQuestions;
  final double percentage;
  final int timeSpent;
  final List<Answer> answers;
  final DateTime completedAt;

  QuizResult({
    required this.id,
    required this.userId,
    required this.topicId,
    required this.topicName,
    this.topicIcon,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.timeSpent,
    required this.answers,
    required this.completedAt,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    final topic = json['topic'] is Map ? json['topic'] : {};
    return QuizResult(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? json['user'] ?? '',
      topicId: topic['_id'] ?? json['topicId'] ?? '',
      topicName: topic['name'] ?? json['topicName'] ?? 'Unknown Topic',
      topicIcon: topic['icon'],
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
      timeSpent: json['timeSpent'] ?? 0,
      answers: (json['answers'] as List? ?? [])
          .map((answer) => Answer.fromJson(answer))
          .toList(),
      completedAt: DateTime.parse(json['completedAt'] ?? DateTime.now().toString()),
    );
  }

  // Check if quiz was passed (70% or higher)
  bool get passed => percentage >= 70;

  // Get performance text
  String get performanceText {
    if (percentage >= 90) return 'Excellent';
    if (percentage >= 80) return 'Very Good';
    if (percentage >= 70) return 'Good';
    if (percentage >= 60) return 'Average';
    return 'Needs Improvement';
  }

  Color get performanceColor {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.lightGreen;
    if (percentage >= 70) return Colors.orange;
    return Colors.red;
  }
}

class Answer {
  final String questionId;
  final String questionText;
  final int selectedAnswer;
  final bool isCorrect;
  final int correctAnswer;
  final String explanation;
  final int timeTaken;

  Answer({
    required this.questionId,
    required this.questionText,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.correctAnswer,
    required this.explanation,
    required this.timeTaken,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    final question = json['question'] is Map ? json['question'] : {};
    return Answer(
      questionId: question['_id'] ?? json['questionId'] ?? '',
      questionText: question['questionText'] ?? json['questionText'] ?? '',
      selectedAnswer: json['selectedAnswer'] ?? 0,
      isCorrect: json['isCorrect'] ?? false,
      correctAnswer: json['correctAnswer'] ?? 0,
      explanation: json['explanation'] ?? '',
      timeTaken: json['timeTaken'] ?? 0,
    );
  }
}