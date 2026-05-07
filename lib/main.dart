import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const HigherLowerApp());
}

class HigherLowerApp extends StatelessWidget {
  const HigherLowerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Higher or Lower',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Higher or Lower'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GameScreen(),
              ),
            );
          },
          child: const Text('Start Game'),
        ),
      ),
    );
  }
}