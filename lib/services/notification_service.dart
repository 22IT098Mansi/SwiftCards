import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/notification_model.dart';
import 'local_storage_service.dart';

class NotificationService {
  static const String _notificationsBox = 'notifications';
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final LocalStorageService _localStorage;

  NotificationService(this._localStorage);

  Future<void> init() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications.initialize(initSettings);

    // Request permissions
    if (Platform.isIOS) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    // Initialize local storage
    await _localStorage.init();
  }

  Future<void> scheduleExpiryReminder(String cardId, String cardName, DateTime expiryDate) async {
    final threeDaysBefore = expiryDate.subtract(const Duration(days: 3));
    if (threeDaysBefore.isAfter(DateTime.now())) {
      await _localNotifications.zonedSchedule(
        cardId.hashCode,
        'Card Expiring Soon',
        'Your $cardName card expires in 3 days!',
        tz.TZDateTime.from(threeDaysBefore, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'card_expiry',
            'Card Expiry Reminders',
            channelDescription: 'Notifications for card expiry reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );

      // Save notification to history
      final notification = NotificationModel(
        id: cardId,
        title: 'Card Expiring Soon',
        body: 'Your $cardName card expires in 3 days!',
        timestamp: threeDaysBefore,
        cardId: cardId,
      );
      await _localStorage.saveNotification(notification);
    }
  }

  Future<void> showRewardNotification() async {
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch,
      'Perk Unlocked!',
      'You\'ve earned a new reward for storing 3 cards!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'rewards',
          'Reward Notifications',
          channelDescription: 'Notifications for rewards and perks',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );

    // Save notification to history
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Perk Unlocked!',
      body: 'You\'ve earned a new reward for storing 3 cards!',
      timestamp: DateTime.now(),
    );
    await _localStorage.saveNotification(notification);
  }

  Future<List<NotificationModel>> getNotificationHistory() async {
    return await _localStorage.getAllNotifications();
  }

  Future<void> markAsRead(String notificationId) async {
    await _localStorage.markNotificationAsRead(notificationId);
  }
} 