import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../services/task_service.dart';

class TaskNotifier extends ChangeNotifier {
  final TaskService taskService;
  List<Task> _tasks = [];
  bool _isLoading = false;

  TaskNotifier({required this.taskService});

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await taskService.getTasksForUser(userId);
    } catch (e) {
      print("Error fetching tasks: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    await taskService.createTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    await taskService.deleteTask(taskId);
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }
}
