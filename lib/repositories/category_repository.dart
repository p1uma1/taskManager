import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/category.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore collection reference
  CollectionReference get _categoryCollection =>
      _firestore.collection('categories');

  // // Fetch all categories
  // Future<List<Category>> fetchAllCategories() async {
  //   try {
  //     final querySnapshot = await _categoryCollection.get();
  //     return querySnapshot.docs
  //         .map((doc) => Category.fromJson(doc.data() as Map<String, dynamic>))
  //         .toList();
  //   } catch (e) {
  //     throw Exception('Error fetching categories: $e');
  //   }
  // }

  // Fetch all categories by userId
  Future<List<Category>> fetchCategoriesByUserId(String? userId) async {
    try {
      Query query = _categoryCollection;

      if (userId != null) {
        // Fetch user-specific categories
        query = query.where('userId', isEqualTo: userId);
      } else {
        // Fetch default categories
        query = query.where('userId', isNull: true);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        return Category.fromJson(
            doc.data() as Map<String, dynamic>, doc.id); // Pass doc.id
      }).toList();
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Delete all categories by userId
  Future<void> deleteCategoriesByUserId(String userId) async {
    try {
      final querySnapshot =
          await _categoryCollection.where('userId', isEqualTo: userId).get();

      // Use a batch for multiple deletions
      WriteBatch batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Commit the batch
      await batch.commit();
    } catch (e) {
      throw Exception('Error deleting categories for userId $userId: $e');
    }
  }

  // // Fetch a single category by ID
  // Future<Category?> fetchCategoryById(String id) async {
  //   try {
  //     final doc = await _categoryCollection.doc(id).get();
  //     if (doc.exists) {
  //       return Category.fromJson(doc.data() as Map<String, dynamic>);
  //     }
  //     return null;
  //   } catch (e) {
  //     throw Exception('Error fetching category: $e');
  //   }
  // }

  // Add a new category
  Future<void> addCategory(Category category) async {
    try {
      await _categoryCollection.doc(category.id).set(category.toJson());
    } catch (e) {
      throw Exception('Error adding category: $e');
    }
  }

  // Update an existing category
  Future<void> updateCategory(Category category) async {
    try {
      await _categoryCollection.doc(category.id).update(category.toJson());
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }
  //category stream
  Stream<List<Category>> getAllCategoriesStream() {
    return _categoryCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Ensure to pass the `id` if required by `Category.fromJson`
        return Category.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }



  // Delete a category by ID
  Future<void> deleteCategory(String id) async {
    try {
      await _categoryCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }
}
