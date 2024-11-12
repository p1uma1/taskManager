import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager"),
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
                  TaskCard("Meeting with Team", "10:00 AM"),
                  TaskCard("Submit Report", "2:00 PM"),
                ],
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                // Navigate to Add Task Screen
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String time;

  TaskCard(this.title, this.time);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text("Due: $time"),
        trailing: Icon(Icons.check_circle_outline),
      ),
    );
  }
}
