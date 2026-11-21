import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/common_widgets.dart';
import '../widgets/movie_widgets.dart';

/// Shows one movie: poster, release year, genres, average rating and summary.
class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key, required this.movie});

  final Movie movie;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _openWriteReview() {
    // TODO: open the Write Review screen once it is built.
    _showMessage('Write Review will open here');
  }

  @override
  Widget build(BuildContext context) {
    final Movie movie = widget.movie;

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
          _MovieHeader(movie: movie, reviewCount: movie.reviewCount),
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
