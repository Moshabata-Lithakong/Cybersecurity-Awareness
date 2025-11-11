import 'package:flutter/foundation.dart';
import 'package:cybersecurity_quiz_app/services/api_service.dart';
import 'package:cybersecurity_quiz_app/models/question_model.dart';
import 'package:cybersecurity_quiz_app/models/user_model.dart';
import 'package:cybersecurity_quiz_app/models/user_activity_model.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  UserProgressStats? _progressStats;
  List<QuizResult> _quizHistory = [];
  List<UserActivity> _recentActivities = [];
  List<User> _users = []; // Changed from AppUser to User
  bool _isLoading = false;
  String _error = '';

  UserProgressStats? get progressStats => _progressStats;
  List<QuizResult> get quizHistory => _quizHistory;
  List<UserActivity> get recentActivities => _recentActivities;
  List<User> get users => _users; // Changed from AppUser to User
  bool get isLoading => _isLoading;
  String get error => _error;
  int get totalUsers => _users.length;
  int get activeUsers => _users.where((user) => user.isActive).length;

  // Load all users from database (Admin only)
  Future<bool> loadUsers() async {
    try {
      _setLoading(true);
      _error = '';

      final response = await _apiService.getUsers();
      print('📡 Load users response: ${response['success']}');
      
      if (response['success'] == true) {
        final data = response['data'] as List? ?? [];
        print('👥 Users data received: ${data.length} users');
        
        _users = data.map((user) => User.fromJson(user)).toList();
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to load users';
        print('❌ Load users error: $_error');
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      print('❌ Load users exception: $_error');
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Update user in database (Admin only)
  Future<bool> updateUser(String id, Map<String, dynamic> updates) async {
    try {
      _setLoading(true);
      _error = '';

      print('🔄 Updating user $id with: $updates');
      final response = await _apiService.updateUser(id, updates);

      if (response['success'] == true) {
        print('✅ User updated successfully');
        await loadUsers(); // Reload users from database
        return true;
      } else {
        _error = response['message'] ?? 'Failed to update user';
        print('❌ Update user error: $_error');
        _setLoading(false);
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      print('❌ Update user exception: $_error');
      _setLoading(false);
      return false;
    }
  }

  // Delete user from database (Admin only)
  Future<bool> deleteUser(String id) async {
    try {
      _setLoading(true);
      _error = '';

      print('🗑️ Deleting user: $id');
      final response = await _apiService.deleteUser(id);

      if (response['success'] == true) {
        print('✅ User deleted successfully');
        _users.removeWhere((user) => user.id == id);
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to delete user';
        print('❌ Delete user error: $_error');
        _setLoading(false);
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      print('❌ Delete user exception: $_error');
      _setLoading(false);
      return false;
    }
  }

  // Toggle user status in database (Admin only)
  Future<bool> toggleUserStatus(String id, bool isActive) async {
    try {
      _setLoading(true);
      _error = '';

      print('🔄 Toggling user $id status to: $isActive');
      final response = await _apiService.updateUser(id, {
        'isActive': isActive,
      });

      if (response['success'] == true) {
        print('✅ User status updated successfully');
        await loadUsers(); // Reload users from database
        return true;
      } else {
        _error = response['message'] ?? 'Failed to update user status';
        print('❌ Toggle user status error: $_error');
        _setLoading(false);
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      print('❌ Toggle user status exception: $_error');
      _setLoading(false);
      return false;
    }
  }

  // Get user statistics for admin dashboard
  Future<Map<String, dynamic>> getUserStatistics() async {
    try {
      _setLoading(true);
      _error = '';

      print('📊 Loading user statistics');
      final response = await _apiService.getUserStatistics();
      
      if (response['success'] == true) {
        print('✅ User statistics loaded successfully');
        _setLoading(false);
        return response['data'] ?? {};
      } else {
        _error = response['message'] ?? 'Failed to load user statistics';
        print('❌ User statistics error: $_error');
        _setLoading(false);
        return {};
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      print('❌ User statistics exception: $_error');
      _setLoading(false);
      return {};
    }
  }

  // Get admin analytics
  Future<Map<String, dynamic>> getAdminAnalytics() async {
    try {
      _setLoading(true);
      _error = '';

      print('📈 Loading admin analytics');
      final response = await _apiService.getAdminAnalytics();
      
      if (response['success'] == true) {
        print('✅ Admin analytics loaded successfully');
        _setLoading(false);
        return response['data'] ?? {};
      } else {
        _error = response['message'] ?? 'Failed to load admin analytics';
        print('❌ Admin analytics error: $_error');
        _setLoading(false);
        return {};
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      print('❌ Admin analytics exception: $_error');
      _setLoading(false);
      return {};
    }
  }

  // Existing user functions
  Future<bool> loadUserProgress() async {
    try {
      _setLoading(true);
      _error = '';

      final response = await _apiService.getUserProgress();
      if (response['success'] == true) {
        _progressStats = UserProgressStats.fromJson(response['data']);
        _setLoading(false);
        return true;
      } else {
        _error = response['message'] ?? 'Failed to load progress';
        _setLoading(false);
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> loadQuizHistory({int limit = 10, int page = 1}) async {
    try {
      _setLoading(true);
      _error = '';

      final response = await _apiService.getQuizHistory(limit: limit, page: page);
      if (response['success'] == true) {
        _quizHistory = (response['data']['quizHistory'] as List)
            .map((result) => QuizResult.fromJson(result))
            .toList();
        _setLoading(false);
        return true;
      } else {
        _error = response['message'] ?? 'Failed to load quiz history';
        _setLoading(false);
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> loadRecentActivities() async {
    try {
      _setLoading(true);
      _error = '';

      final response = await _apiService.getUserActivities();
      if (response['success'] == true) {
        _recentActivities = (response['data'] as List)
            .map((activity) => UserActivity.fromJson(activity))
            .toList();
        _setLoading(false);
        return true;
      } else {
        _error = response['message'] ?? 'Failed to load activities';
        _setLoading(false);
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      _setLoading(false);
      return false;
    }
  }

  void addActivity(UserActivity activity) {
    _recentActivities.insert(0, activity);
    notifyListeners();
  }

  void recordQuizCompletion(String topicName, int score) {
    final activity = UserActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Completed $topicName Quiz',
      subtitle: 'Scored $score%',
      type: ActivityType.quizCompleted,
      timestamp: DateTime.now(),
      metadata: {'score': score, 'topic': topicName},
    );
    addActivity(activity);
  }

  void recordTopicMastery(String topicName) {
    final activity = UserActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Mastered $topicName',
      subtitle: 'Completed all challenges',
      type: ActivityType.topicMastered,
      timestamp: DateTime.now(),
      metadata: {'topic': topicName},
    );
    addActivity(activity);
  }

  void clearError() {
    _error = '';
    notifyListeners();
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
      return 'Server error: Please check if backend is running on localhost:5000';
    } else {
      return 'An unexpected error occurred: ${error.toString()}';
    }
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      Future.microtask(() => notifyListeners());
    }
  }
}

class UserProgressStats {
  final int totalQuizzesTaken;
  final double averageScore;
  final int totalQuestionsAnswered;
  final int correctAnswers;
  final Map<String, dynamic> stats;
  final List<CompletedTopic> completedTopics;

  UserProgressStats({
    required this.totalQuizzesTaken,
    required this.averageScore,
    required this.totalQuestionsAnswered,
    required this.correctAnswers,
    required this.stats,
    required this.completedTopics,
  });

  factory UserProgressStats.fromJson(Map<String, dynamic> json) {
    return UserProgressStats(
      totalQuizzesTaken: json['totalQuizzesTaken'] ?? 0,
      averageScore: (json['averageScore'] ?? 0).toDouble(),
      totalQuestionsAnswered: json['totalQuestionsAnswered'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
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

  int get learningStreak {
    return stats['learningStreak'] ?? 0;
  }
}