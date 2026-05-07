import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/card_model.dart';
import '../services/deck_service.dart';
import 'game_over_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late DeckService deck;
  late PlayingCard currentCard;

  int score = 0;
  int highScore = 0;

  @override
  void initState() {
    super.initState();

    loadHighScore();
    startGame();
  }

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  Future<void> saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('highScore', highScore);
  }

  void startGame() {
    deck = DeckService();
    currentCard = deck.drawCard();
    score = 0;

    setState(() {});
  }

  void guess(bool higher) {
    if (deck.remainingCards() == 0) {
      showGameOver(
        currentCard,
        currentCard,
        higher,
      );
      return;
    }

    final nextCard = deck.drawCard();

    bool isCorrect;

    if (higher) {
      isCorrect = nextCard.value >= currentCard.value;
    } else {
      isCorrect = nextCard.value <= currentCard.value;
    }

    if (isCorrect) {
      setState(() {
        currentCard = nextCard;
        score++;

        if (score > highScore) {
          highScore = score;
          saveHighScore();
        }
      });
    } else {
      showGameOver(
        currentCard,
        nextCard,
        higher,
      );
    }
  }

  void showGameOver(
    PlayingCard previousCard,
    PlayingCard revealedCard,
    bool guessedHigher,
  ) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameOverScreen(
          score: score,
          highScore: highScore,
          previousCard: previousCard,
          revealedCard: revealedCard,
          guessedHigher: guessedHigher,
          onRestart: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const GameScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  Color getCardColor() {
    if (currentCard.suit == '♥' || currentCard.suit == '♦') {
      return Colors.red;
    }

    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Higher or Lower'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score: $score',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'High Score: $highScore',
              style: const TextStyle(
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Cards Remaining: ${deck.remainingCards()}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 40),

            Container(
              width: 180,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  '${currentCard.rank}${currentCard.suit}',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: getCardColor(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => guess(false),
                  child: const Text('Lower'),
                ),
                ElevatedButton(
                  onPressed: () => guess(true),
                  child: const Text('Higher'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}