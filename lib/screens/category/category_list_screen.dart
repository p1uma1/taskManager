import 'package:flutter/material.dart';
import 'package:taskmanager_new/services/category_service.dart';
import '../../models/category.dart';
import 'category_details.dart';

class CategoryListScreen extends StatefulWidget {
  final CategoryService categoryService;

  CategoryListScreen({required this.categoryService});

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
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
      body: FutureBuilder<List<Category>>(
        future: widget.categoryService.getAllCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.blueAccent.shade200));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading categories'));
          }

          if (snapshot.hasData) {
            final categories = snapshot.data!;

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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      category.description,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent.shade200,
                      child: Icon(Icons.category, color: Colors.white),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            // Show confirmation dialog
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Deletion'),
                                  content: Text(
                                      'Are you sure you want to delete this category?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              if (category.userId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Default categories cannot be deleted!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                await widget.categoryService
                                    .deleteCategory(category.id);
                                setState(() {}); // Rebuild the UI
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Category deleted successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetails(
                            category: category,
                            categoryService: widget.categoryService,
                          ),
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

