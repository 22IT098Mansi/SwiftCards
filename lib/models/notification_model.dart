import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 1)
class NotificationModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final bool isRead;

  @HiveField(5)
  final String? cardId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.cardId,
  });
} 