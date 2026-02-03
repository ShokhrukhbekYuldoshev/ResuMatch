class AnalysisResult {
  final double score;
  final String summary;
  final List<String> missingSkills;
  final List<String> strengths;
  final List<String> actionSteps;

  AnalysisResult({
    required this.score,
    required this.summary,
    required this.missingSkills,
    required this.strengths,
    required this.actionSteps,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      score: (json['score'] as num).toDouble() / 100,
      summary: json['analysis_summary'] ?? '',
      missingSkills: List<String>.from(json['missing_skills'] ?? []),
      strengths: List<String>.from(json['strengths'] ?? []),
      actionSteps: List<String>.from(json['action_steps'] ?? []),
    );
  }
}
