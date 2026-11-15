import 'counter_review.dart';

class Review {
  Review({
    required this.id,
    required this.username,
    required this.date,
    required this.rating,
    required this.text,
    this.likes = 0,
    this.dislikes = 0,
    List<CounterReview>? counterReviews,
  }) : counterReviews = counterReviews ?? <CounterReview>[];

  final int id;
  final String username;
  final DateTime date;
  final int rating;
  final String text;

  int likes;
  int dislikes;
  bool isLiked = false;
  bool isDisliked = false;

  final List<CounterReview> counterReviews;

  int get counterCount => counterReviews.length;
}
