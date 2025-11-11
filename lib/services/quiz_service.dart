import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cybersecurity_quiz_app/services/api_service.dart';
import 'package:cybersecurity_quiz_app/models/quiz_result_model.dart';

class QuizService {
  final ApiService _apiService = ApiService();

  Future<QuizSubmissionResult> submitQuiz({
    required String topicId,
    required List<Map<String, dynamic>> answers,
    required int timeSpent,
  }) async {
    try {
      final response = await _apiService.submitQuiz(
        topicId: topicId,
        answers: answers,
        timeSpent: timeSpent,
      );

      if (response['success']) {
        return QuizSubmissionResult.fromJson(response);
      } else {
        throw Exception(response['message'] ?? 'Failed to submit quiz');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuizResult>> getQuizHistory({int limit = 10, int page = 1}) async {
    try {
      final response = await _apiService.getQuizHistory(limit: limit, page: page);
      
      if (response['success']) {
        final List<dynamic> historyData = response['data']['quizHistory'];
        return historyData.map((json) => QuizResult.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load quiz history');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserProgress() async {
    try {
      final response = await _apiService.getUserProgress();
      
      if (response['success']) {
        return response['data'];
      } else {
        throw Exception(response['message'] ?? 'Failed to load user progress');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Question>> verifyAnswers(List<Map<String, dynamic>> answers) async {
    try {
      final response = await _apiService.verifyAnswers(answers);
      
      if (response['success']) {
        // Process verified answers
        final List<dynamic> results = response['data']['results'];
        // You can process the results here as needed
        return []; // Return appropriate data structure
      } else {
        throw Exception(response['message'] ?? 'Failed to verify answers');
      }
    } catch (e) {
      rethrow;
    }
  }
}

class QuizSubmissionResult {
  final bool success;
  final String message;
  final QuizResult quizResult;
  final Map<String, dynamic> performance;

  QuizSubmissionResult({
    required this.success,
    required this.message,
    required this.quizResult,
    required this.performance,
  });

  factory QuizSubmissionResult.fromJson(Map<String, dynamic> json) {
    return QuizSubmissionResult(
      success: json['success'],
      message: json['message'],
      quizResult: QuizResult.fromJson(json['data']['quizResult']),
      performance: json['data']['performance'],
    );
  }
}