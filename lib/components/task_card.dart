// task_card.dart
import 'package:flutter/material.dart';
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/screens/task_details_screen.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  TaskCard({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          task.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Time: ${task.dueTime}"),
            Text("Priority: ${task.priority.name}"),
            Text("Status: ${task.status.name}"),
          ],
        ),
        trailing: Icon(
          task.status == TaskStatus.pending
              ? Icons.hourglass_empty
              : Icons.check_circle_outline,
          color:
              task.status == TaskStatus.pending ? Colors.orange : Colors.green,
        ),
        onTap: onTap,
      ),
    );
  }
}
