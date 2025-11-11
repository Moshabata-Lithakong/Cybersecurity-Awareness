import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool _pushNotifications = true;
  bool _dataSaving = false;

  bool get isDarkMode => _isDarkMode;
  bool get pushNotifications => _pushNotifications;
  bool get dataSaving => _dataSaving;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void togglePushNotifications(bool value) {
    _pushNotifications = value;
    notifyListeners();
  }

  void toggleDataSaving(bool value) {
    _dataSaving = value;
    notifyListeners();
  }
}