import 'package:flutter/material.dart';
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/services/task_service.dart';
import 'package:taskmanager_new/screens/task/update_task_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;
  final TaskService taskService;

  TaskDetailsScreen({
    required this.task,
    required this.taskService,
  });

  void _deleteTask(BuildContext context) async {
    try {
      await taskService.deleteTask(task.id);
      Navigator.of(context).pop(); // Close details screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task "${task.title}" deleted successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete task. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateTask(BuildContext context) async {
    try {
      // Navigate to update screen and wait for updated task
      final updatedTask = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateTaskScreen(
            task: task,
            taskService: taskService,
          ),
        ),
      );

      if (updatedTask != null) {
        await taskService.updateTask(updatedTask); // Save updates
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task "${task.title}" updated successfully!')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update task. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(task.description),
            const SizedBox(height: 10),
            Text('Due Date: ${task.dueDate}'),
            const SizedBox(height: 10),
            Text('Priority: ${task.priority}'),
            const SizedBox(height: 10),
            Text('Status: ${task.status}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _updateTask(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('Update Task'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Confirm task deletion
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Task'),
                          content: const Text(
                              'Are you sure you want to delete this task?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                                _deleteTask(context);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete Task'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
