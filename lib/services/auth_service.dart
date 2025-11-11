import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  Future<void> saveToken(String token) async {
    try {
      if (token.isNotEmpty) {
        print('💾 Saving token to secure storage: ${token.substring(0, 20)}...');
        await _secureStorage.write(key: _tokenKey, value: token);
        print('✅ Token saved successfully to secure storage');
      }
    } catch (e) {
      print('❌ Error saving token to secure storage: $e');
      // Fallback to SharedPreferences if secure storage fails
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        print('💾 Token saved to SharedPreferences as fallback');
      } catch (e2) {
        print('❌ Error saving token to SharedPreferences: $e2');
      }
    }
  }

  Future<String?> getToken() async {
    try {
      // Try secure storage first
      print('🔍 Retrieving token from secure storage...');
      String? token = await _secureStorage.read(key: _tokenKey);
      
      if (token != null && token.isNotEmpty) {
        print('✅ Token retrieved from secure storage: ${token.substring(0, 20)}...');
        return token;
      }
      
      print('⚠️ No token found in secure storage, trying SharedPreferences...');
      // Fallback to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString(_tokenKey);
      
      if (token != null && token.isNotEmpty) {
        print('✅ Token retrieved from SharedPreferences: ${token.substring(0, 20)}...');
        return token;
      }
      
      print('❌ No token found in any storage');
      return null;
    } catch (e) {
      print('❌ Error reading token: $e');
      // Final fallback to SharedPreferences only
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(_tokenKey);
        if (token != null && token.isNotEmpty) {
          print('✅ Token retrieved from SharedPreferences (fallback): ${token.substring(0, 20)}...');
        }
        return token;
      } catch (e2) {
        print('❌ Error reading token from SharedPreferences: $e2');
        return null;
      }
    }
  }

  Future<void> saveUserData(String userData) async {
    try {
      if (userData.isNotEmpty) {
        print('💾 Saving user data to SharedPreferences');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userDataKey, userData);
        print('✅ User data saved successfully');
      }
    } catch (e) {
      print('❌ Error saving user data: $e');
    }
  }

  Future<String?> getUserData() async {
    try {
      print('🔍 Retrieving user data from SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userDataKey);
      
      if (userData != null && userData.isNotEmpty) {
        print('✅ User data retrieved successfully');
      } else {
        print('⚠️ No user data found');
      }
      
      return userData;
    } catch (e) {
      print('❌ Error reading user data: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getParsedUserData() async {
    try {
      final userDataString = await getUserData();
      if (userDataString != null && userDataString.isNotEmpty) {
        print('🔍 Parsing user data...');
        try {
          // Try to parse as JSON first
          final parsedData = json.decode(userDataString);
          print('✅ User data parsed as JSON');
          return parsedData;
        } catch (e) {
          // If JSON parsing fails, treat as simple string
          print('⚠️ User data is not valid JSON, treating as string');
          final cleanData = userDataString.replaceAll('"', '');
          return {'username': cleanData};
        }
      }
      print('⚠️ No user data to parse');
      return null;
    } catch (e) {
      print('❌ Error parsing user data: $e');
      return null;
    }
  }

  Future<void> clearAuthData() async {
    try {
      print('🗑️ Clearing all auth data...');
      
      // Clear secure storage
      await _secureStorage.delete(key: _tokenKey);
      print('✅ Token cleared from secure storage');
      
      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userDataKey);
      print('✅ Auth data cleared from SharedPreferences');
      
    } catch (e) {
      print('❌ Error clearing auth data: $e');
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      print('🔐 Checking authentication status...');
      final token = await getToken();
      final isAuth = token != null && token.isNotEmpty;
      
      if (isAuth) {
        print('✅ User is authenticated');
      } else {
        print('❌ User is not authenticated');
      }
      
      return isAuth;
    } catch (e) {
      print('❌ Error checking authentication: $e');
      return false;
    }
  }

  // Helper method to check if we have a valid token structure
  Future<bool> hasValidToken() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return false;
    
    // Basic validation - JWT tokens typically have 3 parts separated by dots
    final parts = token.split('.');
    return parts.length == 3;
  }
}