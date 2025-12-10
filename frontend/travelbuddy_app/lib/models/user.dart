/// User model class
class User {
  final int? id;
  final String username;
  final String email;
  final String? password;
  final String? fullName;
  final String? createdAt;

  User({
    this.id,
    required this.username,
    required this.email,
    this.password,
    this.fullName,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      fullName: json['fullName'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'email': email,
      if (password != null) 'password': password,
      if (fullName != null) 'fullName': fullName,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}
