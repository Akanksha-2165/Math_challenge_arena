import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int easy = 0;
  int medium = 0;
  int hard = 0;

  @override
  void initState() {
    super.initState();
    loadScores();
  }

  void loadScores() async {
    final easyScore = await StorageService.getBestScore("easy");
    final mediumScore = await StorageService.getBestScore("medium");
    final hardScore = await StorageService.getBestScore("hard");

    setState(() {
      easy = easyScore;
      medium = mediumScore;
      hard = hardScore;
    });
  }

  Widget buildTile(String difficulty, int score, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    difficulty.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Best Score",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$score/10",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Leaderboard 🏆"),
        backgroundColor: const Color(0xFF1494BC),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Best Scores",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1494BC),
              ),
            ),
            const SizedBox(height: 24),
            buildTile("Easy", easy, Icons.emoji_emotions, Colors.green),
            buildTile("Medium", medium, Icons.flash_on, Colors.orange),
            buildTile("Hard", hard, Icons.whatshot, Colors.red),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                border: Border.all(color: Colors.blue.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.blue.withOpacity(0.7),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Complete challenges to update your scores here!",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
