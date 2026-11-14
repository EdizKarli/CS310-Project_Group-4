/// Data of one review.
///
/// Other screens (Movie Detail, Counter Reviews, Profile) will use
/// this class too, so it lives in its own file.
class Review {
  Review({
    required this.id,
    required this.username,
    required this.date,
    required this.rating,
    required this.text,
    this.likes = 0,
    this.dislikes = 0,
    this.counterCount = 0,
  });

  final int id;
  final String username;
  final DateTime date;
  final int rating; // 1 to 10
  final String text;

  // These values change when the user taps the buttons.
  int likes;
  int dislikes;
  int counterCount;
  bool isLiked = false;
  bool isDisliked = false;
}
