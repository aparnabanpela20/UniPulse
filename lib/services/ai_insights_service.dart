import "dart:convert";
import 'package:http/http.dart' as http;

class AiInsightsService {
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

Given the following complaints (in JSON), perform these tasks:

1. Select ONLY the TOP 3 priority complaints.
   - Prioritize issues that are urgent, critical, or high-impact
     (e.g. safety risks, health/hygiene issues, infrastructure failures,
      academic disruptions, or issues affecting many students).
   - Consider consequences if the issue is not addressed quickly.
   - Use upvotes only as a secondary signal.
   - Ignore trivial, low-impact, or preference-based complaints,
     even if they have many upvotes.
   - Prefer systemic or recurring problems.

2. Group similar complaints by root cause.
3. For each group, generate ONE combined practical solution.
4. Generate an improved individual solution for each complaint,
   considering the user's preferred solution if provided.

Return STRICTLY VALID JSON in this exact format:

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
