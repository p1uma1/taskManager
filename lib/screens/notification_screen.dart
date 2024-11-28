import 'package:flutter/material.dart';
import '../models/task_notification.dart';

class NotificationsScreen extends StatelessWidget {
  final List<TaskNotification> notifications;

  const NotificationsScreen({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blue,
      ),
      body: notifications.isNotEmpty
          ? ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  title: Text(notification.message),
                  subtitle:
                      Text('Scheduled for: ${notification.notificationDate}'),
                );
              },
            )
          : Center(
              child: Text(
                'No notifications!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
    );
  }
}
