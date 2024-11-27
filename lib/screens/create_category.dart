import 'package:flutter/material.dart';

import '../models/category.dart'; // Import your Category class

class CreateCategoryScreen extends StatefulWidget {
  @override
  _CreateCategoryScreenState createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _iconController = TextEditingController();

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      // Create a new Category object
      final newCategory = Category(
        int.parse(_idController.text),
        _nameController.text,
        _descriptionController.text,
        _iconController.text,
      );

      // You can now use this object (e.g., send it to a database or API)
      print("Category Created: ${newCategory.toJson()}");

      // Clear the form
      _idController.clear();
      _nameController.clear();
      _descriptionController.clear();
      _iconController.clear();

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category created successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an ID';
                  }
                  if (int.tryParse(value) == null) {
                    return 'ID must be a number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _iconController,
                decoration: InputDecoration(labelText: 'Icon'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an icon name or path';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveCategory,
                  child: Text('Save Category'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
