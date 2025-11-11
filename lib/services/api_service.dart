import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cybersecurity_quiz_app/utils/constants.dart';
import 'package:cybersecurity_quiz_app/services/auth_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static const bool useMockService = false;
  
  // Use localhost for web development
  static const String baseUrl = 'https://cybersecurity-backend-clean.onrender.com';
  
  final AuthService _authService = AuthService();

  Future<Map<String, String>> get _headers async {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    final token = await _authService.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
      print('🔐 Using token for request: ${token.substring(0, 20)}...');
    } else {
      print('⚠️ No token found for request');
    }
    
    return headers;
  }

  Future<dynamic> _handleResponse(http.Response response) async {
    try {
      final responseData = json.decode(response.body);
      
      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': responseData['data'] ?? responseData,
          'message': responseData['message'] ?? 'Success',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? responseData['error'] ?? 'Something went wrong',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to parse response: ${e.toString()}',
        'statusCode': response.statusCode,
      };
    }
  }

  // ADDED: Generic HTTP methods with better error handling
  Future<dynamic> _get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _headers,
      );
      return await _handleResponse(response);
    } catch (e) {
      print('❌ GET $endpoint error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<dynamic> _post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _headers,
        body: json.encode(data),
      );
      return await _handleResponse(response);
    } catch (e) {
      print('❌ POST $endpoint error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<dynamic> _put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _headers,
        body: json.encode(data),
      );
      return await _handleResponse(response);
    } catch (e) {
      print('❌ PUT $endpoint error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<dynamic> _delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _headers,
      );
      return await _handleResponse(response);
    } catch (e) {
      print('❌ DELETE $endpoint error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<dynamic> testConnection() async {
    print('🔗 Testing connection to: $baseUrl');
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/'),
        headers: await _headers,
      );
      
      return await _handleResponse(response);
    } catch (e) {
      print('❌ Connection error: $e');
      return {
        'success': false,
        'message': 'Connection failed: ${e.toString()}',
      };
    }
  }

  // ==================== AUTH ENDPOINTS ====================

  Future<dynamic> login(Map<String, dynamic> credentials) async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _post('/auth/login', credentials);
  }

  Future<dynamic> register(Map<String, dynamic> userData) async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _post('/auth/register', userData);
  }

  Future<dynamic> logout() async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      await _authService.clearAuthData();
      return {'success': true};
    }

    try {
      final result = await _post('/auth/logout', {});
      await _authService.clearAuthData();
      return result;
    } catch (e) {
      await _authService.clearAuthData();
      return {'success': true}; // Always succeed logout even if API fails
    }
  }

  Future<dynamic> verifyToken() async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {'success': true};
    }
    return await _get('/auth/verify');
  }

  Future<dynamic> getCurrentUser() async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _get('/auth/me');
  }

  Future<dynamic> updateUserProfile(Map<String, dynamic> updates) async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _put('/auth/profile', updates);
  }

  // ==================== EMAIL VERIFICATION ENDPOINTS ====================

  Future<dynamic> verifyEmail(Map<String, dynamic> data) async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': true,
        'data': {
          'user': {
            '_id': 'mock-user-id',
            'username': data['email'].split('@').first,
            'email': data['email'],
            'role': 'student',
            'isVerified': true,
            'createdAt': DateTime.now().toIso8601String(),
          },
          'token': 'mock-jwt-token-verified',
        },
        'message': 'Email verified successfully',
      };
    }
    return await _post('/auth/verify-email', data);
  }

  Future<dynamic> resendVerificationCode(Map<String, dynamic> data) async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': true,
        'message': 'Verification code sent successfully',
      };
    }
    return await _post('/auth/resend-verification', data);
  }

  // ==================== TOPIC ENDPOINTS ====================

  Future<dynamic> getTopics() async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _get('/topics');
  }

  Future<dynamic> getTopicQuestions(String topicId) async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _get('/topics/$topicId/questions');
  }

  // ==================== QUIZ ENDPOINTS ====================

  Future<dynamic> submitQuiz({
    required String topicId,
    required List<dynamic> answers,
    required int timeSpent,
  }) async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _post('/quiz/submit', {
      'topicId': topicId,
      'answers': answers,
      'timeSpent': timeSpent,
    });
  }

  Future<dynamic> getQuizHistory({int limit = 10, int page = 1}) async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _get('/quiz/history?limit=$limit&page=$page');
  }

  Future<dynamic> getUserProgress() async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _get('/quiz/progress');
  }

  Future<dynamic> getUserActivities() async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _get('/quiz/activities');
  }

  // ==================== ADMIN ENDPOINTS ====================

  Future<dynamic> createTopic(Map<String, dynamic> topicData) async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _post('/admin/topics', topicData);
  }

  Future<dynamic> updateTopic(String id, Map<String, dynamic> topicData) async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _put('/admin/topics/$id', topicData);
  }

  Future<dynamic> deleteTopic(String id) async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _delete('/admin/topics/$id');
  }

  Future<dynamic> addQuestionsToTopic(String topicId, Map<String, dynamic> questionsData) async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _post('/admin/topics/$topicId/questions', questionsData);
  }

  Future<dynamic> getUsers() async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _get('/admin/users');
  }

  Future<dynamic> updateUser(String id, Map<String, dynamic> userData) async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _put('/admin/users/$id', userData);
  }

  Future<dynamic> deleteUser(String id) async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _delete('/admin/users/$id');
  }

  Future<dynamic> getAdminAnalytics() async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _get('/admin/analytics');
  }

  Future<dynamic> getUserStatistics() async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _get('/admin/statistics');
  }

  Future<dynamic> verifyAnswers(List<dynamic> answers) async {
    if (useMockService) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': false,
        'message': 'Mock service disabled. Please use real backend.',
      };
    }
    return await _post('/questions/verify', {'answers': answers});
  }
}