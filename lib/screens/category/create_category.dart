import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskmanager_new/screens/category/category_list_screen.dart';
import 'package:taskmanager_new/services/category_service.dart';
import '../../models/category.dart'; // Import your Category class

class CreateCategoryScreen extends StatefulWidget {
  final CategoryService categoryService;

  CreateCategoryScreen(
      {required this.categoryService}); // Passing service as a parameter

  @override
  _CreateCategoryScreenState createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedIcon = 'home'; // Default icon

  // List of icons to display for selection
  final List<Map<String, dynamic>> _iconList = [
    {'icon': Icons.home, 'name': 'home'},
    {'icon': Icons.work, 'name': 'work'},
    {'icon': Icons.shopping_cart, 'name': 'shopping_cart'},
    {'icon': Icons.pets, 'name': 'pets'},
    {'icon': Icons.business, 'name': 'business'},
    // Add more icons as needed
  ];

  // Function to save category using the Category model's addCategory method
  void _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      // Get the current user's ID from Firebase Authentication
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in!')),
        );
        return;
      }

      final userId = currentUser.uid;

      // Create a new Category object
      final newCategory = Category(
        id: '', // Firestore will auto-generate the ID
        name: _nameController.text,
        description: _descriptionController.text,
        icon: _selectedIcon,
        userId: userId, // Assign the Firebase Auth UID
      );

      try {
        // Call the CategoryService to add the category
        await widget.categoryService.createCategorywithAttributes(
          name: newCategory.name,
          description: newCategory.description,
          icon: newCategory.icon,
          userId: newCategory.userId!,
        );

        // Clear the form
        _nameController.clear();
        _descriptionController.clear();

        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category created successfully!')),
        );

        // Navigate to the CategoryList screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CategoryListScreen(categoryService: widget.categoryService),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create category: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Category',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.label, color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.description, color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Select Icon:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _iconList.length,
                itemBuilder: (context, index) {
                  final iconData = _iconList[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIcon = iconData['name'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedIcon == iconData['name']
                            ? Colors.blueAccent.withOpacity(0.2)
                            : Colors.transparent,
                        border: Border.all(
                          color: _selectedIcon == iconData['name']
                              ? Colors.blueAccent
                              : Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        iconData['icon'],
                        size: 30,
                        color: _selectedIcon == iconData['name']
                            ? Colors.blueAccent
                            : Colors.black,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveCategory,
                  child: Text(
                    'Save Category',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}