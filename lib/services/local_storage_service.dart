import 'package:hive_flutter/hive_flutter.dart';
import '../models/loyalty_card.dart';
import '../models/notification_model.dart';

class LocalStorageService {
  static const String _cardsBoxName = 'loyaltyCards';
  static const String _notificationsBoxName = 'notifications';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(LoyaltyCardAdapter());
    Hive.registerAdapter(NotificationModelAdapter());
    await Hive.openBox<LoyaltyCard>(_cardsBoxName);
    await Hive.openBox<NotificationModel>(_notificationsBoxName);
  }

  // Card methods
  Future<void> saveCard(LoyaltyCard card) async {
    final box = Hive.box<LoyaltyCard>(_cardsBoxName);
    await box.put(card.id, card);
  }

  Future<List<LoyaltyCard>> getAllCards() async {
    final box = Hive.box<LoyaltyCard>(_cardsBoxName);
    return box.values.toList();
  }

  Future<void> deleteCard(String cardId) async {
    final box = Hive.box<LoyaltyCard>(_cardsBoxName);
    await box.delete(cardId);
  }

  Future<void> updateCard(LoyaltyCard card) async {
    final box = Hive.box<LoyaltyCard>(_cardsBoxName);
    await box.put(card.id, card);
  }

  // Notification methods
  Future<void> saveNotification(NotificationModel notification) async {
    final box = Hive.box<NotificationModel>(_notificationsBoxName);
    await box.put(notification.id, notification);
  }

  Future<List<NotificationModel>> getAllNotifications() async {
    final box = Hive.box<NotificationModel>(_notificationsBoxName);
    return box.values.toList();
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final box = Hive.box<NotificationModel>(_notificationsBoxName);
    final notification = box.get(notificationId);
    if (notification != null) {
      final updatedNotification = NotificationModel(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        timestamp: notification.timestamp,
        isRead: true,
        cardId: notification.cardId,
      );
      await box.put(notificationId, updatedNotification);
    }
  }
} 