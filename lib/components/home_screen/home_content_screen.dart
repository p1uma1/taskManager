import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager_new/components/task_card.dart';
import 'package:taskmanager_new/models/category.dart';
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/screens/category/create_category.dart';
import 'package:taskmanager_new/screens/task/add_task_screen.dart';
import 'package:taskmanager_new/screens/task/task_details_screen.dart';
import 'package:taskmanager_new/services/NotificationHelper.dart';
import 'package:taskmanager_new/services/category_service.dart';
import 'package:taskmanager_new/services/task_service.dart';

class HomeContentScreen extends StatefulWidget {
  final TaskService taskService;
  final CategoryService categoryService;

  const HomeContentScreen({
    required this.categoryService,
    required this.taskService,
  });

  @override
  _HomeContentScreenState createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  // Helper function to check if a task is overdue
  bool _isOverdue(DateTime? dueDate) {
    if (dueDate == null) return false;
    return dueDate.isBefore(DateTime.now());
  }

  // Helper function to check if a task is today's task
  bool _isToday(DateTime? dueDate) {
    if (dueDate == null) return false;
    final today = DateTime.now();
    return dueDate.year == today.year &&
        dueDate.month == today.month &&
        dueDate.day == today.day;
  }

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          // Add Category Icon Button
          IconButton(
            icon: Icon(Icons.add_box), // You can change the icon as per your preference
            onPressed: () {
              // Navigate to CreateCategoryScreen
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
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              StreamBuilder<List<Task>>(
                stream: widget.taskService.getTaskStreamForUser(userId),
                builder: (context, taskSnapshot) {
                  if (taskSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (taskSnapshot.hasError) {
                    // Show snackbar if there is an error
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error fetching tasks: ${taskSnapshot.error}')),
                      );
                    });
                    return Center(child: Text('Error: ${taskSnapshot.error}'));
                  }

                  final tasks = taskSnapshot.data ?? [];

                  if (tasks.isEmpty) {
                    return Center(child: Text('No tasks available'));
                  }

                  return FutureBuilder<List<Category>>(
                    future: widget.categoryService.getAllCategories(),
                    builder: (context, categorySnapshot) {
                      if (categorySnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (categorySnapshot.hasError) {
                        // Show snackbar if there is an error
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error fetching categories: ${categorySnapshot.error}')),
                          );
                        });
                        return Center(child: Text('Error: ${categorySnapshot.error}'));
                      }

                      final categories = categorySnapshot.data ?? [];

                      // Categorize tasks
                      List<Task> todayTasks = [];
                      List<Task> upcomingTasks = [];
                      List<Task> overdueTasks = [];

                      for (var task in tasks) {
                        final category = categories.firstWhere(
                              (cat) => cat.id == task.categoryId,
                          orElse: () => Category(
                            id: "0",
                            userId: "0",
                            name: "Unknown",
                            description: "Unknown Category",
                            icon: "",
                          ),
                        );

                        if (_isToday(task.dueDate)) {
                          todayTasks.add(task);
                          // Trigger notification for today's task
                          NotificationHelper.showNotification(
                            title: "Task Due Today",
                            body: "${task.title} is due today!",
                          );
                        } else if (_isOverdue(task.dueDate)) {
                          overdueTasks.add(task);
                          // Trigger notification for overdue task
                          NotificationHelper.showNotification(
                            title: "Overdue Task",
                            body: "${task.title} is overdue!",
                          );
                        } else {
                          upcomingTasks.add(task);
                        }
                      }

                      // Build the UI with categorized tasks
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (todayTasks.isNotEmpty)
                            _buildTaskSection("Today's Tasks", todayTasks, categories),
                          if (upcomingTasks.isNotEmpty)
                            _buildTaskSection("Upcoming Tasks", upcomingTasks, categories),
                          if (overdueTasks.isNotEmpty)
                            _buildTaskSection("Overdue Tasks", overdueTasks, categories),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddTaskScreen when pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                taskService: widget.taskService,
                categoryService: widget.categoryService,  // Pass service to the AddTaskScreen
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildTaskSection(
      String sectionTitle, List<Task> tasks, List<Category> categories) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionTitle,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final category = categories.firstWhere(
                    (cat) => cat.id == task.categoryId,
                orElse: () => Category(
                  id: "0",
                  userId: "0",
                  name: "Unknown",
                  description: "Unknown Category",
                  icon: "",
                ),
              );

              return TaskCard(
                task: task,
                categoryName: category.name,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailsScreen(
                        task: task,
                        taskService: widget.taskService, // Pass service here as well
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
