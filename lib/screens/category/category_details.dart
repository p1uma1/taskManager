import 'package:flutter/material.dart';
import 'package:taskmanager_new/screens/category/category_update.dart';
import '../../models/category.dart'; // Import Category class

class CategoryDetailScreen extends StatelessWidget {
  final Category category;

  CategoryDetailScreen({required this.category});

  void _deleteCategory(BuildContext context) {
    Category.deleteCategory(category.id);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category deleted successfully!')));
  }

  void _updateCategory(BuildContext context) {
    // For now, navigate to a simple update screen. You can add more fields to edit.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateCategoryScreen(category: category),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${category.id}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Name: ${category.name}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Description: ${category.description}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Icon: ${category.icon}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _updateCategory(context),
              child: Text('Update Category'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _deleteCategory(context),
              child: Text('Delete Category'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}
