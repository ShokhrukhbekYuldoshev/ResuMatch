import 'package:firebase_ai/firebase_ai.dart';

class AIService {
  // Use Gemini 3 Flash for the fastest text analysis
  final _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash-lite',
  );

  Future<String> analyzeResume(String resume, String jd) async {
    final prompt =
        """
        Analyze this Resume against this JD. 
        You MUST return ONLY a valid JSON object with this exact structure:
        {
          "score": 85,
          "analysis_summary": "Short summary here",
          "missing_skills": ["Python", "Docker", "AWS"],
          "strengths": ["Flutter development", "Clean Architecture"],
          "action_steps": ["Add a section for CI/CD", "Highlight Firebase projects"]
        }
        
        Resume: $resume
        JD: $jd
        """;

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? "Analysis failed.";
    } catch (e) {
      return "AI Logic Error: ${e.toString()}";
    }
  }
}
