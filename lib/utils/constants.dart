class AppConstants {
  static const String appName = 'CyberSafe Quiz';
  static const String appVersion = '1.0.0';
  
  // API Configuration - Use your computer's IP address
  static const String baseUrl = 'http://10.74.229.50:5000/api';
  
  static const int apiTimeout = 30000;
  
  // App Colors
  static const int primaryColorValue = 0xFF2563EB;
  static const int secondaryColorValue = 0xFF64748B;
  static const int accentColorValue = 0xFF10B981;
  static const int dangerColorValue = 0xFFEF4444;
  static const int warningColorValue = 0xFFF59E0B;
  
  // Quiz Settings
  static const int defaultQuizTime = 900; // 15 minutes in seconds
  static const int questionsPerQuiz = 10;
  static const double passingScore = 70.0;
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String settingsKey = 'app_settings';
  
  // Text Constants
  static const String loginTitle = 'Welcome Back';
  static const String registerTitle = 'Create Account';
  static const String appDescription = 'Learn cybersecurity through interactive quizzes and protect yourself online';
}

class RouteNames {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String topics = '/topics';
  static const String quiz = '/quiz';
  static const String results = '/results';
  static const String progress = '/progress';
  static const String profile = '/profile';
}

class AssetPaths {
  static const String images = 'assets/images/';
  static const String icons = 'assets/icons/';
  static const String fonts = 'assets/fonts/';
  
  // Image paths
  static const String logo = '${images}logo.png';
  static const String authBackground = '${images}auth_bg.jpg';
  static const String placeholder = '${images}placeholder.png';
  
  // Icon paths
  static const String homeIcon = '${icons}home.svg';
  static const String quizIcon = '${icons}quiz.svg';
  static const String progressIcon = '${icons}progress.svg';
  static const String profileIcon = '${icons}profile.svg';
}