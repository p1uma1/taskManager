import 'package:flutter/material.dart';
import 'package:taskmanager_new/models/task.dart';

class TaskUpdateScreen extends StatefulWidget {
  final Task task;

  TaskUpdateScreen({required this.task});

  @override
  _TaskUpdateScreenState createState() => _TaskUpdateScreenState();
}

class _TaskUpdateScreenState extends State<TaskUpdateScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dueDateController;
  late TextEditingController _dueTimeController;
  TaskPriority _priority = TaskPriority.medium;
  TaskStatus _status = TaskStatus.pending;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _dueDateController =
        TextEditingController(text: widget.task.dueDate.toString());
    _dueTimeController = TextEditingController(text: widget.task.dueTime);
    _priority = widget.task.priority;
    _status = widget.task.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    _dueTimeController.dispose();
    super.dispose();
  }

  void _updateTask() {
    Task updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: DateTime.parse(_dueDateController.text),
      dueTime: _dueTimeController.text,
      priority: _priority,
      status: _status,
      onNotification: widget.task.onNotification,
      category: widget.task.category,
      user: widget.task.user,
    );

    Navigator.pop(context, updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Task"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: _dueDateController,
              decoration: InputDecoration(labelText: "Due Date (yyyy-mm-dd)"),
            ),
            TextField(
              controller: _dueTimeController,
              decoration: InputDecoration(labelText: "Due Time (hh:mm)"),
            ),
            DropdownButton<TaskPriority>(
              value: _priority,
              onChanged: (TaskPriority? newPriority) {
                setState(() {
                  _priority = newPriority!;
                });
              },
              items: TaskPriority.values.map((TaskPriority priority) {
                return DropdownMenuItem<TaskPriority>(
                  value: priority,
                  child: Text(priority.toString().split('.').last),
                );
              }).toList(),
            ),
            DropdownButton<TaskStatus>(
              value: _status,
              onChanged: (TaskStatus? newStatus) {
                setState(() {
                  _status = newStatus!;
                });
              },
              items: TaskStatus.values.map((TaskStatus status) {
                return DropdownMenuItem<TaskStatus>(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTask,
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
