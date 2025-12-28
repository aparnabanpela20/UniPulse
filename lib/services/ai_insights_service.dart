import "dart:convert";
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apikey = String.fromEnvironment('GEMINI_API_KEY');

  static const String _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  Future<Map<String, dynamic>> generateInsights(
    List<Map<String, dynamic>> complaints,
  ) async {
    if (_apikey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not provided');
    }

    final prompt =
        """
You are an AI assistant helping a college administration.

Given the following list of complaints (in JSON):

TASKS:
1. Identify the TOP 3 priority complaints based on urgency, impact, and upvotes.
2. Group similar complaints together by root cause.
3. For EACH group, generate ONE practical combined solution.
4. Also generate an improved individual solution for each complaint,
   considering the user's preferred solution if provided.

RETURN STRICTLY VALID JSON in this exact structure:

{
  "topPriorityComplaintIds": ["id1", "id2", "id3"],
  "groups": [
    {
      "groupTitle": "Short descriptive title",
      "complaintIds": ["id1", "id4"],
      "groupSolution": "Combined solution text"
    }
  ],
  "individualSolutions": {
    "id1": "Improved solution text",
    "id2": "Improved solution text"
  }
}

Complaints data:
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
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("AI Insights failed: ${response.body}");
    }

    final data = jsonDecode(response.body);

    // Gemini returns the JSON as text → decode again
    final text = data['candidates'][0]['content']['parts'][0]['text'];

    return jsonDecode(text);
  }
}
