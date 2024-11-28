import 'package:flutter/material.dart';
import 'recyclebin_screen.dart';
import 'task_details_screen.dart';
import 'upcoming_tasks_screen.dart';
import 'overdue_tasks_screen.dart';
import 'add_task_screen.dart';
import 'create_category.dart';
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/models/category.dart';
import 'package:taskmanager_new/models/user.dart';
import 'package:taskmanager_new/components/task_card.dart';
import '../components/side_nav_bar.dart';

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

  Widget _currentScreen = const SizedBox(); // Placeholder screen.

  @override
  void initState() {
    super.initState();
    // Set the default screen to show home content.
    _currentScreen = HomeContentScreen(tasks: tasks);
  }

  void _handleNavigation(String route) {
    setState(() {
      if (route == 'home') {
        _currentScreen = HomeContentScreen(tasks: tasks);
      } else if (route == 'recycle_bin') {
        _currentScreen = RecycleBinScreen();
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
