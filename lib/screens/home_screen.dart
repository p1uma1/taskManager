import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskmanager_new/components/home_screen/home_content_screen.dart';
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/models/task_notification.dart';
import 'package:taskmanager_new/repositories/category_repository.dart';
import 'package:taskmanager_new/repositories/task_repository.dart';
import 'package:taskmanager_new/services/NotificationHelper.dart';
import 'package:taskmanager_new/services/category_service.dart';
import 'package:taskmanager_new/services/task_service.dart';
import 'package:taskmanager_new/models/category.dart'; // Make sure the import is correct

class HomeScreen extends StatefulWidget {
  final CategoryRepository categoryRepository;
  final CategoryService categoryService;
  final TaskRepository taskRepository;
  final TaskService taskService;

  HomeScreen({
    required this.taskService,
    required this.taskRepository,
    required this.categoryRepository,
    required this.categoryService,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late List<Category> categories = []; // Use your Category class
  late List<Task>? tasks = [];
  late String? userId;
  List<TaskNotification> notifications = [];
  Widget _currentScreen = const SizedBox();

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    NotificationHelper.initialize();
    _fetchData();
    _currentScreen = const Center(child: CircularProgressIndicator());
  }

  void _fetchData() async {
    if (userId != null) {
      final fetchedCategories = await widget.categoryService.getAllCategories();
      final fetchedTasks = await widget.taskService.getTasksForUser(userId!);
      setState(() {
        categories = fetchedCategories;
        tasks = fetchedTasks;
        _currentScreen = HomeContentScreen(
          tasks: tasks,
          categories: categories,
          categoryService: widget.categoryService,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _currentScreen,
    );
  }
}
