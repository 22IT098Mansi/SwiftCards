import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart';
import '../models/notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Load notifications when the screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false).loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: AppTheme.titleStyle.copyWith(fontSize: 20),
        ),
        backgroundColor: AppTheme.secondaryColor,
        elevation: 0,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          if (notificationProvider.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: AppTheme.primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: AppTheme.subtitleStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'ll see your notifications here',
                    style: AppTheme.subtitleStyle.copyWith(fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppTheme.defaultPadding),
            itemCount: notificationProvider.notifications.length,
            itemBuilder: (context, index) {
              final notification = notificationProvider.notifications[index];
              return NotificationItem(notification: notification);
            },
          );
        },
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.defaultPadding),
      child: InkWell(
        onTap: () {
          Provider.of<NotificationProvider>(context, listen: false)
              .markAsRead(notification.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      notification.title,
                      style: AppTheme.cardTitleStyle.copyWith(
                        color: notification.isRead
                            ? AppTheme.primaryColor.withOpacity(0.5)
                            : AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  if (!notification.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notification.body,
                style: AppTheme.cardSubtitleStyle,
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('MMM dd, yyyy hh:mm a').format(notification.timestamp),
                style: AppTheme.cardExpiryStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 