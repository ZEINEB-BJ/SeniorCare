import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthServiceEmail {
  static Future<bool> sendPasswordResetLink(String email) async {
    // final url = Uri.parse('http://localhost:8081/api/auth/send?to=$email');
    final url = Uri.parse('http://10.0.2.2:8081/api/auth/send?to=$email');

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        // API call successful
        return true;
      } else {
        // API call failed
        return false;
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }
}
