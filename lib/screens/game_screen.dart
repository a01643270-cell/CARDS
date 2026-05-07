import 'package:flutter/material.dart';

import '../models/card_model.dart';
import '../services/deck_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late PlayingCard currentCard;
  int score = 0;
  String resultMessage = '';

  @override
  void initState() {
    super.initState();
    currentCard = DeckService.generateRandomCard();
  }

  void guess(bool higher) {
    final nextCard = DeckService.generateRandomCard();

    bool isCorrect;

    if (higher) {
      isCorrect = nextCard.value >= currentCard.value;
    } else {
      isCorrect = nextCard.value <= currentCard.value;
    }

    setState(() {
      currentCard = nextCard;

      if (isCorrect) {
        score++;
        resultMessage = 'Correct!';
      } else {
        score = 0;
        resultMessage = 'Wrong!';
      }
    });
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

            const SizedBox(height: 40),

            Text(
              resultMessage,
              style: const TextStyle(
                fontSize: 28,
              ),
            ),

            const SizedBox(height: 40),

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