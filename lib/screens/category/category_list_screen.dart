import 'package:flutter/material.dart';
import '../../models/category.dart';
import 'category_details.dart'; // Import Category class

class CategoryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder(
        future: Future.delayed(
            Duration(seconds: 1), () => Category.getCategories()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final categories = snapshot.data as List<Category>;

            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.name),
                  subtitle: Text(category.description),
                  leading: Icon(Icons.category),
                  onTap: () {
                    // Navigate to the Category Detail Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryDetailScreen(category: category),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No categories available.'));
          }
        },
      ),
    );
  }
}
