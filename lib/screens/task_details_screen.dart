import 'package:flutter/material.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String taskTitle;
  final String taskDescription;
  final String dueTime;
  final DateTime dueDate;
  final String priority;
  final String status;

  TaskDetailsScreen({
    required this.taskTitle,
    required this.taskDescription,
    required this.dueTime,
    required this.dueDate,
    required this.priority,
    required this.status,
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
              taskTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              taskDescription,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Text("Due: ${dueDate.toLocal().toString().split(' ')[0]} at $dueTime"),
            SizedBox(height: 10),
            Text("Priority: $priority"),
            SizedBox(height: 10),
            Text("Status: $status"),
          ],
        ),
      ),
    );
  }
}
