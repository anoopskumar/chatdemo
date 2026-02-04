import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  GeminiService(this.apiKey);

  final String apiKey;

  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  Future<String> sendMessage({
    required String message,
    List<Map<String, dynamic>> history = const [],
    String model = 'gemini-2.0-flash',
  }) async {
    final uri = Uri.parse('$_baseUrl/$model:generateContent');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode({
        "contents": [
          ...history,
          {
            "role": "user",
            "parts": [
              {"text": message}
            ]
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gemini error ${response.statusCode}: ${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
        'No response';
  }
}
