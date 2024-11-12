import 'package:flutter/material.dart';
import 'package:taskmanager_new/screens/task_details_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Tasks",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  TaskCard(
                    title: "Meeting with Team",
                    time: "10:00 AM",
                    description: "Discuss the project roadmap",
                    dueDate: DateTime.now(),
                    priority: "High",
                    status: "Pending",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailsScreen(
                            taskTitle: "Meeting with Team",
                            taskDescription: "Discuss the project roadmap",
                            dueTime: "10:00 AM",
                            dueDate: DateTime.now(),
                            priority: "High",
                            status: "Pending",
                          ),
                        ),
                      );
                    },
                  ),
                  TaskCard(
                    title: "Submit Report",
                    time: "2:00 PM",
                    description: "Finalize and submit the report to the manager",
                    dueDate: DateTime.now(),
                    priority: "Medium",
                    status: "Pending",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailsScreen(
                            taskTitle: "Submit Report",
                            taskDescription: "Finalize and submit the report to the manager",
                            dueTime: "2:00 PM",
                            dueDate: DateTime.now(),
                            priority: "Medium",
                            status: "Pending",
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Task Screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String description;
  final DateTime dueDate;
  final String priority;
  final String status;
  final VoidCallback onTap;

  TaskCard({
    required this.title,
    required this.time,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text("Due: $time"),
        trailing: Icon(Icons.check_circle_outline),
        onTap: onTap,
      ),
    );
  }
}
