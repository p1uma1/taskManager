import 'package:flutter/material.dart';
import 'package:taskmanager_new/services/category_service.dart';
import '../../models/category.dart';
import 'category_update.dart';

class CategoryDetails extends StatelessWidget {
  final Category category;
  final CategoryService categoryService;

  // Constructor to pass the Category object and CategoryService
  CategoryDetails({required this.category, required this.categoryService});

  // Function to handle category deletion
  Future<void> _deleteCategory(BuildContext context) async {
    try {
      await categoryService.deleteCategory(category.id);
      Navigator.pop(context);
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
        builder: (context) => CategoryUpdate(
          category: category,
          categoryService: categoryService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDefaultCategory = category.userId == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Category Details',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Icon or Visual Placeholder
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blueAccent.shade100,
                      child: Icon(
                        Icons.category,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Category Name
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  // SizedBox(height: 10),

                  SizedBox(height: 20),

                  // Divider
                  Divider(color: Colors.grey.shade300, thickness: 1.5),
                  SizedBox(height: 20),

                  // Details Section
                  Text(
                    'Category Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 10),
                  // Description
                  Text(
                    category.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),

                  SizedBox(height: 10),
                  if (isDefaultCategory)
                    Text(
                      'This is a default category.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.redAccent,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Update Button
                      ElevatedButton.icon(
                        onPressed: isDefaultCategory
                            ? null
                            : () => _updateCategory(context),
                        icon: Icon(Icons.edit, color: Colors.white),
                        label: Text('Update',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDefaultCategory
                              ? Colors.grey
                              : Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),

                      // Delete Button
                      ElevatedButton.icon(
                        onPressed: isDefaultCategory
                            ? null
                            : () => _deleteCategory(context),
                        icon: Icon(Icons.delete, color: Colors.white),
                        label: Text('Delete',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDefaultCategory
                              ? Colors.grey
                              : Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
