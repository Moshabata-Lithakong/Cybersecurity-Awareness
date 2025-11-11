import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cybersecurity_quiz_app/providers/auth_provider.dart';
import 'package:cybersecurity_quiz_app/providers/quiz_provider.dart';
import 'package:cybersecurity_quiz_app/providers/user_provider.dart';
import 'package:cybersecurity_quiz_app/providers/resources_provider.dart';
import 'package:cybersecurity_quiz_app/providers/settings_provider.dart';
import 'package:cybersecurity_quiz_app/providers/notification_provider.dart';
import 'package:cybersecurity_quiz_app/services/download_service.dart';
import 'package:cybersecurity_quiz_app/screens/landing_screen.dart';
import 'package:cybersecurity_quiz_app/screens/home_screen.dart';
import 'package:cybersecurity_quiz_app/screens/admin_dashboard_screen.dart';
import 'package:cybersecurity_quiz_app/screens/auth/email_verification_screen.dart';
import 'package:cybersecurity_quiz_app/utils/themes.dart';
import 'package:cybersecurity_quiz_app/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Test backend connection on app start
  await _testBackendConnection();
  
  runApp(const MyApp());
}

// Test backend connection
Future<void> _testBackendConnection() async {
  final apiService = ApiService();
  final result = await apiService.testConnection();
  
  if (result['success'] == true) {
    print('✅ Backend connection successful: ${result['message']}');
  } else {
    print('❌ Backend connection failed: ${result['message']}');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()), // ADDED THIS LINE
        ChangeNotifierProvider(
          create: (_) => ResourcesProvider(DownloadService()),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'CyberGuard LK',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light, // Connect to settings
            home: const AppWrapper(),
          );
        },
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkAuthStatus();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ),
      );
    }

    // Route based on authentication, role, and email verification
    if (authProvider.isAuthenticated) {
      // Check if email needs verification
      if (!authProvider.isEmailVerified && authProvider.verificationEmail != null) {
        return const EmailVerificationScreen();
      }
      
      if (authProvider.isAdmin) {
        return const AdminDashboardScreen();
      } else {
        return const HomeScreen();
      }
    } else {
      return const LandingScreen();
    }
  }
}