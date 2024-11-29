import 'package:flutter/material.dart';
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/services/task_service.dart';
import 'package:taskmanager_new/screens/task/task_details_screen.dart';
import 'package:taskmanager_new/components/task_card.dart';

class UpcomingTasksScreen extends StatelessWidget {
  final TaskService taskService;
  String userId;
  // Constructor only needs taskService
  UpcomingTasksScreen({required this.taskService, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upcoming Tasks"),
      ),
      body: FutureBuilder<List<Task>?>(
        // Fetch upcoming tasks from the taskService asynchronously
        future: taskService.getUpcomingTasks(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while tasks are being fetched
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle empty list scenario
            return Center(child: Text('No upcoming tasks.'));
          } else {
            // Render the list of tasks if data is available
            final upcomingTasks = snapshot.data!;
            return ListView.builder(
              itemCount: upcomingTasks.length,
              itemBuilder: (context, index) {
                final task = upcomingTasks[index];
                return TaskCard(
                  task: task,
                  onTap: () {
                    // Navigate to task details screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsScreen(
                          task: task,
                          taskService: taskService, // Pass taskService to TaskDetailsScreen
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
