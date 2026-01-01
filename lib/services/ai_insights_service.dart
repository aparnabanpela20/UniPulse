import "dart:convert";
import 'package:http/http.dart' as http;

class AiInsightsService {
  static const String _apikey = String.fromEnvironment('GEMINI_API_KEY');

  static const String _endpoint =
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent';

  Future<Map<String, dynamic>> generateInsights(
    List<Map<String, dynamic>> complaints,
  ) async {
    print("🟢 generateInsights ENTERED");

    // if (_apikey.isEmpty) {
    //   throw Exception('GEMINI_API_KEY is not provided');
    // }

    final prompt =
        """
You are an AI system.

TASK:
From the complaints JSON below:

1. Select EXACTLY 3 complaint IDs with highest priority
2. Group related complaints by root cause

RULES:
- Prioritize safety, hygiene, infrastructure, academics
- Ignore trivial issues
- Respond with VALID JSON ONLY
- No markdown
- No explanation text

JSON FORMAT:
{
  "topPriorityComplaintIds": ["id1","id2","id3"],
  "groups": [
    {
      "groupTitle": "Short title",
      "complaintIds": ["id1","id2"]
    }
  ]
}

COMPLAINTS:
${jsonEncode(complaints)}
""";

    final response = await http.post(
      Uri.parse('$_endpoint?key=$_apikey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
        "generationConfig": {"temperature": 0.1, "maxOutputTokens": 4096},
      }),
    );

    if (response.statusCode != 200) {
      print("❌ Gemini error ${response.statusCode}: ${response.body}");
      throw Exception("AI Insights failed: ${response.body}");
    }

    final data = jsonDecode(response.body);

    // Gemini returns the JSON as text → decode again
    final text = data['candidates'][0]['content']['parts'][0]['text'];
    print("🧾 RAW GEMINI TEXT:\n$text");

    if (!text.trim().endsWith('}')) {
      throw Exception("Gemini returned truncated JSON");
    }

    final cleaned = text.replaceAll('```json', '').replaceAll('```', '').trim();

    return jsonDecode(cleaned);
  }
}
