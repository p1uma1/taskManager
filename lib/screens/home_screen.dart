import 'package:flutter/material.dart';
import 'package:taskmanager_new/repositories/category_repository.dart';
import 'package:taskmanager_new/screens/category/category_list_screen.dart';
import 'package:taskmanager_new/services/NotificationHelper.dart';
import 'package:taskmanager_new/services/category_service.dart';
import 'recyclebin_screen.dart';
import 'task_details_screen.dart';
import 'add_task_screen.dart';
import 'category/create_category.dart';
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/models/category.dart';
import '../components/task_card.dart';
import '../components/side_nav_bar.dart';
import '../models/task_notification.dart';
import '../screens/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  final CategoryRepository categoryRepository;
  final CategoryService categoryService;

  // Constructor now takes CategoryRepository and CategoryService as parameters
  HomeScreen({
    required this.categoryRepository,
    required this.categoryService,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CategoryRepository categoryRepository;
  late CategoryService categoryService;

  // Initialize the repositories and services
  @override
  void initState() {
    super.initState();
    categoryRepository = widget.categoryRepository;
    categoryService = widget.categoryService;
    NotificationHelper.initialize();
    _scheduleNotificationsForTomorrow();
    _currentScreen = HomeContentScreen(tasks: tasks, categories: categories);
  }

  // Sample tasks and categories (can be fetched from the service)
  final List<Category> categories = [
    Category(
      id: "1",
      name: "Work",
      description: "Work-related tasks",
      icon: "work_icon.png",
    ),
    Category(
      id: "2",
      name: "Finance",
      description: "Financial tasks",
      icon: "finance_icon.png",
    ),
  ];

  final List<Task> tasks = [
    Task(
      id: "1",
      title: "Team Meeting",
      description: "Discuss project roadmap and timelines.",
      dueDate: DateTime.now().add(Duration(hours: 2)),
      dueTime: "10:00 AM",
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      categoryId: "1",
      userId: "1",
    ),
    Task(
      id: "2",
      title: "Submit Report",
      description: "Submit the Q3 financial report.",
      dueDate: DateTime.now().add(Duration(days: 1)),
      dueTime: "2:00 PM",
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      categoryId: "2",
      userId: "2",
    ),
  ];

  List<TaskNotification> notifications = [];
  Widget _currentScreen = const SizedBox(); // Placeholder screen.

  void _handleNavigation(String route) {
    setState(() {
      if (route == 'home') {
        _currentScreen =
            HomeContentScreen(tasks: tasks, categories: categories);
      } else if (route == 'recycle_bin') {
        _currentScreen = RecycleBinScreen();
      } else if (route == 'categories') {
        _currentScreen = CategoryListScreen(categoryService: categoryService);
      }
    });
  }

  void _addNewTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  String _getCategoryName(String categoryId) {
    return categories
        .firstWhere(
          (cat) => cat.id == categoryId,
      orElse: () => Category(
        id: "0",
        name: "Unknown",
        description: "Unknown Category",
        icon: "",
      ),
    )
        .name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.category),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateCategoryScreen(categoryService: categoryService,)),
              );
            },
          ),
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications),
                if (notifications.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${notifications.length}',
                        style: TextStyle(
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
                  builder: (context) =>
                      NotificationsScreen(notifications: notifications),
                ),
              );
            },
          ),
        ],
      ),
      drawer: SideNavBar(onItemSelected: _handleNavigation),
      body: _currentScreen,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
          if (newTask != null && newTask is Task) {
            _addNewTask(newTask);
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
    );
  }

  void _scheduleNotificationsForTomorrow() {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    final tasksDueTomorrow = tasks.where((task) {
      return task.dueDate.year == tomorrow.year &&
          task.dueDate.month == tomorrow.month &&
          task.dueDate.day == tomorrow.day &&
          task.status == TaskStatus.pending;
    }).toList();

    for (var task in tasksDueTomorrow) {
      final notification = TaskNotification(
        id: int.parse(task.id),
        notificationDate: task.dueDate.subtract(Duration(hours: 1)),
        message: 'Reminder: ${task.title} is due tomorrow!',
        task: task,
      );
      notification.sendNotification();
      setState(() {
        notifications.add(notification);
      });
    }
  }
}

class HomeContentScreen extends StatelessWidget {
  final List<Task> tasks;
  final List<Category> categories;

  const HomeContentScreen({required this.tasks, required this.categories});

  @override
  Widget build(BuildContext context) {
    String? getCategoryName(String? categoryId) {
      if (categoryId == null) return null;
      return categories
          .firstWhere(
            (cat) => cat.id == categoryId,
        orElse: () => Category(
          id: "0",
          name: "Unknown",
          description: "Unknown Category",
          icon: "",
        ),
      )
          .name;
    }

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Tasks",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: tasks.isNotEmpty
                ? ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(
                  task: task,
                  categoryName: getCategoryName(task.getCategoryId()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TaskDetailsScreen(task: task),
                      ),
                    );
                  },
                );
              },
            )
                : Center(child: Text('No tasks available')),
          ),
        ],
      ),
    );
  }
}
