import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager_new/repositories/category_repository.dart';
import 'package:taskmanager_new/repositories/task_repository.dart';
import 'package:taskmanager_new/screens/category/category_list_screen.dart';
import 'package:taskmanager_new/screens/task/add_task_screen.dart';
import 'package:taskmanager_new/screens/task/task_details_screen.dart';
import 'package:taskmanager_new/services/NotificationHelper.dart';
import 'package:taskmanager_new/services/category_service.dart';
import 'package:taskmanager_new/services/task_service.dart';
import 'recyclebin_screen.dart';
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
  late List<Category> categories = [];
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
      final fetchedCategories =
      await widget.categoryService.getAllCategories();
      final fetchedTasks = await widget.taskService.getTasksForUser(userId!);
      setState(() {
        categories = fetchedCategories;
        tasks = fetchedTasks;
        _currentScreen = HomeContentScreen(tasks: tasks, categories: categories);
      });
    }
  }

  void _scheduleNotificationsForTomorrow() {
    final tomorrow = DateTime.now().add(Duration(days: 1));

    final tasksDueTomorrow = (tasks != null)
        ? tasks!.where((task) {
      return task.dueDate.year == tomorrow.year &&
          task.dueDate.month == tomorrow.month &&
          task.dueDate.day == tomorrow.day &&
          task.status == TaskStatus.pending;
    }).toList()
        : [];


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

  void _handleNavigation(String route) {
    setState(() {
      if (route == 'home') {
        _currentScreen =
            HomeContentScreen(tasks: tasks, categories: categories);
      } else if (route == 'recycle_bin') {
        _currentScreen = RecycleBinScreen();
      } else if (route == 'categories') {
        _currentScreen =
            CategoryListScreen(categoryService: widget.categoryService);
      }
    });
  }

  void _addNewTask(Task task) {
    setState(() {
      if (tasks != null) {
        tasks!.add(task); // Null check before calling add
      } else {
        tasks = [task]; // If tasks is null, initialize it with the new task
      }
    });
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
}

class HomeContentScreen extends StatelessWidget {
  final List<Task>? tasks;
  final List<Category> categories;

  const HomeContentScreen({required this.tasks, required this.categories});

  String? _getCategoryName(String? categoryId) {
    if (categoryId == null) return null;
    return categories.firstWhere(
          (cat) => cat.id == categoryId,
      orElse: () => Category(
        id: "0",
        name: "Unknown",
        description: "Unknown Category",
        icon: "",
      ),
    ).name;
  }

  @override
  Widget build(BuildContext context) {
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
            child: tasks == null
                ? Center(
              child: CircularProgressIndicator(), // Show a loading indicator
            )
                : tasks!.isNotEmpty
                ? ListView.builder(
              itemCount: tasks!.length,
              itemBuilder: (context, index) {
                final task = tasks![index];
                return TaskCard(
                  task: task,
                  categoryName: _getCategoryName(task.categoryId),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsScreen(
                          task: task,
                          taskService: TaskService(),
                        ),
                      ),
                    );
                  },
                );
              },
            )
                : Center(
              child: Text('No tasks available'),
            ),
          ),
        ],
      ),
    );
  }
}
