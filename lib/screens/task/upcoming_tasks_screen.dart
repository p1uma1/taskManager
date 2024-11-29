import 'package:flutter/material.dart';
import 'package:taskmanager_new/models/task.dart';
import 'task_details_screen.dart';
import 'package:taskmanager_new/components/task_card.dart';

class UpcomingTasksScreen extends StatelessWidget {
  final List<Task> upcomingTasks;

  UpcomingTasksScreen({required this.upcomingTasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upcoming Tasks"),
      ),
      body: ListView.builder(
        itemCount: upcomingTasks.length,
        itemBuilder: (context, index) {
          final task = upcomingTasks[index];
          return TaskCard(
            task: task,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TaskDetailsScreen(task: task, taskList: upcomingTasks),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
