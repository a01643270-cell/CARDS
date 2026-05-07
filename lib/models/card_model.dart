class PlayingCard {
  final String suit;
  final String rank;
  final int value;

  PlayingCard({
    required this.suit,
    required this.rank,
    required this.value,
  });

  @override
  String toString() {
    return '$rank$suit';
  }
}