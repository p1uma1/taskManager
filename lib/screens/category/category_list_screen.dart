import 'package:flutter/material.dart';
import 'package:taskmanager_new/services/category_service.dart';
import '../../models/category.dart';
import 'category_details.dart';

class CategoryListScreen extends StatelessWidget {
  final CategoryService categoryService; // Dependency injection for the service

  // Constructor to pass the CategoryService
  CategoryListScreen({required this.categoryService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Category List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.blueAccent.shade100,
      ),
      body: FutureBuilder(
        future: categoryService.getAllCategories(), // Use service to fetch categories
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                    color: Colors.blueAccent.shade200));
          }

          if (snapshot.hasData) {
            final categories = snapshot.data as List<Category>;

            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      category.name,
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      category.description,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent.shade200,
                      child: Icon(Icons.category, color: Colors.white),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CategoryDetails(category: category, categoryService: categoryService),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'No categories available.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
        },
      ),
    );
  }
}
