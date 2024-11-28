class Category {
  int _id;
  String _name;
  String _description;
  String _icon;

  // Static list to hold categories
  static List<Category> _categories = [
    Category(1, 'Work', 'Tasks related to work', 'work_icon'),
    Category(2, 'Personal', 'Personal to-do items', 'personal_icon'),
    Category(3, 'Shopping', 'Shopping list and reminders', 'shopping_icon'),
    Category(4, 'Fitness', 'Fitness goals and workouts', 'fitness_icon'),
    Category(5, 'Travel', 'Travel plans and itineraries', 'travel_icon'),
  ];

  // Constructor
  Category(this._id, this._name, this._description, this._icon);

  // Getters
  int get id => _id;
  String get name => _name;
  String get description => _description;
  String get icon => _icon;

  // Setters
  set id(int id) => _id = id;
  set name(String name) => _name = name;
  set description(String description) => _description = description;
  set icon(String icon) => _icon = icon;

  // Convert Category to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'description': _description,
      'icon': _icon,
    };
  }

  // Convert JSON to Category
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      json['id'],
      json['name'],
      json['description'],
      json['icon'],
    );
  }

  // Add a new category to the static list
  static void addCategory(Category category) {
    _categories.add(category);
  }

  // Get the list of all categories
  static List<Category> getCategories() {
    return _categories;
  }

  // Update a category in the list
  static void updateCategory(Category updatedCategory) {
    for (var i = 0; i < _categories.length; i++) {
      if (_categories[i].id == updatedCategory.id) {
        _categories[i] = updatedCategory;
        break;
      }
    }
  }

  // Delete a category from the list
  static void deleteCategory(int id) {
    _categories.removeWhere((category) => category.id == id);
  }
}
