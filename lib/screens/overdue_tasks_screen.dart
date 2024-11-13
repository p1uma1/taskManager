import 'package:flutter/material.dart';
import 'package:taskmanager_new/models/task.dart';
import 'task_details_screen.dart';
import 'package:taskmanager_new/components/task_card.dart';

class OverdueTasksScreen extends StatelessWidget {
  final List<Task> overdueTasks;

  OverdueTasksScreen({required this.overdueTasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Overdue Tasks"),
      ),
      body: ListView.builder(
        itemCount: overdueTasks.length,
        itemBuilder: (context, index) {
          final task = overdueTasks[index];
          return TaskCard(
            task: task,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsScreen(task: task),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
