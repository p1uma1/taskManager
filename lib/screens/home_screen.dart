// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskmanager_new/components/home_screen/home_content_screen.dart';
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/models/task_notification.dart';
import 'package:taskmanager_new/repositories/category_repository.dart';
import 'package:taskmanager_new/repositories/task_repository.dart';
import 'package:taskmanager_new/screens/category/category_list_screen.dart';
import 'package:taskmanager_new/screens/category/create_category.dart';
import 'package:taskmanager_new/screens/notification_screen.dart';
import 'package:taskmanager_new/screens/recyclebin_screen.dart';
import 'package:taskmanager_new/screens/task/add_task_screen.dart';
import 'package:taskmanager_new/services/NotificationHelper.dart';
import 'package:taskmanager_new/services/category_service.dart';
import 'package:taskmanager_new/services/task_service.dart';
import 'package:taskmanager_new/models/category.dart' as CategoryModel;
import 'package:taskmanager_new/components/side_nav_bar.dart'; // Import SideNavBar

class HomeScreen extends StatefulWidget {
  final CategoryRepository categoryRepository;
  final CategoryService categoryService;
  final TaskRepository taskRepository;
  final TaskService taskService;

  const HomeScreen({
    required this.taskService,
    required this.taskRepository,
    required this.categoryRepository,
    required this.categoryService,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<CategoryModel.Category> categories = [];
  late List<Task> tasks = [];
  late String? userId;
  List<TaskNotification> notifications = [];
  Widget _currentScreen = const SizedBox();

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    NotificationHelper.initialize();

    // Directly call _fetchData to load data when the screen is initialized
    _fetchData();
    _currentScreen = const Center(child: CircularProgressIndicator());
  }

  // Modify _fetchData to return a Future to make it usable with FutureBuilder (if needed)
  Future<void> _fetchData() async {
    if (userId != null) {
      try {
        final fetchedCategories = await widget.categoryService.getAllCategories();
        if (fetchedCategories == null || fetchedCategories.isEmpty) {
          debugPrint('No categories available');
          setState(() {
            categories = [];
          });
        } else {
          setState(() {
            categories = fetchedCategories;
          });
        }

        final fetchedTasks = await widget.taskService.getTasksForUser(userId!);
        if (fetchedTasks == null || fetchedTasks.isEmpty) {
          debugPrint('No tasks available for this user');
          setState(() {
            tasks = [];
          });
        } else {
          setState(() {
            tasks = fetchedTasks;
          });
        }



        setState(() {
          categories = fetchedCategories;
          tasks = fetchedTasks;
          _currentScreen = HomeContentScreen(
            categoryService: widget.categoryService,
            taskService: widget.taskService,
          );
        });
      } catch (e) {
        debugPrint('Error tchtching data: $e');
        setState(() {
          _currentScreen = Center(child: Text('Error fetching data: $e'));
        });
      }
    } else {
      setState(() {
        _currentScreen = Center(child: Text('User not logged in.'));
      });
    }
  }

  // Method to handle navigation
  void _handleNavigation(String route) {
    setState(() {
      if (route == 'home' && _currentScreen is! HomeContentScreen) {
        _currentScreen = HomeContentScreen(
          categoryService: widget.categoryService,
          taskService: widget.taskService,
        );
      } else if (route == 'recycle_bin' && _currentScreen is! RecycleBinScreen) {
        _currentScreen = RecycleBinScreen();
      } else if (route == 'categories' &&
          _currentScreen is! CategoryListScreen) {
        _currentScreen =
            CategoryListScreen(categoryService: widget.categoryService);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
        centerTitle: true,
      ),
      body: _currentScreen, // Display the current screen
      drawer: SideNavBar(onItemSelected: _handleNavigation),
    );
  }

  void _addNewTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

}

