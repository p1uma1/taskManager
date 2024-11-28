import 'package:flutter/material.dart';
import 'package:taskmanager_new/screens/category/category_list_screen.dart';
import 'package:taskmanager_new/services/NotificationHelper.dart';
import 'recyclebin_screen.dart';
import 'task_details_screen.dart';
import 'upcoming_tasks_screen.dart';
import 'overdue_tasks_screen.dart';
import 'add_task_screen.dart';
import 'category/create_category.dart';
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/models/category.dart';
import 'package:taskmanager_new/models/user.dart';
import 'package:taskmanager_new/components/task_card.dart';
import '../components/side_nav_bar.dart';
import '../models/task_notification.dart';
import '../screens/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [
    Task(
      id: 1,
      title: "Team Meeting",
      description: "Discuss project roadmap and timelines.",
      dueDate: DateTime.now().add(Duration(hours: 2)),
      dueTime: "10:00 AM",
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      category: Category(1, "Work", "Work-related tasks", "work_icon.png"),
      user: User(id: "1", name: "Alice", email: "alice@example.com"),
    ),
    Task(
      id: 2,
      title: "Submit Report",
      description: "Submit the Q3 financial report.",
      dueDate: DateTime.now().add(Duration(days: 1)),
      dueTime: "2:00 PM",
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      category: Category(2, "Finance", "Financial tasks", "finance_icon.png"),
      user: User(id: "2", name: "Bob", email: "bob@example.com"),
    ),
  ];

  List<TaskNotification> notifications = [];
  Widget _currentScreen = const SizedBox(); // Placeholder screen.

  @override
  void initState() {
    super.initState();
    NotificationHelper.initialize();
    _scheduleNotificationsForTomorrow();
    // Set the default screen to show home content.
    _currentScreen = HomeContentScreen(tasks: tasks);
  }

  void _handleNavigation(String route) {
    setState(() {
      if (route == 'home') {
        _currentScreen = HomeContentScreen(tasks: tasks);
      } else if (route == 'recycle_bin') {
        _currentScreen = RecycleBinScreen();
      } else if (route == 'categories') {
        _currentScreen = CategoryListScreen();
      }
    });
  }

  void _addNewTask(Task task) {
    setState(() {
      tasks.add(task);
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
                MaterialPageRoute(builder: (context) => CreateCategoryScreen()),
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
                    builder: (context) => NotificationsScreen(
                      notifications: notifications,
                    ),
                  ),
                );
              }),
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
        task.id,
        task.dueDate.subtract(Duration(hours: 1)), // Notify 1 hour before
        'Reminder: ${task.title} is due tomorrow!',
        task,
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

  const HomeContentScreen({required this.tasks});

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
            child: tasks.isNotEmpty
                ? ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        task: task,
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
                : Center(
                    child: Text(
                      "No tasks for today!",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpcomingTasksScreen(
                    upcomingTasks: tasks
                        .where((task) =>
                            task.dueDate.isAfter(DateTime.now()) &&
                            task.status == TaskStatus.pending)
                        .toList(),
                  ),
                ),
              );
            },
            child: Text(
              "Upcoming Tasks",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OverdueTasksScreen(
                    overdueTasks: tasks
                        .where((task) =>
                            task.dueDate.isBefore(DateTime.now()) &&
                            task.status == TaskStatus.pending)
                        .toList(),
                  ),
                ),
              );
            },
            child: Text(
              "Overdue Tasks",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
