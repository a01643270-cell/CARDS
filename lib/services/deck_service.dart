import 'dart:math';

import '../models/card_model.dart';

class DeckService {
  final List<PlayingCard> _deck = [];

  DeckService() {
    _generateDeck();
    shuffleDeck();
  }

  void _generateDeck() {
    final suits = ['♠', '♥', '♦', '♣'];

    final ranks = [
      {'rank': 'A', 'value': 14},
      {'rank': 'K', 'value': 13},
      {'rank': 'Q', 'value': 12},
      {'rank': 'J', 'value': 11},
      {'rank': '10', 'value': 10},
      {'rank': '9', 'value': 9},
      {'rank': '8', 'value': 8},
      {'rank': '7', 'value': 7},
      {'rank': '6', 'value': 6},
      {'rank': '5', 'value': 5},
      {'rank': '4', 'value': 4},
      {'rank': '3', 'value': 3},
      {'rank': '2', 'value': 2},
    ];

    for (var suit in suits) {
      for (var rankData in ranks) {
        _deck.add(
          PlayingCard(
            suit: suit,
            rank: rankData['rank'] as String,
            value: rankData['value'] as int,
          ),
        );
      }
    }
  }

  void shuffleDeck() {
    _deck.shuffle(Random());
  }

  PlayingCard drawCard() {
    return _deck.removeLast();
  }

  int remainingCards() {
    return _deck.length;
  }
}