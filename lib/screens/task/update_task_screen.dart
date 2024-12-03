import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date and time
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/services/task_service.dart';

class UpdateTaskScreen extends StatefulWidget {
  final Task task;
  final TaskService taskService;

  UpdateTaskScreen({
    Key? key,
    required this.task,
    required this.taskService,
  }) : super(key: key);

  @override
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime dueDate;
  late String dueTime;
  late TaskPriority priority;
  late TaskStatus status;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    dueDate = widget.task.dueDate;
    dueTime = widget.task.dueTime;
    priority = widget.task.priority;
    status = widget.task.status;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != dueDate) {
      setState(() {
        dueDate = pickedDate;
      });
    }
  }

  Future<void> _pickDueTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(dueDate),
    );
    if (pickedTime != null) {
      setState(() {
        dueTime = pickedTime.format(context);
      });
    }
  }

  void _saveChanges() async {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    setState(() => isLoading = true);

    final updatedTask = widget.task.copyWith(
      title: titleController.text,
      description: descriptionController.text,
      dueDate: dueDate,
      dueTime: dueTime,
      priority: priority,
      status: status,
    );

    try {
      await widget.taskService.updateTask(updatedTask);
      Navigator.pop(context, updatedTask);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title: Text("Update Task"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Task Title",
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Task Description",
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Due Date: ${DateFormat.yMMMd().format(dueDate)}"),
                TextButton(
                  onPressed: _pickDueDate,
                  child: Text("Change Date"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Due Time: $dueTime"),
                TextButton(
                  onPressed: _pickDueTime,
                  child: Text("Change Time"),
                ),
              ],
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<TaskPriority>(
              value: priority,
              decoration: InputDecoration(
                labelText: "Priority",
                border: OutlineInputBorder(),
              ),
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
                  priority = value!;
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<TaskStatus>(
              value: status,
              decoration: InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
              items: TaskStatus.values
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.toString().split('.').last),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  status = value!;
                });
              },
            ),
            SizedBox(height: 24),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _saveChanges,
                    child: Text("Save Changes"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
