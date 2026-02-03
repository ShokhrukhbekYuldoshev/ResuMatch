class ParserUtils {
  static double extractScore(String text) {
    // Looks for "Match Score: 85%" or "Score: 85"
    final regExp = RegExp(r'(\d+)%');
    final match = regExp.firstMatch(text);
    if (match != null) {
      return double.parse(match.group(1)!) / 100;
    }
    return 0.0; // Default if not found
  }
}
