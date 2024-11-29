import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanager_new/models/task.dart';


class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore collection name
  final String _collectionName = 'tasks';

  // Add a new task
  Future<void> addTask(Task task) async {
    try {
      await _firestore.collection(_collectionName).doc(task.id).set(task.toJson());
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  // Fetch tasks for a specific user
  Future<List<Task>> fetchTasks(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID
        return Task.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    try {
      await _firestore.collection(_collectionName).doc(task.id).update(task.toJson());
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  // Delete a task by ID
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection(_collectionName).doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
}
