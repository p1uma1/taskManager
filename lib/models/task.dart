import 'package:firebase_auth/firebase_auth.dart';

enum TaskStatus { pending, inProgress, completed, overdue }
enum TaskPriority { low, medium, high }

class Task {
  final String id; // Unique ID for the task
  String title;
  String description;
  DateTime dueDate;
  String dueTime;
  TaskPriority priority;
  TaskStatus status;
  bool onNotification;
  final String? categoryId; // Nullable reference to the Category ID
  final String userId; // Firebase Auth User ID

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.dueTime,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending, // Default status
    this.onNotification = false,
    this.categoryId, // Nullable Category ID
    required this.userId,
  }) {
    // Automatically initialize the status based on the dueDate
    if (status == TaskStatus.pending || status == TaskStatus.overdue) {
      status = _determineStatus();
    }
  }

  // Determine status based on the current date and dueDate
  TaskStatus _determineStatus() {
    final now = DateTime.now();
    if (now.isAfter(dueDate)) {
      return TaskStatus.overdue;
    }
    return TaskStatus.pending;
  }

  // CopyWith method for creating a new Task instance with modified properties
  Task copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    String? dueTime,
    TaskPriority? priority,
    TaskStatus? status,
    bool? onNotification,
    String? categoryId,
  }) {
    return Task(
      id: id, // ID is immutable
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      onNotification: onNotification ?? this.onNotification,
      categoryId: categoryId ?? this.categoryId,
      userId: userId, // User ID is immutable
    );
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
      'categoryId': categoryId, // Store category reference if exists
      'userId': userId,
    };
  }

  String? getCategoryId() {
    return categoryId;
  }

  // Create Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    // Parse the task from JSON
    final task = Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      dueTime: json['dueTime'],
      priority: TaskPriority.values
          .firstWhere((e) => e.toString() == json['priority']),
      status: TaskStatus.values
          .firstWhere((e) => e.toString() == json['status']),
      onNotification: json['onNotification'],
      categoryId: json['categoryId'], // Retrieve nullable category reference
      userId: json['userId'],
    );

    // Reinitialize the status based on the dueDate if needed
    if (task.status == TaskStatus.pending || task.status == TaskStatus.overdue) {
      task.status = task._determineStatus();
    }

    return task;
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, categoryId: $categoryId, status: $status, dueDate: $dueDate)';
  }
}

