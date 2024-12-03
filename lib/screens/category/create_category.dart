import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskmanager_new/services/category_service.dart';
import '../../models/category.dart'; // Import your Category class

class CreateCategoryScreen extends StatefulWidget {
  final CategoryService categoryService;

  CreateCategoryScreen({required this.categoryService}); // Passing service as a parameter

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
        if (newCategory.userId == null) {
          // Handle the case where userId is null (show an error or take another action)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User is not logged in!')),
          );
          return; // Prevent category creation if userId is null
        } else {
          await widget.categoryService.createCategorywithAttributes(
            name: newCategory.name,
            description: newCategory.description,
            icon: newCategory.icon,
            userId: newCategory.userId!, // Safe to use now
          );
        }

        // Clear the form
        _nameController.clear();
        _descriptionController.clear();

        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category created successfully!')),
        );

        // Pop the current screen and go back to the previous screen
        Navigator.pop(context, true); // Pass true or any value if you want to indicate success

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
        title: Text('Create Category'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  // Removed the ID field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label),
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
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Icon selection grid
                  Text('Select Icon:', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
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
                            border: Border.all(
                              color: _selectedIcon == iconData['name']
                                  ? Colors.blue
                                  : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            iconData['icon'],
                            size: 30,
                            color: _selectedIcon == iconData['name']
                                ? Colors.blue
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
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
