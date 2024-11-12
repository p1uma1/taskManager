import 'category.dart';
import 'user.dart';

enum TaskStatus { pending, inProgress, completed, overdue }
enum TaskPriority { low, medium, high }

class Task {
  final int id;
  String title;
  String description;
  DateTime dueDate;
  String dueTime;
  TaskPriority priority;
  TaskStatus status;
  bool onNotification;

  final Category category;
  final User user;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.dueTime,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.onNotification = false,
    required this.category,
    required this.user,
  });

  // Calculate remaining time
  Duration get remainingTime => dueDate.difference(DateTime.now());

  // Mark task as complete
  void markComplete() {
    status = TaskStatus.completed;
  }


  // Convert Task to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'dueTime': dueTime,
      'priority': priority.toString(),
      'status': status.toString(),
      'onNotification': onNotification,
      'category': category.toJson(),
      'user': user.toJson(),
    };
  }

  // Create Task from JSON
  factory Task.fromJson(Map<String, dynamic> json, Category category, User user) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      dueTime: json['dueTime'],
      priority: TaskPriority.values.firstWhere((e) => e.toString() == json['priority']),
      status: TaskStatus.values.firstWhere((e) => e.toString() == json['status']),
      onNotification: json['onNotification'],
      category: category,
      user: user,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, status: $status, dueDate: $dueDate)';
  }
}
