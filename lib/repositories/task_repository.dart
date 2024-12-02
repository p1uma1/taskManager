import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanager_new/models/recyclebin.dart';
import 'package:taskmanager_new/models/task.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore collection name
  final String _collectionName = 'tasks';
  final String _recycleBinCollection = 'recycle_bin';

  // Add a new task
  Future<void> addTask(Task task) async {
    try {
      /*
      await _firestore
          .collection(_collectionName)
          .doc(task.id)
          .set(task.toJson());
          */

      final docRef = _firestore.collection(_collectionName).doc();

      final updatedTask = task.copyWith(id: docRef.id);

      await docRef.set(updatedTask.toJson());
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

  //fetch recycle tasks
  Future<List<RecycleBin>> fetchRecycleBinTasks(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_recycleBinCollection)
          .where('task.userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return RecycleBin.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch recycle bin tasks: $e');
    }
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(task.id)
          .update(task.toJson());
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

  // Move a task to the recycle bin
  Future<void> moveToRecycleBin(Task task) async {
    try {
      final taskId = task.id.isNotEmpty
          ? task.id
          : _firestore.collection(_collectionName).doc().id;
      final recycleBinEntry = RecycleBin(
        id: taskId,
        deleteDate: DateTime.now(),
        task: task.copyWith(id: taskId),
      );
      await _firestore
          .collection(_recycleBinCollection)
          .doc(taskId)
          .set(recycleBinEntry.toJson());
      await _firestore
          .collection(_collectionName)
          .doc(task.id)
          .delete(); // Remove task from the `tasks` collection
    } catch (e) {
      throw Exception('Failed to move task to recycle bin: $e');
    }
  }

  //restore a task from the recycle bin
  Future<void> restoreTask(String taskId) async {
    try {
      final doc =
          await _firestore.collection(_recycleBinCollection).doc(taskId).get();
      if (doc.exists) {
        final recycleBinEntry = RecycleBin.fromJson(doc.data()!);
        await addTask(
            recycleBinEntry.task); // Restore task to `tasks` collection
        await _firestore.collection(_recycleBinCollection).doc(taskId).delete();
      } else {
        throw Exception('Task not found in recycle bin');
      }
    } catch (e) {
      throw Exception('Failed to restore task: $e');
    }
  }

  //permenent delete
  Future<void> permanentlyDeleteTask(String taskId) async {
    try {
      await _firestore.collection(_recycleBinCollection).doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to permanently delete task: $e');
    }
  }

  // Fetch upcoming tasks for a specific user
  Future<List<Task>?> getUpcomingTasks(String userId) async {
    try {
      final now = DateTime.now();

      // Query tasks where `dueDate` is in the future and `status` is pending
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .where('dueDate', isGreaterThan: now.toIso8601String())
          .where('status', isEqualTo: TaskStatus.pending.toString())
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID
        return Task.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch upcoming tasks: $e');
    }
  }
}
