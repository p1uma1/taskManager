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
  Stream<String?> _getCategoryName(String? categoryId) async* {
    if (categoryId == null) yield null;

    try {
      final categories = await widget.categoryService.getAllCategories();

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

      yield category.name;
    } catch (e) {
      print('Error fetching category name: $e');
      yield "Unknown";
    }
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

    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Tasks",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            StreamBuilder<List<Task>>(
              stream: widget.taskService.getTaskStreamForUser(userId),
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

                // We only need to stream categories once here
                return FutureBuilder<List<Category>>(
                  future: widget.categoryService.getAllCategories(),
                  builder: (context, categorySnapshot) {
                    if (categorySnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (categorySnapshot.hasError) {
                      return Center(child: Text('Error: ${categorySnapshot.error}'));
                    }

                    final categories = categorySnapshot.data ?? [];

                    return ListView.builder(
                      shrinkWrap: true,
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
            ),
          ],
        ),
      ),
    );
  }


}
