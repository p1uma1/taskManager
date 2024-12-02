import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../services/category_service.dart';

class CategoryNotifier extends ChangeNotifier {
  final CategoryService categoryService;
  List<Category> _categories = [];
  bool _isLoading = false;

  CategoryNotifier({required this.categoryService});

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchAllCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await categoryService.getAllCategories();
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(Category category) async {
    await categoryService.createCategory(category);
    _categories.add(category);
    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    await categoryService.deleteCategory(id);
    _categories.removeWhere((category) => category.id == id);
    notifyListeners();
  }
}
