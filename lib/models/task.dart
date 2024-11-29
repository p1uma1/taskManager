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

  // Method to create a new task
  static Task create({
    required String title,
    required String description,
    required DateTime dueDate,
    required String dueTime,
    required TaskPriority priority,
    required Category category,
    required User user,
  }) {
    return Task(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: description,
      dueDate: dueDate,
      dueTime: dueTime,
      priority: priority,
      category: category,
      user: user,
    );
  }

  // Method to update task details
  void update({
    String? newTitle,
    String? newDescription,
    DateTime? newDueDate,
    String? newDueTime,
    TaskPriority? newPriority,
    TaskStatus? newStatus,
  }) {
    if (newTitle != null) title = newTitle;
    if (newDescription != null) description = newDescription;
    if (newDueDate != null) dueDate = newDueDate;
    if (newDueTime != null) dueTime = newDueTime;
    if (newPriority != null) priority = newPriority;
    if (newStatus != null) status = newStatus;

    // Optionally, save the updated task to a database or local storage
    // e.g., Database.saveTask(this); or similar
  }

  // Method to delete the task
  void delete(List<Task> taskList) {
    taskList.removeWhere((task) => task.id == this.id);
    // Optionally, delete the task from a database or local storage as well
    // e.g., Database.deleteTask(this.id);
  }

  // Method to retrieve tasks (you can integrate with your storage)
  static List<Task> retrieveTasks() {
    // Simulate fetching tasks from a database or local storage
    return []; // Return a list of tasks from your storage system
  }

  // Calculate remaining time
  Duration get remainingTime => dueDate.difference(DateTime.now());

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
  factory Task.fromJson(
      Map<String, dynamic> json, Category category, User user) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      dueTime: json['dueTime'],
      priority: TaskPriority.values
          .firstWhere((e) => e.toString() == json['priority']),
      status:
          TaskStatus.values.firstWhere((e) => e.toString() == json['status']),
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
