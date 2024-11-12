import 'package:flutter/material.dart';
import 'task_details_screen.dart';
import 'package:taskmanager_new/models/task.dart'; // Import the updated Task model
import 'package:taskmanager_new/models/category.dart';
import 'package:taskmanager_new/models/user.dart';

class HomeScreen extends StatelessWidget {
  final Category generalCategory = Category(1, "General", "General tasks", "icon.png");
  final User currentUser = User(id:"1",  name:"John Doe", email: "john.doe@example.com");

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Text(
              "Upcoming Tasks",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),Text(
              "Overdue Tasks",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          color: task.status == TaskStatus.pending ? Colors.orange : Colors.green,
        ),
        onTap: onTap,
      ),
    );
  }
}
