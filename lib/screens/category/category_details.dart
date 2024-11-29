import 'package:flutter/material.dart';
import 'package:taskmanager_new/services/category_service.dart';
import '../../models/category.dart';
import 'category_update.dart';


class CategoryDetails extends StatelessWidget {
  final Category category;

  final CategoryService categoryService; // Pass CategoryService

  // Constructor to pass the Category object and CategoryService
  CategoryDetails({required this.category, required this.categoryService});

  // Function to handle category deletion
  Future<void> _deleteCategory(BuildContext context) async {
    try {
      await categoryService.deleteCategory(category.id); // Delete the category
      Navigator.pop(context); // Pop the current screen after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete category!')),
      );
    }
  }

  // Function to handle category update navigation
  void _updateCategory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryUpdate(category: category, categoryService:categoryService ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display Category ID
                Text(
                  'ID: ${category.id}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),

                // Display Category Name
                Text(
                  'Name: ${category.name}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),

                // Display Category Description
                Text(
                  'Description: ${category.description}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),

                // Row with buttons for Update and Delete
                Row(
                  children: [
                    // Update button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateCategory(context),
                        child: Text('Update', style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    // Delete button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _deleteCategory(context),
                        child: Text('Delete', style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
