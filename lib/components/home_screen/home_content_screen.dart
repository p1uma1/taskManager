import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager_new/components/task_card.dart';
import 'package:taskmanager_new/models/category.dart';
import 'package:taskmanager_new/models/task.dart';
import 'package:taskmanager_new/screens/task/task_details_screen.dart';
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
  late Future<List<Task>> _tasksFuture;
  late Future<List<Category>> _categoriesFuture;
  Future<String?> _getCategoryName(String? categoryId, String userId) async {
    if (categoryId == null) return null;

    try {
      final categories = await widget.categoryService.fetchCategoriesByUserId(userId);

      final category = categories.firstWhere(
            (cat) => cat.id == categoryId,
        orElse: () => Category(
          id: "0",
          userId: "0",
          name: "Unknown",
          description: "Unknown Category",
          icon: "",
        ),
      );

      return category.name;
    } catch (e) {
      print('Error fetching category name: $e');
      return "Unknown";
    }
  }

  @override
  void initState() {
    super.initState();
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    // If user is not logged in, navigate to login screen or show error message
    if (userId == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // Assign the future to _tasksFuture, using Future.value([]) if null
      _tasksFuture = widget.taskService.getTasksForUser(userId) ?? Future.value([]);

      // Fetch categories, ensuring it never returns null
      _categoriesFuture = widget.categoryService.fetchCategoriesByUserId(userId) ?? Future.value([]);
    }
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
            child: FutureBuilder<List<Task>>(
              future: _tasksFuture,
              builder: (context, taskSnapshot) {
                if (taskSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (taskSnapshot.hasError) {
                  return Center(child: Text('Error: ${taskSnapshot.error}'));
                }

                final tasks = taskSnapshot.data ?? [];

                if (tasks.isEmpty) {
                  return Center(child: Text('No tasks available'));
                }

                return FutureBuilder<List<Category>>(
                  future: _categoriesFuture,
                  builder: (context, categorySnapshot) {
                    if (categorySnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (categorySnapshot.hasError) {
                      return Center(child: Text('Error: ${categorySnapshot.error}'));
                    }

                    final categories = categorySnapshot.data ?? [];

                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];

                        return FutureBuilder<String?>(
                          future: _getCategoryName(task.categoryId, FirebaseAuth.instance.currentUser?.uid ?? "userId_placeholder"),
                          builder: (context, categoryNameSnapshot) {
                            if (categoryNameSnapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (categoryNameSnapshot.hasError) {
                              return Center(child: Text('Error: ${categoryNameSnapshot.error}'));
                            }

                            final categoryName = categoryNameSnapshot.data ?? "Unknown";

                            return TaskCard(
                              task: task,
                              categoryName: categoryName,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskDetailsScreen(
                                      task: task,
                                      taskService: widget.taskService,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}




