import 'package:flutter/material.dart';
import '../../models/category.dart'; // Import your Category class

class CreateCategoryScreen extends StatefulWidget {
  @override
  _CreateCategoryScreenState createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
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
  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      // Create a new Category object
      final newCategory = Category(
        int.parse(_idController.text),
        _nameController.text,
        _descriptionController.text,
        _selectedIcon,
      );

      // Add category using the addCategory method from Category model
      Category.addCategory(newCategory);

      // Clear the form
      _idController.clear();
      _nameController.clear();
      _descriptionController.clear();

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
                  TextFormField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: 'ID',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.confirmation_number),
                    ),
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
                  SizedBox(height: 16),
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
                      child: Text('Save Category'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Display categories from the Category model
            Expanded(
              child: ListView.builder(
                itemCount: Category.getCategories().length,
                itemBuilder: (context, index) {
                  final category = Category.getCategories()[index];
                  return ListTile(
                    title: Text(category.name),
                    subtitle: Text(category.description),
                    leading: Icon(Icons.home), // Replace with actual icon logic
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
