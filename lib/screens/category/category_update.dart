import 'package:flutter/material.dart';
import 'package:taskmanager_new/services/category_service.dart';
import '../../models/category.dart';

class CategoryUpdate extends StatefulWidget {
  final Category category;
  final CategoryService categoryService;

  CategoryUpdate({required this.category, required this.categoryService});

  @override
  _CategoryUpdateState createState() => _CategoryUpdateState();
}

class _CategoryUpdateState extends State<CategoryUpdate> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.category.name;
    _descriptionController.text = widget.category.description;
  }

  void _updateCategory() async {
    final updatedCategory = Category(
      id: widget.category.id,
      name: _nameController.text,
      description: _descriptionController.text,
      icon: widget.category.icon,
    );


    // Use CategoryService to update the category
    await widget.categoryService.updateCategory(updatedCategory);

    // Notify the user
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Category updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Category'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateCategory,
              child: Text('Update Category', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent.shade100,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

