import 'task.dart';

class RecycleBin {
  final String id;
  final DateTime deleteDate;
  final Task task;

  RecycleBin({
    required this.id,
    required this.deleteDate,
    required this.task,
  });

  // Convert RecycleBin to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deleteDate': deleteDate.toIso8601String(),
      'task': task.toJson(),
    };
  }

  // Create RecycleBin from JSON
  factory RecycleBin.fromJson(Map<String, dynamic> json) {
    return RecycleBin(
      id: json['id'],
      deleteDate: DateTime.parse(json['deleteDate']),
      task: Task.fromJson(Map<String, dynamic>.from(json['task'])),
    );
  }
}
