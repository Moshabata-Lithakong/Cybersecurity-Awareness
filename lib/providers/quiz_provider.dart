import 'package:flutter/foundation.dart';
import 'package:cybersecurity_quiz_app/services/api_service.dart';
import 'package:cybersecurity_quiz_app/models/topic_model.dart';
import 'package:cybersecurity_quiz_app/models/question_model.dart';

class QuizProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Topic> _topics = [];
  List<Question> _currentQuestions = [];
  Topic? _currentTopic;
  bool _isLoading = false;
  String _error = '';
  int _currentQuestionIndex = 0;
  List<int?> _userAnswers = [];
  DateTime? _quizStartTime;

  List<Topic> get topics => _topics;
  List<Question> get currentQuestions => _currentQuestions;
  Topic? get currentTopic => _currentTopic;
  bool get isLoading => _isLoading;
  String get error => _error;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get totalQuestions => _currentQuestions.length;
  List<int?> get userAnswers => _userAnswers;
  bool get isQuizComplete => _currentQuestionIndex >= totalQuestions && totalQuestions > 0;

  // Admin functions for topic management
  Future<bool> addTopic(String name, String description, String difficulty, int estimatedTime, List<String> learningObjectives) async {
    try {
      _setLoading(true);
      _error = '';

      print('🔄 Adding topic: $name');

      final response = await _apiService.createTopic({
        'name': name,
        'description': description,
        'difficulty': difficulty,
        'estimatedTime': estimatedTime,
        'learningObjectives': learningObjectives,
        'icon': _getIconForDifficulty(difficulty),
        'isActive': true,
      });

      print('📡 Add topic response: $response');

      // Handle different response formats
      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          await loadTopics();
          _setLoading(false);
          return true;
        } else {
          _error = response['message']?.toString() ?? response['error']?.toString() ?? 'Failed to create topic';
          _setLoading(false);
          return false;
        }
      } else {
        _error = 'Invalid response format from server';
        _setLoading(false);
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateTopic(String id, String name, String description, String difficulty, int estimatedTime, List<String> learningObjectives) async {
    try {
      _setLoading(true);
      _error = '';

      final response = await _apiService.updateTopic(id, {
        'name': name,
        'description': description,
        'difficulty': difficulty,
        'estimatedTime': estimatedTime,
        'learningObjectives': learningObjectives,
        'icon': _getIconForDifficulty(difficulty),
      });

      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          await loadTopics();
          _setLoading(false);
          return true;
        } else {
          _error = response['message']?.toString() ?? response['error']?.toString() ?? 'Failed to update topic';
          _setLoading(false);
          return false;
        }
      } else {
        _error = 'Invalid response format from server';
        _setLoading(false);
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteTopic(String id) async {
    try {
      _setLoading(true);
      _error = '';

      final response = await _apiService.deleteTopic(id);

      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          _topics.removeWhere((topic) => topic.id == id);
          _setLoading(false);
          notifyListeners();
          return true;
        } else {
          _error = response['message']?.toString() ?? response['error']?.toString() ?? 'Failed to delete topic';
          _setLoading(false);
          return false;
        }
      } else {
        _error = 'Invalid response format from server';
        _setLoading(false);
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      _setLoading(false);
      return false;
    }
  }

  // Admin functions for quiz/question management
  Future<bool> addQuestionsToTopic(String topicId, List<Question> questions) async {
    try {
      _setLoading(true);
      _error = '';

      print('🔄 Adding ${questions.length} questions to topic: $topicId');

      final questionsData = questions.map((question) => question.toJson()).toList();
      
      final response = await _apiService.addQuestionsToTopic(topicId, {
        'questions': questionsData,
      });

      print('📡 Add questions response: $response');

      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          await loadTopics();
          _setLoading(false);
          return true;
        } else {
          _error = response['message']?.toString() ?? response['error']?.toString() ?? 'Failed to add questions';
          _setLoading(false);
          return false;
        }
      } else {
        _error = 'Invalid response format from server';
        _setLoading(false);
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      _setLoading(false);
      return false;
    }
  }

  // Load all topics from database
  Future<void> loadTopics() async {
    try {
      _setLoading(true);
      _error = '';

      final response = await _apiService.getTopics();
      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          final data = response['data'] as List? ?? [];
          _topics = data.map((topic) => Topic.fromJson(topic)).toList();
        } else {
          _error = response['message']?.toString() ?? response['error']?.toString() ?? 'Failed to load topics';
        }
      } else {
        _error = 'Invalid response format from server';
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
    } finally {
      _setLoading(false);
    }
  }

  // Load questions for a specific topic from database
  Future<bool> loadTopicQuestions(String topicId) async {
    try {
      _setLoading(true);
      _error = '';

      final response = await _apiService.getTopicQuestions(topicId);
      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          final data = response['data'] ?? {};
          final topicData = data['topic'] ?? {};
          _currentTopic = Topic.fromJson(topicData);
          
          final questionsData = data['questions'] as List? ?? [];
          _currentQuestions = questionsData.map((question) => Question.fromJson(question)).toList();
          
          _currentQuestionIndex = 0;
          _userAnswers = List.filled(_currentQuestions.length, null);
          _quizStartTime = DateTime.now();
          
          _setLoading(false);
          return true;
        } else {
          _error = response['message']?.toString() ?? response['error']?.toString() ?? 'Failed to load questions';
          _setLoading(false);
          return false;
        }
      } else {
        _error = 'Invalid response format from server';
        _setLoading(false);
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      _setLoading(false);
      return false;
    }
  }

  // Helper method to get icon based on difficulty
  String _getIconForDifficulty(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return '🌱';
      case 'intermediate':
        return '🚀';
      case 'advanced':
        return '🔥';
      default:
        return '📚';
    }
  }

  String _extractErrorMessage(dynamic error) {
    if (error is String) {
      return error;
    } else if (error.toString().contains('SocketException')) {
      return 'Network error: Please check your internet connection and server status';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Request timeout: Server is taking too long to respond';
    } else if (error.toString().contains('HttpException')) {
      return error.toString().replaceAll('HttpException: ', '');
    } else if (error.toString().contains('50')) {
      return 'Server error: Please check if the backend server is running on localhost:3000';
    } else {
      return 'An unexpected error occurred: ${error.toString()}';
    }
  }

  // Existing quiz functions
  void answerQuestion(int answerIndex) {
    if (_currentQuestionIndex < totalQuestions) {
      _userAnswers[_currentQuestionIndex] = answerIndex;
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (_currentQuestionIndex < totalQuestions - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  Question? get currentQuestion {
    if (_currentQuestionIndex < totalQuestions) {
      return _currentQuestions[_currentQuestionIndex];
    }
    return null;
  }

  int? get currentUserAnswer {
    if (_currentQuestionIndex < totalQuestions) {
      return _userAnswers[_currentQuestionIndex];
    }
    return null;
  }

  int get quizTimeSpent {
    if (_quizStartTime == null) return 0;
    return DateTime.now().difference(_quizStartTime!).inSeconds;
  }

  List<Map<String, dynamic>> get quizAnswers {
    final answers = <Map<String, dynamic>>[];
    for (int i = 0; i < _userAnswers.length; i++) {
      if (_userAnswers[i] != null) {
        answers.add({
          'questionId': _currentQuestions[i].id,
          'selectedAnswer': _userAnswers[i],
          'timeTaken': 0,
        });
      }
    }
    return answers;
  }

  int get calculatedScore {
    int score = 0;
    for (int i = 0; i < _userAnswers.length; i++) {
      if (_userAnswers[i] == _currentQuestions[i].correctAnswer) {
        score++;
      }
    }
    return score;
  }

  Future<Map<String, dynamic>> submitQuiz() async {
    try {
      _setLoading(true);

      if (_currentTopic == null) {
        throw Exception('No topic selected');
      }

      if (quizAnswers.isEmpty) {
        throw Exception('No answers to submit');
      }

      final response = await _apiService.submitQuiz(
        topicId: _currentTopic!.id,
        answers: quizAnswers,
        timeSpent: quizTimeSpent,
      );

      return response;
    } catch (error) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void resetQuiz() {
    _currentQuestions.clear();
    _currentTopic = null;
    _currentQuestionIndex = 0;
    _userAnswers.clear();
    _quizStartTime = null;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      Future.microtask(() {
        notifyListeners();
      });
    }
  }
}