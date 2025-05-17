import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiService {
  static const String apiKey = 'AIzaSyA_RzLBtPclqMMxVoOZjbBhiYt_ba_Ogqc';

  static Future<String> sendMessage(String userMessage) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": userMessage}
          ]
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final text = data['candidates'][0]['content']['parts'][0]['text'];
        return text ?? "Pas de réponse 🤖";
      } else {
        print('Erreur API: ${response.body}');
        return "Erreur API: ${response.reasonPhrase}";
      }
    } catch (e) {
      print('Exception: $e');
      return "Erreur de connexion.";
    }
  }
}
