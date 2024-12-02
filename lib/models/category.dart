class Category {
  final String id; // Use String for Firebase Document IDs
  final String name;
  final String description;
  final String icon;
  final String userId; // New field to associate the category with a user

  // Constructor
  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.userId, // Include userId in the constructor
  });

  // Convert Category to JSON for storage in Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'userId': userId, // Include userId in the JSON representation
    };
  }

  // Convert JSON from Firestore to Category
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      userId: json['userId'], // Map userId from JSON
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description, icon: $icon, userId: $userId)';
  }
}
