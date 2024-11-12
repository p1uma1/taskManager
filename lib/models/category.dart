class Category {
  int _id;
  String _name;
  String _description;
  String _icon;

  Category(this._id, this._name, this._description, this._icon);

  int get id => _id;
  String get name => _name;
  String get description => _description;
  String get icon => _icon;

  set id(int id) => _id = id;
  set name(String name) => _name = name;
  set description(String description) => _description = description;
  set icon(String icon) => _icon = icon;

  void addCategory() {}
  void getCategories() {}
  void updateCategory() {}
  void deleteCategory() {}
}
