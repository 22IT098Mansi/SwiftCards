import '../models/notification_model.dart';
import 'local_storage_service.dart';

class NotificationService {
  final LocalStorageService _localStorage;

  NotificationService(this._localStorage);

  Future<void> init() async {}
  Future<List<NotificationModel>> getNotificationHistory() async => [];
  Future<void> markAsRead(String notificationId) async {}
  Future<void> scheduleExpiryReminder(String cardId, String cardName, DateTime expiryDate) async {}
  Future<void> showRewardNotification() async {}

  // Add any methods for local storage notification management here if needed in the future.
} 