import 'package:flutter/material.dart';
// import 'package:taskmanager_new/models/category.dart';
import '../models/category.dart';
import '../models/recyclebin.dart';
import '../models/task.dart';
import '../models/user.dart';

class RecycleBinScreen extends StatelessWidget {
  // Example deleted tasks in the recycle bin
  final List<RecycleBin> recycleBinItems = [
    RecycleBin(
      1,
      DateTime.now().subtract(Duration(days: 2)),
      Task(
        id: 1,
        title: "Team Meeting",
        description: "Discuss project roadmap and timelines.",
        dueDate: DateTime.now(),
        dueTime: "10:00 AM",
        priority: TaskPriority.high,
        status: TaskStatus.pending,
        category: Category(1, "Work", "Work-related tasks", "work_icon.png"),
        user: User(id: "1", name: "Alice", email: "alice@example.com"),
      ),
    ),
    RecycleBin(
      2,
      DateTime.now().subtract(Duration(days: 1)),
      Task(
        id: 2,
        title: "Submit Report",
        description: "Submit the Q3 financial report.",
        dueDate: DateTime.now(),
        dueTime: "2:00 PM",
        priority: TaskPriority.medium,
        status: TaskStatus.pending,
        category: Category(2, "Finance", "Financial tasks", "finance_icon.png"),
        user: User(id: "2", name: "Bob", email: "bob@example.com"),
      ),
    ),
  ];

  void _restoreTask(BuildContext context, RecycleBin binItem) {
    // Logic to restore the task from the recycle bin
    print("Restored Task: ${binItem.task.title}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Task '${binItem.task.title}' restored.")),
    );
  }

  void _permanentlyDeleteTask(BuildContext context, RecycleBin binItem) {
    // Logic to permanently delete the task
    print("Permanently Deleted Task: ${binItem.task.title}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Task '${binItem.task.title}' permanently deleted.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recycle Bin"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: recycleBinItems.isEmpty
          ? Center(
              child: Text(
                "No deleted tasks found.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: recycleBinItems.length,
              itemBuilder: (context, index) {
                final binItem = recycleBinItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text(binItem.task.title),
                    subtitle: Text(
                        "Deleted on: ${binItem.deleteDate.toLocal().toString().split(' ')[0]}"),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'restore') {
                          _restoreTask(context, binItem);
                        } else if (value == 'delete') {
                          _permanentlyDeleteTask(context, binItem);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            value: 'restore',
                            child: Text("Restore"),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text("Permanently Delete"),
                          ),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
