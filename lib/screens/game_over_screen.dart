import 'package:flutter/material.dart';

import '../models/card_model.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final int highScore;

  final PlayingCard previousCard;
  final PlayingCard revealedCard;

  final bool guessedHigher;

  final VoidCallback onRestart;

  const GameOverScreen({
    super.key,
    required this.score,
    required this.highScore,
    required this.previousCard,
    required this.revealedCard,
    required this.guessedHigher,
    required this.onRestart,
  });

  Color getCardColor(String suit) {
    if (suit == '♥' || suit == '♦') {
      return Colors.red;
    }

    return Colors.white;
  }

  String getResultText() {
    if (guessedHigher) {
      return 'You guessed HIGHER';
    }

    return 'You guessed LOWER';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Game Over',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              getResultText(),
              style: const TextStyle(
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCard(previousCard),
                buildCard(revealedCard),
              ],
            ),

            const SizedBox(height: 40),

            Text(
              'Score: $score',
              style: const TextStyle(fontSize: 28),
            ),

            const SizedBox(height: 10),

            Text(
              'High Score: $highScore',
              style: const TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: onRestart,
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(PlayingCard card) {
    return Container(
      width: 120,
      height: 180,
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
          '${card.rank}${card.suit}',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: getCardColor(card.suit),
          ),
        ),
      ),
    );
  }
}