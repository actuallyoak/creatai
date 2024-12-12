import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String apiKey = 'YOUR_API_KEY_HERE'; // Replace with your API key
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
  }

  Future<List<String>> generatePrompts(List<String> selectedActivities, List<String> ratedPrompts) async {
    try {
      final promptText = '''
Based on these activities: ${selectedActivities.join(', ')}
And these previously rated prompts: ${ratedPrompts.isEmpty ? 'None yet' : ratedPrompts.join(', ')}

Generate 5 unique, specific, and engaging creative prompts. Each prompt should:
1. Be related to the user's selected activities
2. Be specific and actionable
3. Encourage creativity and exploration
4. Be 10-15 words long
5. Start with an action verb

Format the response as a simple list of 5 prompts, one per line.
''';

      final content = Content.text(promptText);
      final response = await _model.generateContent([content]);
      final responseText = response.text;
      
      if (responseText == null) {
        throw Exception('Empty response from Gemini');
      }

      // Split the response into lines and clean up
      final prompts = responseText
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.replaceAll(RegExp(r'^\d+\.\s*'), '').trim())
          .take(5)
          .toList();

      // If we don't get exactly 5 prompts, throw an error
      if (prompts.length != 5) {
        throw Exception('Did not receive exactly 5 prompts');
      }

      return prompts;
    } catch (e) {
      // Use logger instead of print in production
      return [
        "Write a short story about a magical garden",
        "Draw your favorite childhood memory",
        "Compose a melody inspired by rainfall",
        "Write a poem about your morning routine",
        "Create a character sketch of someone you met today",
      ];
    }
  }
}