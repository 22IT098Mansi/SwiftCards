import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService;
  List<NotificationModel> _notifications = [];

  NotificationProvider(this._notificationService);

  List<NotificationModel> get notifications => _notifications;

  Future<void> loadNotifications() async {
    _notifications = await _notificationService.getNotificationHistory();
    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    await _notificationService.markAsRead(notificationId);
    await loadNotifications();
  }

  Future<void> scheduleExpiryReminder(String cardId, String cardName, DateTime expiryDate) async {
    await _notificationService.scheduleExpiryReminder(cardId, cardName, expiryDate);
  }

  Future<void> showRewardNotification() async {
    await _notificationService.showRewardNotification();
    await loadNotifications();
  }
} 