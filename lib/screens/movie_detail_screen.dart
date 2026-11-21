import 'package:flutter/material.dart';

import '../models/counter_review.dart';
import '../models/movie.dart';
import '../models/review.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/common_widgets.dart';
import '../widgets/movie_widgets.dart';
import '../widgets/review_widgets.dart';
import 'counter_reviews_screen.dart';
import 'reviews_screen.dart';
import 'write_review_screen.dart';

/// Shows one movie: poster, release year, genres, average rating, summary
/// and its top reviews. Opened from the Home and Search Results screens.
class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key, required this.movie});

  final Movie movie;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  /// How many reviews are shown here before "See all".
  static const int _topReviewCount = 3;

  /// Placeholder data until reviews are loaded from Firebase in Step 3.
  late final List<Review> _reviews = _sampleReviews(widget.movie);

  bool _isOwn(Review review) => review.username == WriteReviewScreen.currentUser;

  /// Total shown in the header: the movie's count plus reviews written here.
  int get _reviewCount =>
      widget.movie.reviewCount + _reviews.where(_isOwn).length;

  /// The user's own reviews first, then the most liked ones.
  List<Review> get _topReviews {
    final List<Review> list = List<Review>.of(_reviews)
      ..sort((Review a, Review b) {
        if (_isOwn(a) != _isOwn(b)) return _isOwn(a) ? -1 : 1;
        return b.likes.compareTo(a.likes);
      });
    return list.take(_topReviewCount).toList();
  }

  void _showMessage(String text, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text), action: action));
  }

  void _toggleLike(Review r) {
    setState(() {
      if (r.isLiked) {
        r.isLiked = false;
        r.likes--;
      } else {
        r.isLiked = true;
        r.likes++;
        if (r.isDisliked) {
          r.isDisliked = false;
          r.dislikes--;
        }
      }
    });
  }

  void _toggleDislike(Review r) {
    setState(() {
      if (r.isDisliked) {
        r.isDisliked = false;
        r.dislikes--;
      } else {
        r.isDisliked = true;
        r.dislikes++;
        if (r.isLiked) {
          r.isLiked = false;
          r.likes--;
        }
      }
    });
  }

  // Removes the card right away; "Undo" puts it back in the same place.
  void _deleteReview(Review review) {
    final int index = _reviews.indexOf(review);
    setState(() => _reviews.remove(review));
    _showMessage(
      'Review deleted',
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          if (!mounted) return;
          setState(() => _reviews.insert(index, review));
        },
      ),
    );
  }

  // Waits for the new review from the Write Review screen and adds it on top.
  Future<void> _openWriteReview() async {
    final Review? review = await Navigator.push<Review>(
      context,
      MaterialPageRoute<Review>(
        builder: (_) => WriteReviewScreen(movie: widget.movie),
      ),
    );
    if (review == null || !mounted) return;
    setState(() => _reviews.insert(0, review));
  }

  Future<void> _openAllReviews() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ReviewsScreen(movieTitle: widget.movie.title),
      ),
    );
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _openCounterReviews(Review review) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CounterReviewsScreen(review: review),
      ),
    );
    // Counter reviews may have been added, so refresh the counts.
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Movie movie = widget.movie;
    final List<Review> topReviews = _topReviews;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              movie.title,
              style: AppText.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Text('Movie Details', style: AppText.caption),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: <Widget>[
          _MovieHeader(movie: movie, reviewCount: _reviewCount),
          const SizedBox(height: AppSpacing.l),

          // Summary
          const SectionHeader(title: 'Summary'),
          const SizedBox(height: AppSpacing.s),
          Text(
            movie.summary.isEmpty ? 'No summary yet.' : movie.summary,
            style: movie.summary.isEmpty ? AppText.bodySecondary : AppText.body,
          ),
          const SizedBox(height: AppSpacing.l),

          ElevatedButton.icon(
            onPressed: _openWriteReview,
            icon: const Icon(Icons.rate_review_outlined),
            label: const Text('Write a Review'),
          ),
          const SizedBox(height: AppSpacing.l),

          // Top Reviews
          SectionHeader(
            title: 'Top Reviews',
            action: SeeAllButton(
              label: 'See all ($_reviewCount)',
              onPressed: _openAllReviews,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          if (topReviews.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.l),
              child: Text(
                'No reviews yet. Be the first to write one!',
                style: AppText.bodySecondary,
                textAlign: TextAlign.center,
              ),
            ),
          for (final Review review in topReviews)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.m),
              child: _TopReviewCard(
                review: review,
                isOwn: _isOwn(review),
                onLike: () => _toggleLike(review),
                onDislike: () => _toggleDislike(review),
                onCounterReviews: () => _openCounterReviews(review),
                onDelete: () => _deleteReview(review),
              ),
            ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}

