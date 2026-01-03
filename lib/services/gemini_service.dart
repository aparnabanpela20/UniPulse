import "dart:convert";
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apikey = String.fromEnvironment('GEMINI_API_KEY');

  static const String _endpoint =
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent';

  Future<String> generateSolution({
    required String complaint,
    required String category,
    required String prefferedSolution,
  }) async {
    if (_apikey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not provided');
    }

    final prompt =
        """
You are assisting a college administration.

Complaint:
$complaint

Category:
$category

User's Preferred Solution:
$prefferedSolution

Your task:
1. Evaluate the user's preferred solution.
2. Improve or refine it if needed.
3. If it is impractical or incomplete, suggest a better alternative.
4. Keep the response concise (2–3 lines).
5. Do NOT ignore the user's suggestion.

Return ONLY the final suggested solution text.
""";

    final response = await http.post(
      Uri.parse("$_endpoint?key=$_apikey"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Gemini error: ${response.body}");
    }

    final data = jsonDecode(response.body);
    final text = data['candidates'][0]['content']['parts'][0]['text'];

    text.trim().replaceAll(RegExp(r'^"+|"+$'), '');
    return text;
  }
}
