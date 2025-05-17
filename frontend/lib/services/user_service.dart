import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  // static const String baseUrl = 'http://localhost:8081/api/auth'; // change this
  static const String baseUrl = 'http://10.0.2.2:8081/api/auth'; // change this

  static Future<bool> addUser(
      String username, String email, String password, String role) async {
    final url = Uri.parse('$baseUrl/signup'); // change endpoint if needed

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          "role": [role]
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create user: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }
}
