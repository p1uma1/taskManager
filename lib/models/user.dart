class User {
  final String id; // Firebase UID
  String name;
  String email;
  String statusByDay;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.statusByDay="busy",
  });

  // Convert User to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'statusByDay': statusByDay,
    };
  }

  // Create a User instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      statusByDay: (json['statusByDay']),
    );
  }

  // Update a specific day's status
  void updateStatus(String day, String status) {
    statusByDay = status;
  }
}
