import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

/// Poster placeholder box used until real poster images are added.
class MoviePoster extends StatelessWidget {
  const MoviePoster({super.key, this.width = 56, this.height = 84});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.s),
        border: Border.all(color: AppColors.border),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.surfaceLight, AppColors.surface],
        ),
      ),
      child: Icon(
        Icons.movie_outlined,
        size: width * 0.4,
        color: AppColors.textSecondary,
      ),
    );
  }
}

/// Average movie rating shown as "8.4/10".
class MovieRatingBox extends StatelessWidget {
  const MovieRatingBox({super.key, required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.redSoft,
        borderRadius: BorderRadius.circular(AppRadius.l),
      ),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(text: rating.toStringAsFixed(1), style: AppText.title),
            const TextSpan(text: '/10', style: AppText.caption),
          ],
        ),
      ),
    );
  }
}

/// Movie row used in the "All Movies" list and in search results.
class MovieListCard extends StatelessWidget {
  const MovieListCard({super.key, required this.movie, required this.onTap});

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const MoviePoster(),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      movie.title,
                      style: AppText.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${movie.year} · ${movie.genreLabel}'.toUpperCase(),
                      style: AppText.overline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      '${movie.reviewCount} REVIEWS · '
                      '${movie.debateCount} DEBATES',
                      style: AppText.overline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              MovieRatingBox(rating: movie.rating),
            ],
          ),
        ),
      ),
    );
  }
}

/// Poster tile used in the horizontally scrolling "Trending Now" row.
class TrendingMovieTile extends StatelessWidget {
  const TrendingMovieTile({
    super.key,
    required this.movie,
    required this.onTap,
    this.width = 116,
  });

  final Movie movie;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MoviePoster(width: width, height: width * 1.5),
            const SizedBox(height: AppSpacing.s),
            Text(
              movie.title,
              style: AppText.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '★ ${movie.rating.toStringAsFixed(1)} · ${movie.year}',
              style: AppText.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
