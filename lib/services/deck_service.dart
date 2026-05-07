import 'dart:math';

import '../models/card_model.dart';

class DeckService {
  static final Random _random = Random();

  static final List<String> suits = [
    '♠',
    '♥',
    '♦',
    '♣',
  ];

  static final List<Map<String, dynamic>> ranks = [
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

  static PlayingCard generateRandomCard() {
    final suit = suits[_random.nextInt(suits.length)];
    final rankData = ranks[_random.nextInt(ranks.length)];

    return PlayingCard(
      suit: suit,
      rank: rankData['rank'],
      value: rankData['value'],
    );
  }
}