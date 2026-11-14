import 'package:flutter/material.dart';

import '../models/review.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

enum ReviewSort { newest, highestRating, mostLiked }

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key, required this.movieTitle});
  final String movieTitle;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final List<Review> _reviews = <Review>[
    Review(
      id: 1,
      username: 'username01',
      date: DateTime(2026, 11, 12),
      rating: 8,
      text: 'The actual review is written here. Only a few lines are shown '
          'and to see the entire review the user presses the read more '
          'button. The story is strong and the ending stays with you for '
          'days after watching it.',
      likes: 12,
      dislikes: 3,
      counterCount: 5,
    ),
    Review(
      id: 2,
      username: 'username02',
      date: DateTime(2026, 11, 10),
      rating: 4,
      text: 'Looks great but the plot is too confusing for me.',
      likes: 8,
      dislikes: 6,
      counterCount: 2,
    ),
    Review(
      id: 3,
      username: 'username03',
      date: DateTime(2026, 11, 13),
      rating: 7,
      text: 'Good acting and music. The middle part is a bit slow, but it '
          'is still worth watching on a big screen if you can.',
      likes: 4,
      dislikes: 1,
    ),
  ];

  ReviewSort _sort = ReviewSort.newest;

  List<Review> get _sortedReviews {
    final List<Review> list = List<Review>.of(_reviews);
    switch (_sort) {
      case ReviewSort.newest:
        list.sort((a, b) => b.date.compareTo(a.date));
      case ReviewSort.highestRating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case ReviewSort.mostLiked:
        list.sort((a, b) => b.likes.compareTo(a.likes));
    }
    return list;
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

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _openCounterReviews(Review r) {
    // TODO: push the Counter Reviews Screen when it is written.
    _showMessage('Counter Reviews of ${r.username} will open here');
  }

  void _openFilterSheet() {
    const Map<ReviewSort, String> labels = <ReviewSort, String>{
      ReviewSort.newest: 'Newest first',
      ReviewSort.highestRating: 'Highest rating',
      ReviewSort.mostLiked: 'Most liked',
    };

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Text('Sort reviews', style: AppText.title),
              ),
              for (final ReviewSort option in ReviewSort.values)
                ListTile(
                  title: Text(labels[option]!, style: AppText.body),
                  trailing: option == _sort
                      ? const Icon(Icons.check, color: AppColors.red)
                      : null,
                  onTap: () {
                    setState(() => _sort = option);
                    Navigator.pop(sheetContext);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _openChallengeSheet(Review r) {
    final TextEditingController controller = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true, // lets the sheet move up with the keyboard
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.m,
            right: AppSpacing.m,
            top: AppSpacing.m,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom +
                AppSpacing.m,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Challenge ${r.username}', style: AppText.title),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: controller,
                autofocus: true,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Write your counter review...',
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isEmpty) return;
                  setState(() => r.counterCount++);
                  Navigator.pop(sheetContext);
                  _showMessage('Counter review posted');
                },
                child: const Text('Post Counter Review'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Review> reviews = _sortedReviews;

    return Scaffold(
      appBar: AppBar(
        // Flutter adds a back arrow by itself only when there is a previous
        // screen. We add it here so it is always visible. maybePop does
        // nothing if there is no screen to go back to.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.movieTitle, style: AppText.title),
            const Text('Reviews', style: AppText.caption),
          ],
        ),
        actions: <Widget>[
          TextButton.icon(
            onPressed: _openFilterSheet,
            icon: const Icon(Icons.filter_list),
            label: const Text('Filter'),
          ),
        ],
      ),

      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.m),
        itemCount: reviews.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.m),
        itemBuilder: (BuildContext context, int index) {
          final Review r = reviews[index];
          return _ReviewCard(
            review: r,
            onLike: () => _toggleLike(r),
            onDislike: () => _toggleDislike(r),
            onCounterReviews: () => _openCounterReviews(r),
            onChallenge: () => _openChallengeSheet(r),
          );
        },
      ),

      // Bottom bar. Reviews is part of the Home section, so Home is selected.
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (int index) {
          // TODO: go to Home (index 0) or Profile (index 1) screen.
          _showMessage(index == 0 ? 'Home will open here' : 'Profile will open here');
        },
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}


class _ReviewCard extends StatefulWidget {
  const _ReviewCard({
    required this.review,
    required this.onLike,
    required this.onDislike,
    required this.onCounterReviews,
    required this.onChallenge,
  });

  final Review review;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onCounterReviews;
  final VoidCallback onChallenge;

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _expanded = false;

  String _formatDate(DateTime d) {
    final String day = d.day.toString().padLeft(2, '0');
    final String month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final Review r = widget.review;
    final bool isLong = r.text.length > 120; // needs "Read more"

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Row 1: avatar, username + date, rating
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.surfaceLight,
                  child: Text(r.username[0].toUpperCase(), style: AppText.label),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(r.username, style: AppText.label),
                      Text(_formatDate(r.date), style: AppText.caption),
                    ],
                  ),
                ),
                _RatingBadge(rating: r.rating),
              ],
            ),
            const SizedBox(height: AppSpacing.s),

            // Row 2: review text, cut after 3 lines unless expanded
            Text(
              r.text,
              style: AppText.body,
              maxLines: _expanded ? null : 3,
              overflow: _expanded ? null : TextOverflow.ellipsis,
            ),
            if (isLong)
              TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(_expanded ? 'Show less' : 'Read more'),
              ),
            const SizedBox(height: AppSpacing.s),

            // Row 3: buttons (Wrap moves them to a new line if needed)
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: <Widget>[
                _PillButton(
                  icon: Icons.thumb_up_alt_outlined,
                  label: 'Like ${r.likes}',
                  selected: r.isLiked,
                  onTap: widget.onLike,
                ),
                _PillButton(
                  icon: Icons.thumb_down_alt_outlined,
                  label: 'Dislike ${r.dislikes}',
                  selected: r.isDisliked,
                  onTap: widget.onDislike,
                ),
                _PillButton(
                  icon: Icons.forum_outlined,
                  label: '${r.counterCount} Counter Reviews',
                  onTap: widget.onCounterReviews,
                ),
                _PillButton(
                  icon: Icons.bolt_rounded,
                  label: 'Challenge',
                  outlined: true,
                  onTap: widget.onChallenge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.redSoft,
        borderRadius: BorderRadius.circular(AppRadius.l),
      ),
      child: Text('★ $rating/10', style: AppText.label),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.outlined = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    Color background = AppColors.surfaceLight;
    if (selected) background = AppColors.red;
    if (outlined) background = Colors.transparent;

    final Color foreground = outlined ? AppColors.red : AppColors.white;

    return Material(
      color: background,
      shape: StadiumBorder(
        side: outlined ? const BorderSide(color: AppColors.red) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 16, color: foreground),
              const SizedBox(width: 6),
              Text(label, style: AppText.label.copyWith(color: foreground)),
            ],
          ),
        ),
      ),
    );
  }
}
