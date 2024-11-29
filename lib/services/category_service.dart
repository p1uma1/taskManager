import '../../models/category.dart';
import '../repositories/category_repository.dart';

class CategoryService {
  final CategoryRepository _repository;

  CategoryService(this._repository);

  // Fetch all categories with optional business logic
  Future<List<Category>> getAllCategories() async {
    return await _repository.fetchAllCategories();
  }

  // Fetch a category by ID
  Future<Category?> getCategoryById(String id) async {
    return await _repository.fetchCategoryById(id);
  }

  // Add a category
  Future<void> createCategory(Category category) async {
    // Additional logic can go here, e.g., validation
    await _repository.addCategory(category);
  }

  // Update a category
  Future<void> updateCategory(Category category) async {
    // Add logic if needed (e.g., check if the category exists)
    await _repository.updateCategory(category);
  }

  // Delete a category
  Future<void> deleteCategory(String id) async {
    // Add logic if needed (e.g., check if the category is associated with tasks)
    await _repository.deleteCategory(id);
  }
}
