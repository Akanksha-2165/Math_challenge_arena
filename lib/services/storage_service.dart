import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _easyKey = "best_score_easy";
  static const String _mediumKey = "best_score_medium";
  static const String _hardKey = "best_score_hard";

  /// Save the best score for a difficulty level
  /// Keeps only the highest score
  static Future<void> saveBestScore(String difficulty, int score) async {
    final prefs = await SharedPreferences.getInstance();
    
    final key = _getKey(difficulty);
    if (key == null) return;

    // Get current best score
    int currentBest = prefs.getInt(key) ?? 0;

    // Only save if new score is better
    if (score > currentBest) {
      await prefs.setInt(key, score);
    }
  }

  /// Get the best score for a difficulty level
  static Future<int> getBestScore(String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    
    final key = _getKey(difficulty);
    if (key == null) return 0;

    return prefs.getInt(key) ?? 0;
  }

  /// Clear all scores (useful for testing or reset)
  static Future<void> clearAllScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_easyKey);
    await prefs.remove(_mediumKey);
    await prefs.remove(_hardKey);
  }

  /// Helper to get the correct key for a difficulty
  static String? _getKey(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case "easy":
        return _easyKey;
      case "medium":
        return _mediumKey;
      case "hard":
        return _hardKey;
      default:
        return null;
    }
  }
}
