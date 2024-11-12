class Category {
  int _id;
  String _name;
  String _description;
  String _icon;

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

  // Category CRUD Operations (currently empty)
  void addCategory() {
    // Add logic for adding category
  }

  void getCategories() {
    // Add logic for getting categories
  }

  void updateCategory() {
    // Add logic for updating category
  }

  void deleteCategory() {
    // Add logic for deleting category
  }
}
