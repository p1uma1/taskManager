import '../../models/category.dart';
import '../repositories/category_repository.dart';

class CategoryService {
  final CategoryRepository _repository;

  CategoryService(this._repository);

  // Fetch all categories
  Future<List<Category>> getAllCategories() async {
    return await _repository.fetchAllCategories();
  }

  // Fetch a category by ID
  Future<Category?> getCategoryById(String id) async {
    return await _repository.fetchCategoryById(id);
  }

  // Fetch all categories by userId
  Future<List<Category>> getCategoriesByUserId(String userId) async {
    return await _repository.fetchCategoriesByUserId(userId);
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

  // Delete all categories by userId
  Future<void> deleteCategoriesByUserId(String userId) async {
    await _repository.deleteCategoriesByUserId(userId);
  }
}
