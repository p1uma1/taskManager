import 'task.dart';
import '../services/NotificationHelper.dart';

class TaskNotification {
  final int id;
  final DateTime notificationDate;
  final String message;
  final Task task;

  TaskNotification({
    required this.id,
    required this.notificationDate,
    required this.message,
    required this.task,
  }) {
    // Ensure the notification date is not in the past
    if (notificationDate.isBefore(DateTime.now())) {
      throw ArgumentError('Notification date cannot be in the past.');
    }
  }

  /// Schedules a notification for the task





  @override
  String toString() {
    return 'TaskNotification{id: $id, notificationDate: $notificationDate, message: $message, task: ${task.title}}';
  }
}
