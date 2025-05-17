// lib/models/user.dart
class User {
  final String token;
  final List<String> roles; // List of roles

  User({required this.token, required this.roles});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['accessToken'], // Access token
      roles: json['roles'] != null && json['roles'] is List
          ? List<String>.from(json['roles'])
          : [], // Liste vide si 'roles' est null ou n'est pas une liste
    );
  }
}
