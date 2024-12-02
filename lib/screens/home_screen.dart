import 'package:flutter/foundation.dart';
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
    _fetchData();
    _currentScreen = const Center(child: CircularProgressIndicator());
  }

  // Method to fetch tasks and categories with error handling
  void _fetchData() async {
    if (userId != null) {
      try {
        final fetchedCategories = await widget.categoryService.fetchCategoriesByUserId(userId!);
        final fetchedTasks = await widget.taskService.getTasksForUser(userId!);

        setState(() {
          categories = fetchedCategories;
          tasks = fetchedTasks;
          _currentScreen = HomeContentScreen(
            categoryService: widget.categoryService,
            taskService: widget.taskService,
          );
        });
      } catch (e) {
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
      if (route == 'home') {
        _currentScreen = HomeContentScreen(
          categoryService: widget.categoryService,
          taskService: widget.taskService,
        );
      } else if (route == 'recycle_bin') {
        _currentScreen = RecycleBinScreen();  // Add this screen if required
      } else if (route == 'categories') {
        _currentScreen = CategoryListScreen(categoryService: widget.categoryService);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateCategoryScreen(
                    categoryService: widget.categoryService,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                if (notifications.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${notifications.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsScreen(notifications: notifications),
                ),
              );
            },
          ),
        ],
      ),
      drawer: SideNavBar( // Replace your custom drawer with the imported SideNavBar
        onItemSelected: _handleNavigation, // Pass the navigation function
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final newTask = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTaskScreen()),
            );
            if (newTask != null && newTask is Task) {
              _addNewTask(newTask);
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error creating new task: $e'),
            ));
          }
        },
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6.0,
        tooltip: 'Add Task',
        child: Icon(
          Icons.add,
          size: 28,
        ),
      ),
      body: _currentScreen,
    );
  }

  void _addNewTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }
}
