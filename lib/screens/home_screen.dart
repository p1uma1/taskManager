import 'package:flutter/material.dart';
import 'task_details_screen.dart';
import 'upcoming_tasks_screen.dart';
import 'overdue_tasks_screen.dart';
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/models/category.dart';
import 'package:taskmanager_new/models/user.dart';
import 'package:taskmanager_new/components/task_card.dart';

class HomeScreen extends StatelessWidget {
  final List<Task> tasks = [
    Task(
      id: 1,
      title: "Team Meeting",
      description: "Discuss project roadmap and timelines.",
      dueDate: DateTime.now().add(Duration(hours: 2)),
      dueTime: "10:00 AM",
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      category: Category(1, "Work", "Work-related tasks", "work_icon.png"),
      user: User(id: "1", name: "Alice", email: "alice@example.com"),
    ),
    Task(
      id: 2,
      title: "Submit Report",
      description: "Submit the Q3 financial report.",
      dueDate: DateTime.now().add(Duration(days: 1)),
      dueTime: "2:00 PM",
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      category: Category(2, "Finance", "Financial tasks", "finance_icon.png"),
      user: User(id: "2", name: "Bob", email: "bob@example.com"),
    ),
  ];

  // Example upcoming and overdue tasks lists
  final List<Task> upcomingTasks = [
    Task(
      id: 3,
      title: "Prepare Presentation",
      description: "Prepare slides for next week's meeting.",
      dueDate: DateTime.now().add(Duration(days: 3)),
      dueTime: "4:00 PM",
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      category: Category(3, "Work", "Work-related tasks", "work_icon.png"),
      user: User(id: "1", name: "John", email: "john.doe@example.com"),
    ),
  ];

  final List<Task> overdueTasks = [
    Task(
      id: 4,
      title: "Renew Subscription",
      description: "Renew the software subscription before it expires.",
      dueDate: DateTime.now().subtract(Duration(days: 1)),
      dueTime: "5:00 PM",
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      category: Category(4, "Admin", "Administrative tasks", "admin_icon.png"),
      user: User(id: "2", name: "Alice", email: "alice@example.com"),
    ),
  ];

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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
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
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UpcomingTasksScreen(upcomingTasks: upcomingTasks),
                  ),
                );
              },
              child: Text(
                "Upcoming Tasks",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OverdueTasksScreen(overdueTasks: overdueTasks),
                  ),
                );
              },
              child: Text(
                "Overdue Tasks",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Task Screen (to be implemented)
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
