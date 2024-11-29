import 'package:flutter/material.dart';
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/screens/task/update_task_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;
  final List<Task> taskList; // List of tasks to update or delete from

  TaskDetailsScreen({
    required this.task,
    required this.taskList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(task.description),
            SizedBox(height: 10),
            Text("Due Date: ${task.dueDate}"),
            SizedBox(height: 10),
            Text("Priority: ${task.priority}"),
            SizedBox(height: 10),
            Text("Status: ${task.status}"),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Navigate to the task update screen
                    final updatedTask = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskUpdateScreen(task: task),
                      ),
                    );
                    if (updatedTask != null) {
                      updatedTask.update(
                        // Apply the changes made in the update screen
                        newTitle: updatedTask.title,
                        newDescription: updatedTask.description,
                        newDueDate: updatedTask.dueDate,
                        newDueTime: updatedTask.dueTime,
                        newPriority: updatedTask.priority,
                        newStatus: updatedTask.status,
                      );
                      // After updating, refresh the task list if necessary
                    }
                  },
                  child: Text("Update Task"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Confirm deletion
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Delete Task"),
                          content: Text(
                              "Are you sure you want to delete this task?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                task.delete(taskList); // Delete the task
                                Navigator.of(context).pop();
                                // Optionally, refresh the list of tasks after deletion
                              },
                              child: Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Delete Task"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
