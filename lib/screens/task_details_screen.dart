import 'package:flutter/material.dart';
import 'package:taskmanager_new/models/task.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  TaskDetailsScreen({required this.task});

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
          ],
        ),
      ),
    );
  }
}
