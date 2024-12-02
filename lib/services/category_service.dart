import 'package:firebase_auth/firebase_auth.dart';

import '../../models/category.dart';
import '../repositories/category_repository.dart';

class CategoryService {
  final CategoryRepository _repository;

  CategoryService(this._repository);

  // Fetch all categories (default + user-specific)
  Stream<List<Category>> getAllCategoriesStream() {
    return getAllCategoriesStream();
  }


  Future<List<Category>> getAllCategories() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      //user
      if (user == null) {
        throw Exception("User not logged in");
      }
      final userId = user.uid;

      // default + user defined
      final defaultCategories = await _repository.fetchCategoriesByUserId(null);
      final userCategories = await _repository.fetchCategoriesByUserId(userId);

      //combine
      return [...defaultCategories, ...userCategories];
    } catch (e) {
      throw Exception("Failed to fetch categories: $e");
    }
  }

  // Add a category
  Future<void> createCategory(Category category) async {
    await _repository.addCategory(category);
  }

  // Update a category
  Future<void> updateCategory(Category category) async {
    await _repository.updateCategory(category);
  }

  // Delete a category
  Future<void> deleteCategory(String id) async {
    await _repository.deleteCategory(id);
  }
}
