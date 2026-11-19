import 'package:flutter/material.dart';

import '../models/counter_review.dart';
import '../models/review.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/review_widgets.dart';
import 'profile_screen.dart';

class CounterReviewsScreen extends StatefulWidget {
  const CounterReviewsScreen({super.key, required this.review});

  final Review review;

  @override
  State<CounterReviewsScreen> createState() => _CounterReviewsScreenState();
}

class _CounterReviewsScreenState extends State<CounterReviewsScreen> {
  void _toggleLike(CounterReview c) {
    setState(() {
      if (c.isLiked) {
        c.isLiked = false;
        c.likes--;
      } else {
        c.isLiked = true;
        c.likes++;
        if (c.isDisliked) {
          c.isDisliked = false;
          c.dislikes--;
        }
      }
    });
  }

  void _toggleDislike(CounterReview c) {
    setState(() {
      if (c.isDisliked) {
        c.isDisliked = false;
        c.dislikes--;
      } else {
        c.isDisliked = true;
        c.dislikes++;
        if (c.isLiked) {
          c.isLiked = false;
          c.likes--;
        }
      }
    });
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _openChallengeSheet() {
    final TextEditingController controller = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
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
              Text('Challenge ${widget.review.username}',
                  style: AppText.title),
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
                  setState(() {
                    widget.review.counterReviews.insert(
                      0,
                      CounterReview(
                        username: 'you',
                        date: DateTime.now(),
                        text: controller.text.trim(),
                      ),
                    );
                  });
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
    final Review review = widget.review;
    final List<CounterReview> counters = review.counterReviews;

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
            const Text('Counter Reviews', style: AppText.title),
            Text('on ${review.username}\'s review', style: AppText.caption),
          ],
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: <Widget>[
          _OriginalReviewCard(
            review: review,
            onChallenge: _openChallengeSheet,
          ),
          const SizedBox(height: AppSpacing.l),
          Text('${counters.length} Counter Reviews', style: AppText.title),
          const SizedBox(height: AppSpacing.s),

          if (counters.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.l),
              child: Text(
                'No counter reviews yet. Be the first to challenge!',
                style: AppText.bodySecondary,
                textAlign: TextAlign.center,
              ),
            ),

          for (final CounterReview c in counters)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.m),
              child: _CounterReviewCard(
                counter: c,
                onLike: () => _toggleLike(c),
                onDislike: () => _toggleDislike(c),
              ),
            ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (int index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
            );
          } else {
            Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
          }
        },
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _OriginalReviewCard extends StatelessWidget {
  const _OriginalReviewCard({required this.review, required this.onChallenge});

  final Review review;
  final VoidCallback onChallenge;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.l),
        side: const BorderSide(color: AppColors.red),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'ORIGINAL REVIEW',
              style: AppText.caption.copyWith(color: AppColors.red),
            ),
            const SizedBox(height: AppSpacing.s),
            AuthorRow(
              username: review.username,
              date: review.date,
              trailing: RatingBadge(rating: review.rating),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(review.text, style: AppText.body),
            const SizedBox(height: AppSpacing.m),
            PillButton(
              icon: Icons.bolt_rounded,
              label: 'Challenge',
              outlined: true,
              onTap: onChallenge,
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterReviewCard extends StatefulWidget {
  const _CounterReviewCard({
    required this.counter,
    required this.onLike,
    required this.onDislike,
  });

  final CounterReview counter;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  @override
  State<_CounterReviewCard> createState() => _CounterReviewCardState();
}

class _CounterReviewCardState extends State<_CounterReviewCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final CounterReview c = widget.counter;
    final bool isLong = c.text.length > 120;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AuthorRow(username: c.username, date: c.date),
            const SizedBox(height: AppSpacing.s),
            Text(
              c.text,
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
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: <Widget>[
                PillButton(
                  icon: Icons.thumb_up_alt_outlined,
                  label: 'Like ${c.likes}',
                  selected: c.isLiked,
                  onTap: widget.onLike,
                ),
                PillButton(
                  icon: Icons.thumb_down_alt_outlined,
                  label: 'Dislike ${c.dislikes}',
                  selected: c.isDisliked,
                  onTap: widget.onDislike,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
