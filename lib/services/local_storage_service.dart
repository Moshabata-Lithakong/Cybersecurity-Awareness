import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static const String _firstLaunchKey = 'first_launch';
  static const String _completedTutorialKey = 'completed_tutorial';
  static const String _notificationsEnabledKey = 'notifications_enabled';

  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  Future<bool> isFirstLaunch() async {
    final prefs = await _prefs;
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  Future<void> setFirstLaunchCompleted() async {
    final prefs = await _prefs;
    await prefs.setBool(_firstLaunchKey, false);
  }

  Future<bool> hasCompletedTutorial() async {
    final prefs = await _prefs;
    return prefs.getBool(_completedTutorialKey) ?? false;
  }

  Future<void> setTutorialCompleted() async {
    final prefs = await _prefs;
    await prefs.setBool(_completedTutorialKey, true);
  }

  Future<bool> areNotificationsEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }

  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}