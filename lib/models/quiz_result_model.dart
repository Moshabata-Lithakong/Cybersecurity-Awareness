import 'question_model.dart';

// This file contains extensions and additional models for quiz results

class QuizPerformance {
  final int score;
  final int totalQuestions;
  final double percentage;
  final int correctAnswers;
  final int wrongAnswers;

  QuizPerformance({
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.correctAnswers,
    required this.wrongAnswers,
  });

  factory QuizPerformance.fromJson(Map<String, dynamic> json) {
    return QuizPerformance(
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      percentage: (json['percentage'] ?? 0).toDouble(),
      correctAnswers: json['correctAnswers'],
      wrongAnswers: json['wrongAnswers'],
    );
  }

  String get performanceText {
    if (percentage >= 90) return 'Excellent! 🎉';
    if (percentage >= 80) return 'Great Job! 👍';
    if (percentage >= 70) return 'Good Work! 👏';
    if (percentage >= 60) return 'Not Bad! 😊';
    if (percentage >= 50) return 'Keep Trying! 💪';
    return 'Need More Practice! 📚';
  }

  Color get performanceColor {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.lightGreen;
    if (percentage >= 70) return Colors.orange;
    if (percentage >= 60) return Colors.amber;
    if (percentage >= 50) return Colors.orangeAccent;
    return Colors.red;
  }
}

class QuizSummary {
  final String topicName;
  final int totalQuestions;
  final int correctAnswers;
  final int timeSpent;
  final DateTime completedAt;

  QuizSummary({
    required this.topicName,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeSpent,
    required this.completedAt,
  });

  double get percentage => (correctAnswers / totalQuestions) * 100;

  String get timeFormatted {
    final minutes = timeSpent ~/ 60;
    final seconds = timeSpent % 60;
    return '${minutes}m ${seconds}s';
  }
}