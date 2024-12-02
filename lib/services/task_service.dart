import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/repositories/task_repository.dart';

class TaskService {
  final TaskRepository _taskRepository = TaskRepository();
  // Add a new task
  Future<void> createTask(Task task) async {
    await _taskRepository.addTask(task);
  }

  Future<List<Task>?> getUpcomingTasks(String userId) async {
    // Simulate network delay
    await _taskRepository.getUpcomingTasks(userId);
  }

  // Get all tasks for a specific user
  Future<List<Task>?> getTasksForUser(String userId) async {
    final tasks = await _taskRepository.fetchTasks(userId);
    if (tasks == null) return null;
    // Automatically update statuses based on due dates
    for (var task in tasks) {
      if (task.status == TaskStatus.pending ||
          task.status == TaskStatus.overdue) {
        task.status = task.dueDate.isBefore(DateTime.now())
            ? TaskStatus.overdue
            : TaskStatus.pending;
        await _taskRepository.updateTask(task);
      }
    }

    return tasks;
  }

  // Update a task
  Future<void> updateTask(Task task) async {
    await _taskRepository.updateTask(task);
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    await _taskRepository.deleteTask(taskId);
  }

  //move to recycle bin
  Future<void> moveToRecycleBin(Task task) async {
    await _taskRepository.moveToRecycleBin(task);
  }
}
