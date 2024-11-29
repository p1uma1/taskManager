import 'package:flutter/material.dart';
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/models/category.dart';
import 'package:taskmanager_new/services/task_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TaskService _taskService = TaskService();

  String _title = '';
  String _description = '';
  DateTime _dueDate = DateTime.now();
  String _dueTime = '';
  TaskPriority _priority = TaskPriority.medium;
  Category? _selectedCategory;

  // Predefined categories (replace with real categories from your database or state)
  final List<Category> _categories = [
    Category(
      id: 'work',
      name: 'Work',
      description: 'Work-related tasks',
      icon: 'work_icon.png',
    ),
    Category(
      id: 'personal',
      name: 'Personal',
      description: 'Personal tasks',
      icon: 'personal_icon.png',
    ),
  ];

  // Utility method to combine due date and time
  DateTime _combineDateAndTime() {
    if (_dueTime.isEmpty) {
      return _dueDate; // If no due time, just use the due date
    }
    final timeParts = _dueTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1].split(' ')[0]);
    final amPm = timeParts[1].split(' ')[1].toUpperCase();

    // Adjust hour for AM/PM
    final adjustedHour = (amPm == 'PM' && hour != 12) ? hour + 12 : hour;
    return DateTime(
      _dueDate.year,
      _dueDate.month,
      _dueDate.day,
      adjustedHour,
      minute,
    );
  }

  // Method to pick a date
  Future<void> _pickDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  // Method to pick a time
  Future<void> _pickDueTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDate),
    );

    if (pickedTime != null) {
      setState(() {
        _dueTime = '${pickedTime.hour}:${pickedTime.minute} ${pickedTime.period.toString().split('.').last}';
      });
    }
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          throw Exception("User not logged in");
        }

        // Combine due date and time
        final fullDueDate = _combineDateAndTime();

        final newTask = Task(
          id: '', // Firebase will generate the ID
          title: _title,
          description: _description,
          dueDate: fullDueDate,
          dueTime: _dueTime,
          priority: _priority,
          userId: user.uid,
          categoryId: _selectedCategory?.id, // Use only the categoryId
        );

        await _taskService.createTask(newTask);

        Navigator.pop(context, newTask); // Return the new task
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save task: $e')),
        );
      }
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a title' : null,
                  onSaved: (value) => _title = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (value) => _description = value!,
                ),
                Row(
                  children: [
                    Text(
                      'Due Date: ${_dueDate.toLocal()}'.split(' ')[0],
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: _pickDueDate,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Due Time: $_dueTime',
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: _pickDueTime,
                    ),
                  ],
                ),
                DropdownButtonFormField<TaskPriority>(
                  value: _priority,
                  decoration: InputDecoration(labelText: 'Priority'),
                  items: TaskPriority.values
                      .map(
                        (priority) => DropdownMenuItem(
                      value: priority,
                      child: Text(priority.toString().split('.').last),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _priority = value!;
                    });
                  },
                ),
                DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  decoration: InputDecoration(labelText: 'Category'),
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
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
      ),
    );
  }
}