/// Poster on the left, title, year, genres and rating on the right.
class _MovieHeader extends StatelessWidget {
  const _MovieHeader({required this.movie, required this.reviewCount});

  final Movie movie;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // The poster takes about a third of the width (96–140 px),
        // so the text column still has room on small phones.
        final double posterWidth =
            (constraints.maxWidth * 0.36).clamp(96.0, 140.0).toDouble();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MoviePoster(
              imageUrl: movie.posterUrl,
              width: posterWidth,
              height: posterWidth * 1.5,
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(movie.title, style: AppText.h2),
                  const SizedBox(height: AppSpacing.xs),
                  Text('RELEASED ${movie.year}', style: AppText.overline),
                  const SizedBox(height: AppSpacing.s),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: <Widget>[
                      for (final String genre in movie.genres)
                        _GenreTag(label: genre),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.m),
                  MovieRatingBox(rating: movie.rating),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    '$reviewCount REVIEWS · ${movie.debateCount} DEBATES',
                    style: AppText.overline,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Small rounded label for one genre, e.g. "Sci-Fi".
class _GenreTag extends StatelessWidget {
  const _GenreTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(label, style: AppText.caption.copyWith(color: AppColors.white)),
    );
  }
}

/// Short review card: author, rating, the first lines of the text and the
/// like / dislike / counter review buttons. Own reviews also get "Delete".
class _TopReviewCard extends StatelessWidget {
  const _TopReviewCard({
    required this.review,
    required this.isOwn,
    required this.onLike,
    required this.onDislike,
    required this.onCounterReviews,
    required this.onDelete,
  });

  final Review review;
  final bool isOwn;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onCounterReviews;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AuthorRow(
              username: review.username,
              date: review.date,
              trailing: RatingBadge(rating: review.rating),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              review.text,
              style: AppText.body,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.m),
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: <Widget>[
                PillButton(
                  icon: Icons.thumb_up_alt_outlined,
                  label: 'Like ${review.likes}',
                  selected: review.isLiked,
                  onTap: onLike,
                ),
                PillButton(
                  icon: Icons.thumb_down_alt_outlined,
                  label: 'Dislike ${review.dislikes}',
                  selected: review.isDisliked,
                  onTap: onDislike,
                ),
                PillButton(
                  icon: Icons.forum_outlined,
                  label: '${review.counterCount} Counter Reviews',
                  onTap: onCounterReviews,
                ),
                if (isOwn)
                  PillButton(
                    icon: Icons.delete_outline,
                    label: 'Delete',
                    outlined: true,
                    onTap: onDelete,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Three example reviews for [movie] (the ids stay unique per movie).
List<Review> _sampleReviews(Movie movie) {
  return <Review>[
    Review(
      id: movie.id * 100 + 1,
      username: 'username01',
      date: DateTime(2026, 11, 12),
      rating: 8,
      text: 'The story is strong and the ending stays with you for days '
          'after watching it. ${movie.title} rewards you for paying '
          'attention to the small details in the first half.',
      likes: 12,
      dislikes: 3,
      counterReviews: sampleCounterReviews(5),
    ),
    Review(
      id: movie.id * 100 + 2,
      username: 'username02',
      date: DateTime(2026, 11, 10),
      rating: 4,
      text: 'Looks great but the plot is too confusing for me.',
      likes: 8,
      dislikes: 6,
      counterReviews: sampleCounterReviews(2),
    ),
    Review(
      id: movie.id * 100 + 3,
      username: 'username03',
      date: DateTime(2026, 11, 13),
      rating: 7,
      text: 'Good acting and music. The middle part is a bit slow, but it '
          'is still worth watching on a big screen if you can.',
      likes: 4,
      dislikes: 1,
    ),
  ];
}
