class User {
  final String id;
  final String username;
  final String email;
  final List<String> roles;
  final bool isActive;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
    this.isActive = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'roles': roles,
      'isActive': isActive,
    };
  }

  bool get isAdmin => roles.contains('admin');
}
