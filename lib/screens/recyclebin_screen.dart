import 'package:flutter/material.dart';
import 'package:taskmanager_new/services/task_service.dart';
import '../models/recyclebin.dart';

class RecycleBinScreen extends StatefulWidget {
  @override
  _RecycleBinScreenState createState() => _RecycleBinScreenState();
}

class _RecycleBinScreenState extends State<RecycleBinScreen> {
  final TaskService _taskService = TaskService();

  Future<void> _refreshRecycleBinItems() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recycle Bin",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<List<RecycleBin>>(
        future: _taskService.fetchRecycleBinItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load recycle bin tasks: ${snapshot.error}",
                style: TextStyle(fontSize: 16, color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No deleted tasks found.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final recycleBinItems = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshRecycleBinItems,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: recycleBinItems.length,
              itemBuilder: (context, index) {
                final binItem = recycleBinItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    leading: CircleAvatar(
                      backgroundColor: Colors.red.shade100,
                      child: Icon(Icons.delete, color: Colors.redAccent),
                    ),
                    title: Text(
                      binItem.task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      "Deleted on: ${binItem.deleteDate.toLocal().toString().split(' ')[0]}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'restore') {
                          await _taskService.restoreTask(binItem);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Task '${binItem.task.title}' restored.",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          );
                        } else if (value == 'delete') {
                          await _taskService.permanentlyDeleteTask(binItem);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Task '${binItem.task.title}' permanently deleted.",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          );
                        }
                        await _refreshRecycleBinItems();
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'restore',
                          child: Text(
                            "Restore",
                            style: TextStyle(fontSize: 14, color: Colors.green),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            "Permanently Delete",
                            style: TextStyle(fontSize: 14, color: Colors.red),
                          ),
                        ),
                      ],
                      icon: Icon(Icons.more_vert, color: Colors.grey[700]),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
