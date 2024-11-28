import 'package:flutter/material.dart';
import 'package:taskmanager_new/models/category.dart';
import '../../models/category.dart'; // Import Category class

class UpdateCategoryScreen extends StatefulWidget {
  final Category category;

  UpdateCategoryScreen({required this.category});

  @override
  _UpdateCategoryScreenState createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.category.name;
    _descriptionController.text = widget.category.description;
  }

  void _updateCategory() {
    final updatedCategory = Category(
      widget.category.id,
      _nameController.text,
      _descriptionController.text,
      widget.category.icon,
    );

    Category.updateCategory(updatedCategory);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category updated successfully!')));
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
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateCategory,
              child: Text('Update Category'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
