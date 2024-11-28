import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import '../models/category.dart';
import '../models/user.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  bool _hasError = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  // Fetch tasks from Firebase (this will automatically use cached data when offline)
  Future<void> fetchTasks() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      // Fetch tasks from Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot taskSnapshot = await firestore.collection('tasks').get();
      List<Task> loadedTasks = [];

      for (var doc in taskSnapshot.docs) {
        var taskJson = doc.data() as Map<String, dynamic>;
        Category category = Category.fromJson(taskJson['category']);
        User user = User.fromJson(taskJson['user']);

        loadedTasks.add(Task.fromJson(taskJson, category, user));
      }

      _tasks = loadedTasks;
    } catch (e) {
      _hasError = true;
      print('Error fetching tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new task to Firebase (this will automatically sync offline changes)
  Future<void> addTask(Task task) async {
    try {
      // Add task to Firebase Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('tasks').add(task.toJson());

      // Add task to local state (it will be cached automatically)
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  // Remove task from Firebase
  Future<void> removeTask(int taskId) async {
    try {
      // Remove task from Firebase Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var snapshot = await firestore.collection('tasks').where('id', isEqualTo: taskId).get();
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
      }

      // Remove task from local state (it will be cached automatically)
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      print('Error removing task: $e');
    }
  }

  // Update task in Firebase
  Future<void> updateTask(Task task) async {
    try {
      // Update task in Firebase Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var snapshot = await firestore.collection('tasks').where('id', isEqualTo: task.id).get();
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update(task.toJson());
      }

      // Update task in local state (it will be cached automatically)
      int index = _tasks.indexWhere((existingTask) => existingTask.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating task: $e');
    }
  }
}
