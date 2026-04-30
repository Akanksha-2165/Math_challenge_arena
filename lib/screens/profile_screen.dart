import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  Widget buildStatCard(String label, int score, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.3), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "$score/10",
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalScore = easy + medium + hard;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF1494BC),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Avatar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1494BC), Color(0xFFFF4B15)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Color(0xFF1494BC)),
                ),
              ),

              const SizedBox(height: 24),

              // Username
              const Text(
                "Akanksha",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              // Total Score
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.5),
                  ),
                ),
                child: Text(
                  "Total Score: $totalScore/30",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Stat Cards
              Row(
                children: [
                  buildStatCard("Easy", easy, Colors.green, Icons.emoji_emotions),
                  const SizedBox(width: 12),
                  buildStatCard(
                    "Medium",
                    medium,
                    Colors.orange,
                    Icons.flash_on,
                  ),
                  const SizedBox(width: 12),
                  buildStatCard("Hard", hard, Colors.red, Icons.whatshot),
                ],
              ),

              const SizedBox(height: 40),

              // Achievements Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Achievements",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAchievement(
                      "🎯 First Challenge",
                      "Complete any challenge",
                      easy > 0 || medium > 0 || hard > 0,
                    ),
                    const SizedBox(height: 12),
                    _buildAchievement(
                      "⚡ Speed Demon",
                      "Score 8+ in Medium",
                      medium >= 8,
                    ),
                    const SizedBox(height: 12),
                    _buildAchievement(
                      "🔥 Master Mind",
                      "Score 8+ in Hard",
                      hard >= 8,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievement(
    String title,
    String description,
    bool unlocked,
  ) {
    return Row(
      children: [
        Text(
          unlocked ? "✅" : "🔒",
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: unlocked ? Colors.white : Colors.white54,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
