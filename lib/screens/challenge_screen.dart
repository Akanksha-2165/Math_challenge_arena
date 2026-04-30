
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../services/storage_service.dart';

class ChallengeScreen extends StatefulWidget {
  final String difficulty;

  const ChallengeScreen({super.key, required this.difficulty});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  int score = 0;
  int lives = 3;
  int timeLeft = 15;
  int questionsAnswered = 0;
  final int totalQuestions = 10; // Set a limit of 10 questions per game

  late Timer timer;

  String question = "";
  List<String> options = [];
  String correctAnswer = "";
  bool isAnswered = false;

  @override
  void initState() {
    super.initState();
    generateQuestion();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        timeLeft--;
      });

      if (timeLeft == 0) {
        handleWrong();
      }
    });
  }

  void resetTimer() {
    timeLeft = 15;
  }

  void generateQuestion() {
    final rand = Random();
    int a, b;
    int answer;

    if (widget.difficulty == "easy") {
      a = rand.nextInt(10);
      b = rand.nextInt(10);
      answer = a + b;
      question = "$a + $b = ?";
    } else if (widget.difficulty == "medium") {
      a = rand.nextInt(20);
      b = rand.nextInt(10);
      answer = a * b;
      question = "$a × $b = ?";
    } else {
      b = rand.nextInt(9) + 1;
      answer = rand.nextInt(10);
      a = answer * b;
      question = "$a ÷ $b = ?";
    }

    correctAnswer = answer.toString();

    options = [correctAnswer];
    while (options.length < 4) {
      int fake = answer + rand.nextInt(5) - 2;
      if (!options.contains(fake.toString()) && fake >= 0) {
        options.add(fake.toString());
      }
    }

    options.shuffle();
    isAnswered = false;
  }

  void answerQuestion(String selected) {
    if (isAnswered) return; // Prevent multiple answers

    setState(() {
      isAnswered = true;
    });

    if (selected == correctAnswer) {
      score++;
      questionsAnswered++;

      // Check if game should end
      if (questionsAnswered >= totalQuestions) {
        Future.delayed(const Duration(milliseconds: 500), () => endGame());
      } else {
        Future.delayed(const Duration(milliseconds: 600), () => nextQuestion());
      }
    } else {
      handleWrong();
    }
  }

  void handleWrong() {
    lives--;
    questionsAnswered++;

    if (lives == 0) {
      endGame();
    } else {
      Future.delayed(const Duration(milliseconds: 600), () => nextQuestion());
    }
  }

  void nextQuestion() {
    if (mounted) {
      setState(() {
        generateQuestion();
        resetTimer();
      });
    }
  }

  void endGame() async {
    timer.cancel();

    // Save score to storage
    await StorageService.saveBestScore(widget.difficulty, score);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Game Over"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Score: $score / $totalQuestions",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Difficulty: ${widget.difficulty.toUpperCase()}",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, score);
              },
              child: const Text("Go Home"),
            )
          ],
        ),
      );
    }
  }

  Color getTimerColor() {
    if (timeLeft > 10) return Colors.green;
    if (timeLeft > 5) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        title: Text(widget.difficulty.toUpperCase()),
        backgroundColor: const Color(0xFF1494BC),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Top Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Score
                Column(
                  children: [
                    const Text(
                      "Score",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$score",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Progress
                Column(
                  children: [
                    const Text(
                      "Progress",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$questionsAnswered/$totalQuestions",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Lives
                Column(
                  children: [
                    const Text(
                      "Lives",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        3,
                        (index) => Icon(
                          Icons.favorite,
                          color: index < lives ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Timer with visual indicator
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: getTimerColor().withOpacity(0.2),
                border: Border.all(color: getTimerColor(), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "⏱️ Time: ${timeLeft}s",
                style: TextStyle(
                  color: getTimerColor(),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Question card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1494BC), Color(0xFFFF4B15)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepOrange.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                question,
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),

            // Options
            Expanded(
              child: ListView(
                children: options.map((opt) {
                  bool isCorrect = opt == correctAnswer;
                  bool isSelectedWrong = isAnswered && opt != correctAnswer;

                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAnswered
                            ? (isCorrect
                                ? Colors.green
                                : (isSelectedWrong
                                    ? Colors.red
                                    : const Color(0xFF1494BC)))
                            : const Color(0xFF1494BC),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      onPressed: isAnswered ? null : () => answerQuestion(opt),
                      child: Text(
                        opt,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
