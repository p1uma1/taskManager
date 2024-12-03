import 'package:flutter/material.dart';
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/models/category.dart';
import 'package:taskmanager_new/services/category_service.dart';
import 'package:taskmanager_new/services/task_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final CategoryService categoryService;
  final TaskService taskService;
  const AddTaskScreen({
    required this.categoryService,
    required this.taskService,
  });

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
  Category? _selectedCategory;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await widget.categoryService.getAllCategories();
    setState(() {
      _categories = categories;
    });
  }

  DateTime _combineDateAndTime() {
    if (_dueTime.isEmpty) {
      return _dueDate; // If no due time, just use the due date
    }
    final timeParts = _dueTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1].split(' ')[0]);
    final amPm = timeParts[1].split(' ')[1].toUpperCase();

    final adjustedHour = (amPm == 'PM' && hour != 12) ? hour + 12 : hour;
    return DateTime(
      _dueDate.year,
      _dueDate.month,
      _dueDate.day,
      adjustedHour,
      minute,
    );
  }

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

  Future<void> _pickDueTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDate),
    );

    if (pickedTime != null) {
      setState(() {
        _dueTime =
            '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')} '
            '${pickedTime.period == DayPeriod.am ? 'AM' : 'PM'}';
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

        final fullDueDate = _combineDateAndTime();

        final newTask = Task(
          id: '',
          title: _title,
          description: _description,
          dueDate: fullDueDate,
          dueTime: _dueTime,
          priority: _priority,
          userId: user.uid,
          categoryId: _selectedCategory?.id,
        );

        await widget.taskService.createTask(newTask);

        Navigator.pop(context, newTask);
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
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add space between AppBar and body
              SizedBox(height: 16), // Adjust this value as needed

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12), // Fix overflow issue
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a title'
                          : null,
                      onSaved: (value) => _title = value!,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12), // Fix overflow issue
                      ),
                      onSaved: (value) => _description = value!,
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      title: Text(
                        'Due Date: ${DateFormat.yMMMd().format(_dueDate)}',
                      ),
                      trailing: OutlinedButton.icon(
                        onPressed: _pickDueDate,
                        icon: Icon(Icons.calendar_today),
                        label: Text('Select'),
                      ),
                    ),
                    ListTile(
                      title: Text('Due Time: $_dueTime'),
                      trailing: OutlinedButton.icon(
                        onPressed: _pickDueTime,
                        icon: Icon(Icons.access_time),
                        label: Text('Select'),
                      ),
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
                    SizedBox(height: 16),
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
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveTask,
                        child: Text('Save Task'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
