import 'package:flutter/material.dart';
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/models/category.dart';
import 'package:taskmanager_new/models/user.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  DateTime _dueDate = DateTime.now();
  String _dueTime = '';
  TaskPriority _priority = TaskPriority.medium;

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Save the task (replace with actual save logic)
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch,
        title: _title,
        description: _description,
        dueDate: _dueDate,
        dueTime: _dueTime,
        priority: _priority,
        category: Category(1, "Work", "Work-related tasks", "work_icon.png"),
        user: User(id: "1", name: "Alice", email: "alice@example.com"),
      );
      Navigator.pop(context, newTask); // Return the new task
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a title'
                    : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Due Time'),
                onSaved: (value) => _dueTime = value!,
              ),
              DropdownButtonFormField<TaskPriority>(
                value: _priority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: TaskPriority.values
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority.toString().split('.').last),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
