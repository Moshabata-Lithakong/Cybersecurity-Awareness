class AppConfig {
  static const String appName = 'CyberSafe Quiz';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Learn Cybersecurity through Interactive Quizzes';
  
  // API Configuration
  static const String baseUrl = 'http://localhost:5000/api';
  static const int apiTimeout = 30000;
  static const int maxRetries = 3;
  
  // Quiz Configuration
  static const int defaultQuestionsPerQuiz = 10;
  static const int maxQuizTime = 900; // 15 minutes in seconds
  static const double passingScore = 70.0;
  
  // App Settings
  static const bool enableAnimations = true;
  static const bool enableNotifications = true;
  static const bool enableAnalytics = false;
  
  // Feature Flags
  static const bool enableSocialFeatures = false;
  static const bool enableOfflineMode = false;
  static const bool enableDarkMode = true;
  
  // Local Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserData = 'user_data';
  static const String keyAppSettings = 'app_settings';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyCompletedTutorial = 'completed_tutorial';
}

class FeatureFlags {
  static bool get isSocialEnabled => AppConfig.enableSocialFeatures;
  static bool get isOfflineModeEnabled => AppConfig.enableOfflineMode;
  static bool get isDarkModeEnabled => AppConfig.enableDarkMode;
  static bool get isAnalyticsEnabled => AppConfig.enableAnalytics;
}