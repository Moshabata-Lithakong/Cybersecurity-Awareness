import 'package:flutter/material.dart';
import 'package:cybersecurity_quiz_app/models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  List<AppNotification> _notifications = [];
  bool _hasUnreadNotifications = false;

  List<AppNotification> get notifications => _notifications;
  bool get hasUnreadNotifications => _hasUnreadNotifications;

  Future<void> loadNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    _notifications = [
      AppNotification(
        id: '1',
        title: 'New Quiz Available',
        message: 'A new quiz on Network Security has been added',
        type: NotificationType.quizAdded,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
        data: {'topicId': 'network_security', 'adminName': 'System Admin'},
      ),
    ];
    
    _hasUnreadNotifications = _notifications.any((notification) => !notification.isRead);
    notifyListeners();
  }

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    _hasUnreadNotifications = true;
    notifyListeners();
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _hasUnreadNotifications = _notifications.any((notification) => !notification.isRead);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    _hasUnreadNotifications = false;
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    _hasUnreadNotifications = false;
    notifyListeners();
  }

  int get unreadCount {
    return _notifications.where((notification) => !notification.isRead).length;
  }
}