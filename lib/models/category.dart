class Category {
  final String id; // Use String for Firebase Document IDs
  final String name;
  final String description;
  final String icon;
  final String? userId; // New field to associate the category with a user

  // Constructor
  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.userId, // Include userId in the constructor
  });

  // Convert Category to JSON for storage in Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      if (userId != null) 'userId': userId,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json, String id) {
    return Category(
      id: id, // Use the document ID
      name: json['name'] ?? 'Unnamed Category', // Handle null or missing fields
      description: json['description'] ?? '',
      icon: json['icon'] ?? 'default_icon',
      userId: json['userId'],
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description, icon: $icon, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.icon == icon &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        icon.hashCode ^
        userId.hashCode;
  }
}
