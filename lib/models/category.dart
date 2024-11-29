class Category {
  final String id; // Use String for Firebase Document IDs
  final String name;
  final String description;
  final String icon;

  // Constructor
  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });

  // Convert Category to JSON for storage in Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
    };
  }

  // Convert JSON from Firestore to Category
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description, icon: $icon)';
  }
}
