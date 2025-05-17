import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:senior_care/models/User.dart';

class AuthService {
  // Web Adrres  : static const String _baseUrl = 'http://localhost:8081/api/auth';
  static const String _baseUrl = 'http://10.0.2.2:8081/api/auth';

  Future<User> login({required String email, required String password}) async {
    final uri = Uri.parse('$_baseUrl/signin');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': email,
          'password': password,
        }),
      );

      // Vérifier la réponse du serveur
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          return User.fromJson(data);
        } catch (e) {
          throw Exception('Erreur de déserialization JSON : $e');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Mauvais identifiants');
      } else if (response.statusCode == 404) {
        throw Exception('Utilisateur non trouvé');
      } else if (response.statusCode == 500) {
        throw Exception('Erreur du serveur, veuillez réessayer plus tard');
      } else {
        throw Exception('Échec de connexion (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erreur réseau ou autre : $e');
    }
  }
}
