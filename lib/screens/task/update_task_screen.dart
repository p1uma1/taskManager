import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Task"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Task Title"),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Task Description"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update the task and return it to the previous screen
                final updatedTask = widget.task.copyWith(
                  title: titleController.text,
                  description: descriptionController.text,
                );
                widget.taskService.updateTask(updatedTask);
                Navigator.pop(context, updatedTask);
              },
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
