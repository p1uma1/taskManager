import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager_new/repositories/task_repository.dart';
import 'package:taskmanager_new/screens/home_screen.dart';
import 'package:taskmanager_new/screens/login_screen.dart';
import 'package:taskmanager_new/screens/singup_screen.dart';
import 'package:taskmanager_new/screens/splash_screen.dart';
import 'package:taskmanager_new/repositories/category_repository.dart';
import 'package:taskmanager_new/services/category_service.dart';
import 'package:taskmanager_new/services/task_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Create instances of CategoryRepository and CategoryService
  CategoryRepository categoryRepository = CategoryRepository();
  CategoryService categoryService = CategoryService(categoryRepository);
  TaskRepository taskRepository = TaskRepository();
  TaskService taskService = TaskService();
  runApp(MaterialApp(
    initialRoute: '/splash',
    routes: {
      '/splash': (context) => SplashScreen(),
      '/login': (context) => LoginScreen(),
      '/home': (context) => HomeScreen(
        categoryRepository: categoryRepository,
        categoryService: categoryService,
        taskRepository: taskRepository,
        taskService: taskService,
      ),
      '/signup': (context) => SignupScreen(),
    },
    debugShowCheckedModeBanner: false,
  ));
}
