import 'package:flutter/material.dart';
import 'challenge_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int latestScore = 0;

  // 🎨 COLORS
  final Color primary = const Color(0xFF1494BC);
  final Color accent = const Color(0xFFFF4B15);
  final Color bg = Colors.black;

  void navigate(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget buildButton(String text, IconData icon, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 8,
        ),
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: onPressed,
      ),
    );
  }

  void showDifficultySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text(
                "Select Difficulty",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              const SizedBox(height: 28),

              // Easy
              _buildDifficultyCard(
                level: "easy",
                icon: Icons.emoji_emotions,
                description: "Perfect for beginners",
                color: Colors.green,
              ),
              const SizedBox(height: 12),

              // Medium
              _buildDifficultyCard(
                level: "medium",
                icon: Icons.flash_on,
                description: "Challenge yourself",
                color: Colors.orange,
              ),
              const SizedBox(height: 12),

              // Hard
              _buildDifficultyCard(
                level: "hard",
                icon: Icons.whatshot,
                description: "Ultimate test",
                color: Colors.red,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDifficultyCard({
    required String level,
    required IconData icon,
    required String description,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);

        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChallengeScreen(difficulty: level),
          ),
        );

        if (result != null) {
          setState(() {
            latestScore = result;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
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
                    level.toUpperCase(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // 🔥 Title
              Text(
                "Math Challenge Arena",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),

              const SizedBox(height: 10),

              // Score
              Text(
                "Latest Score: $latestScore",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 40),

              // Start
              buildButton(
                "Start Challenge",
                Icons.play_arrow,
                showDifficultySelector,
              ),

              // Leaderboard
              buildButton(
                "Leaderboard",
                Icons.emoji_events,
                () => navigate(const LeaderboardScreen()),
              ),

              // Profile
              buildButton(
                "Profile",
                Icons.person,
                () => navigate(const ProfileScreen()),
              ),

              const Spacer(),

              // 🔥 Accent line (premium touch)
              Container(
                height: 4,
                width: 100,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
