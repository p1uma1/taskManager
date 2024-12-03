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
      await taskService.moveToRecycleBin(task);
      Navigator.of(context).pop(); // Close details screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task "${task.title}" deleted successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete task. Please try again later.' +
              error.toString()),
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
        title: Text(
          'Task Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Poppins',
            letterSpacing: 2,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  task.description,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Text(
                      'Due Date: ${task.dueDate}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.priority_high, color: Colors.orangeAccent),
                    const SizedBox(width: 8),
                    Text(
                      'Priority: ${task.priority.name}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.task, color: Colors.greenAccent),
                    const SizedBox(width: 8),
                    Text(
                      'Status: ${task.status.name}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _updateTask(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(Icons.edit),
                      label: const Text('Update Task',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ElevatedButton.icon(
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
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(Icons.delete),
                      label: const Text('Delete Task',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
