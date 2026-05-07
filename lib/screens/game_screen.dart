import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
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

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late DeckService deck;

  late PlayingCard currentCard;

  PlayingCard? incomingCard;

  int score = 0;
  int highScore = 0;

  bool isAnimating = false;

  double incomingCardTop = -400;

  bool glowEffect = false;

  bool shakeEffect = false;

  final AudioPlayer audioPlayer = AudioPlayer();

  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();

    confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );

    loadHighScore();

    startGame();
  }

  @override
  void dispose() {
    confettiController.dispose();
    audioPlayer.dispose();
    super.dispose();
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

  Future<void> playCorrectSound() async {
    await audioPlayer.play(
      AssetSource('sounds/correct.wav'),
    );
  }

  Future<void> playWrongSound() async {
    await audioPlayer.play(
      AssetSource('sounds/wrong.wav'),
    );
  }

  Future<void> triggerGlow() async {
    setState(() {
      glowEffect = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    setState(() {
      glowEffect = false;
    });
  }

  Future<void> triggerShake() async {
    setState(() {
      shakeEffect = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      shakeEffect = false;
    });
  }

  Future<void> guess(bool higher) async {
    if (isAnimating) return;

    if (deck.remainingCards() == 0) {
      showGameOver(
        currentCard,
        currentCard,
        higher,
      );

      return;
    }

    final nextCard = deck.drawCard();

    setState(() {
      incomingCard = nextCard;
      incomingCardTop = -400;
      isAnimating = true;
    });

    await Future.delayed(const Duration(milliseconds: 100));

    setState(() {
      incomingCardTop = 0;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    bool isCorrect;

    if (higher) {
      isCorrect = nextCard.value >= currentCard.value;
    } else {
      isCorrect = nextCard.value <= currentCard.value;
    }

    if (isCorrect) {
      await playCorrectSound();

      triggerGlow();

      confettiController.play();

      setState(() {
        currentCard = nextCard;

        incomingCard = null;

        score++;

        if (score > highScore) {
          highScore = score;
          saveHighScore();
        }

        isAnimating = false;
      });
    } else {
      await playWrongSound();

      await triggerShake();

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

  Color getCardColor(String suit) {
    if (suit == '♥' || suit == '♦') {
      return Colors.red;
    }

    return Colors.white;
  }

  Widget buildCard(PlayingCard card) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 180,
      height: 260,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: glowEffect ? Colors.greenAccent : Colors.white,
          width: glowEffect ? 5 : 3,
        ),
        boxShadow: [
          BoxShadow(
            color: glowEffect
                ? Colors.greenAccent.withOpacity(0.8)
                : Colors.black.withOpacity(0.4),
            blurRadius: glowEffect ? 30 : 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${card.rank}${card.suit}',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: getCardColor(card.suit),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shakeOffset = shakeEffect
        ? sin(DateTime.now().millisecondsSinceEpoch * 0.05) * 12
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Higher or Lower'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),

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
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[300],
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Cards Remaining: ${deck.remainingCards()}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[400],
                  ),
                ),

                const SizedBox(height: 60),

                Transform.translate(
                  offset: Offset(shakeOffset, 0),
                  child: SizedBox(
                    width: 220,
                    height: 320,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        buildCard(currentCard),

                        if (incomingCard != null)
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                            top: incomingCardTop,
                            child: buildCard(incomingCard!),
                          ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => guess(false),
                        child: const Text(
                          'Lower',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 140,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => guess(true),
                        child: const Text(
                          'Higher',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}