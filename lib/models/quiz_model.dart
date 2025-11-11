class QuizTopic {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  QuizTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });
}

class Quiz {
  final String id;
  final String title;
  final String description;
  final String topicId;
  final String topicTitle;
  final String difficulty;
  final List<Question> questions;
  final double? averageScore;
  final int totalAttempts;
  final DateTime createdAt;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.topicId,
    required this.topicTitle,
    required this.difficulty,
    required this.questions,
    this.averageScore,
    this.totalAttempts = 0,
    required this.createdAt,
  });
}

class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final DateTime joinDate;
  final bool isActive;
  final int quizzesTaken;
  final double averageScore;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.joinDate,
    this.isActive = true,
    this.quizzesTaken = 0,
    this.averageScore = 0.0,
  });
}