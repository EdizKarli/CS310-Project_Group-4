class CounterReview {
  CounterReview({
    required this.username,
    required this.date,
    required this.text,
    this.likes = 0,
    this.dislikes = 0,
  });

  final String username;
  final DateTime date;
  final String text;

  int likes;
  int dislikes;
  bool isLiked = false;
  bool isDisliked = false;
}

List<CounterReview> sampleCounterReviews(int count) {
  const List<String> texts = <String>[
    'I disagree. The plot is not confusing at all if you pay attention to '
        'the small details in the first half. Everything is explained '
        'before the ending, you just need to watch carefully.',
    'Fair points, but the music alone makes it worth a higher rating.',
    'The slow parts are there on purpose. They build the tension for the '
        'final act and make the ending hit much harder.',
    'I think you are being too generous here.',
    'Watched it twice and liked it more the second time.',
  ];

  return List<CounterReview>.generate(count, (int i) {
    return CounterReview(
      username: 'debater0${i + 1}',
      date: DateTime(2026, 11, 14 - i),
      text: texts[i % texts.length],
      likes: 10 - i * 2,
      dislikes: i,
    );
  });
}
