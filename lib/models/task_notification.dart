import 'task.dart';
import '../services/NotificationHelper.dart';

class TaskNotification {
  int id;
  DateTime notificationDate;
  String message;
  final Task task;

  TaskNotification({
    required this.id,
    required this.notificationDate,
    required this.message,
    required this.task,
  }) {
    if (notificationDate.isBefore(DateTime.now())) {
      throw ArgumentError('Notification date cannot be in the past.');
    }
  }

  /// Schedules a notification for the task
  void sendNotification() {
    NotificationHelper.scheduleNotification(
      id: id,
      title: task.title,
      body: message,
      scheduledDate: notificationDate,
    );
  }

  /// Cancels a scheduled notification
  void cancelNotification() {
    NotificationHelper.cancelNotification(id);
  }

  @override
  String toString() {
    return 'TaskNotification{id: $id, notificationDate: $notificationDate, message: $message, task: ${task.title}}';
  }
}
