import 'package:flutter/material.dart';
import 'package:taskmanager_new/services/task_service.dart';
import '../models/recyclebin.dart';
// import '../repositories/task_repository.dart'; // Ensure this path is correct

class RecycleBinScreen extends StatefulWidget {
  @override
  _RecycleBinScreenState createState() => _RecycleBinScreenState();
}

class _RecycleBinScreenState extends State<RecycleBinScreen> {
  final TaskService _taskService = TaskService();
  // final TaskRepository _repository = TaskRepository();

  //reload
  Future<void> _refreshRecycleBinItems() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recycle Bin"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<List<RecycleBin>>(
        // future: fetchRecycleBinItems(),
        future: _taskService.fetchRecycleBinItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load recycle bin tasks: ${snapshot.error}",
                style: TextStyle(fontSize: 18, color: Colors.red),
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

          return ListView.builder(
            itemCount: recycleBinItems.length,
            itemBuilder: (context, index) {
              final binItem = recycleBinItems[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(binItem.task.title),
                  subtitle: Text(
                      "Deleted on: ${binItem.deleteDate.toLocal().toString().split(' ')[0]}"),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'restore') {
                        // _restoreTask(context, binItem);
                        await _taskService.restoreTask(binItem);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Task '${binItem.task.title}' restored.")),
                        );
                      } else if (value == 'delete') {
                        // _permanentlyDeleteTask(context, binItem);
                        await _taskService.permanentlyDeleteTask(binItem);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Task '${binItem.task.title}' permanently deleted.")),
                        );
                      }
                      await _refreshRecycleBinItems();
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
          );
        },
      ),
    );
  }
}
