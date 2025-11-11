import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cybersecurity_quiz_app/services/api_service.dart';
import 'package:cybersecurity_quiz_app/services/auth_service.dart';
import 'package:cybersecurity_quiz_app/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  String _error = '';
  bool _isAuthenticated = false;
  bool _isEmailVerified = false;
  String? _verificationEmail;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  bool get isEmailVerified => _isEmailVerified;
  String? get verificationEmail => _verificationEmail;

  Future<bool> checkAuthStatus() async {
    try {
      _setLoading(true);
      _error = '';

      final token = await _authService.getToken();
      final userData = await _authService.getUserData();

      if (token != null && userData != null) {
        final response = await _apiService.verifyToken();
        
        if (response['success'] == true) {
          final userJson = json.decode(userData);
          _user = User.fromJson(userJson);
          _isAuthenticated = true;
          _isEmailVerified = _user?.isVerified ?? false;
          _setLoading(false);
          notifyListeners();
          return true;
        } else {
          await _authService.clearAuthData();
        }
      }

      _isAuthenticated = false;
      _user = null;
      _isEmailVerified = false;
      _setLoading(false);
      notifyListeners();
      return false;
    } catch (error) {
      if (kDebugMode) {
        print('Auth check error: $error');
      }
      await _authService.clearAuthData();
      _isAuthenticated = false;
      _user = null;
      _isEmailVerified = false;
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _error = '';

      print('🔄 Attempting login for: $email');

      final response = await _apiService.login({
        'email': email.trim(),
        'password': password,
      });

      print('📡 Login response: ${response['success']}');

      if (response['success'] == true) {
        final userData = response['data']['user'];
        final token = response['data']['token'];
        
        _user = User.fromJson(userData);
        _isAuthenticated = true;
        _isEmailVerified = _user?.isVerified ?? false;
        
        // ✅ Check if user is active
        final bool isActive = _user?.isActive ?? true;
        if (!isActive) {
          _error = 'Account has been deactivated. Please contact administrator.';
          _isAuthenticated = false;
          _user = null;
          _setLoading(false);
          notifyListeners();
          return false;
        }
        
        print('✅ Login successful for: ${_user?.email}');
        print('👑 User role: ${_user?.role}');
        print('✅ Verified: ${_user?.isVerified}');
        print('✅ Active: ${_user?.isActive}');

        // Save auth data
        await _authService.saveUserData(json.encode(userData));
        await _authService.saveToken(token);
        
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Login failed';
        print('❌ Login failed: $_error');
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      print('❌ Login error: $_error');
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      _setLoading(true);
      _error = '';

      // Validate inputs
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        _error = 'All fields are required';
        _setLoading(false);
        notifyListeners();
        return false;
      }

      if (password.length < 6) {
        _error = 'Password must be at least 6 characters';
        _setLoading(false);
        notifyListeners();
        return false;
      }

      final response = await _apiService.register({
        'username': username.trim(),
        'email': email.trim(),
        'password': password,
      });

      if (response['success'] == true) {
        // Store email for verification
        _verificationEmail = email;
        _isAuthenticated = false;
        _isEmailVerified = false;
        
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Registration failed';
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyEmail(String code) async {
    try {
      _setLoading(true);
      _error = '';

      if (_verificationEmail == null) {
        _error = 'No email to verify';
        _setLoading(false);
        notifyListeners();
        return false;
      }

      final response = await _apiService.verifyEmail({
        'email': _verificationEmail!,
        'code': code,
      });

      if (response['success'] == true) {
        final userData = response['data']['user'];
        final token = response['data']['token'];
        
        _user = User.fromJson(userData);
        _isAuthenticated = true;
        _isEmailVerified = true;
        
        await _authService.saveUserData(json.encode(userData));
        await _authService.saveToken(token);
        
        _verificationEmail = null;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Verification failed';
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendVerificationCode() async {
    try {
      _setLoading(true);
      _error = '';

      if (_verificationEmail == null) {
        _error = 'No email to verify';
        _setLoading(false);
        notifyListeners();
        return false;
      }

      final response = await _apiService.resendVerificationCode({
        'email': _verificationEmail!,
      });

      if (response['success'] == true) {
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to send verification code';
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future<bool> resendVerificationCode() async {
    return await sendVerificationCode();
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (error) {
      if (kDebugMode) {
        print('Logout API error: $error');
      }
    } finally {
      _user = null;
      _isAuthenticated = false;
      _isEmailVerified = false;
      _verificationEmail = null;
      _error = '';
      await _authService.clearAuthData();
      notifyListeners();
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  String _extractErrorMessage(dynamic error) {
    if (error is String) {
      return error;
    } else if (error.toString().contains('SocketException')) {
      return 'Network error: Please check your internet connection';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Request timeout: Please try again';
    } else if (error.toString().contains('HttpException')) {
      return error.toString().replaceAll('HttpException: ', '');
    } else {
      return 'An unexpected error occurred: ${error.toString()}';
    }
  }

  String get displayName {
    if (_user?.username != null) {
      return _user!.username!;
    } else if (_user?.email != null) {
      return _user!.email!.split('@').first;
    }
    return 'User';
  }

  String get userInitial {
    if (_user?.username != null && _user!.username!.isNotEmpty) {
      return _user!.username![0].toUpperCase();
    } else if (_user?.email != null && _user!.email!.isNotEmpty) {
      return _user!.email![0].toUpperCase();
    }
    return 'U';
  }

  bool get isAdmin {
    return _user?.role == 'admin';
  }

  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    try {
      _setLoading(true);
      _error = '';

      final response = await _apiService.updateUserProfile(updates);
      
      if (response['success'] == true) {
        final updatedUser = User.fromJson(response['data']);
        _user = updatedUser;
        
        await _authService.saveUserData(json.encode(updatedUser.toJson()));
        
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Profile update failed';
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } catch (error) {
      _error = _extractErrorMessage(error);
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future<bool> handleLoginWithVerification(String email) async {
    try {
      _verificationEmail = email;
      _isAuthenticated = false;
      _isEmailVerified = false;
      _error = 'Please verify your email before logging in';
      notifyListeners();
      return false;
    } catch (error) {
      _error = _extractErrorMessage(error);
      notifyListeners();
      return false;
    }
  }

  void clearVerificationState() {
    _verificationEmail = null;
    _error = '';
    notifyListeners();
  }

  bool get requiresEmailVerification {
    return _verificationEmail != null && !_isEmailVerified;
  }
}