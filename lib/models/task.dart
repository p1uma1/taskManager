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
  });

  /// Automatically determine status based on the current date and dueDate
  TaskStatus _determineStatus() {
    final now = DateTime.now();
    if (now.isAfter(dueDate)) {
      return TaskStatus.overdue;
    }
    return TaskStatus.pending;
  }

  /// Factory to create a new `Task` with updated fields
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? dueTime,
    TaskPriority? priority,
    TaskStatus? status,
    bool? onNotification,
    String? categoryId,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id, // Allow changing ID only if provided
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      status: status ?? this._determineStatus(), // Auto-determine status
      onNotification: onNotification ?? this.onNotification,
      categoryId: categoryId ?? this.categoryId,
      userId: userId ?? this.userId, // Allow user ID change only if needed
    );
  }

  /// Convert `Task` to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'dueTime': dueTime,
      'priority': priority.name, // Store as string (name)
      'status': status.name, // Store as string (name)
      'onNotification': onNotification,
      'categoryId': categoryId, // Store category reference if exists
      'userId': userId,
    };
  }

  /// Create `Task` from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      dueTime: json['dueTime'] as String,
      priority:
          TaskPriority.values.firstWhere((e) => e.name == json['priority']),
      status: TaskStatus.values.firstWhere((e) => e.name == json['status']),
      onNotification: json['onNotification'] as bool,
      categoryId: json['categoryId'] as String?,
      userId: json['userId'] as String,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, categoryId: $categoryId, status: $status, dueDate: $dueDate)';
  }
}
