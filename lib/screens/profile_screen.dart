import 'package:flutter/material.dart';

import '../models/counter_review.dart';
import '../models/review.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/review_widgets.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _MyReview {
  _MyReview({required this.movieTitle, required this.review});

  final String movieTitle;
  final Review review;
}

class _MyCounter {
  _MyCounter({
    required this.movieTitle,
    required this.originalAuthor,
    required this.counter,
  });

  final String movieTitle;
  final String originalAuthor;
  final CounterReview counter;
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _username = 'cinedeb_user';
  final DateTime _joinDate = DateTime(2026, 9, 1);

  int _tab = 0;

  final List<_MyReview> _myReviews = <_MyReview>[
    _MyReview(
      movieTitle: 'Inception',
      review: Review(
        id: 101,
        username: 'cinedeb_user',
        date: DateTime(2026, 11, 8),
        rating: 9,
        text: 'One of the best endings I have ever seen. The idea of dreams '
            'inside dreams is explained clearly and the music is amazing.',
        likes: 21,
        dislikes: 2,
        counterReviews: sampleCounterReviews(3),
      ),
    ),
    _MyReview(
      movieTitle: 'Interstellar',
      review: Review(
        id: 102,
        username: 'cinedeb_user',
        date: DateTime(2026, 10, 30),
        rating: 7,
        text: 'Beautiful visuals, but the last part was too long for me.',
        likes: 9,
        dislikes: 4,
        counterReviews: sampleCounterReviews(1),
      ),
    ),
  ];

  final List<_MyCounter> _myCounters = <_MyCounter>[
    _MyCounter(
      movieTitle: 'Inception',
      originalAuthor: 'username02',
      counter: CounterReview(
        username: 'cinedeb_user',
        date: DateTime(2026, 11, 11),
        text: 'The plot is not confusing if you watch the first half '
            'carefully. Every rule is explained before it is used.',
        likes: 6,
        dislikes: 1,
      ),
    ),
  ];

  int get _totalLikes {
    int total = 0;
    for (final _MyReview r in _myReviews) {
      total += r.review.likes;
    }
    for (final _MyCounter c in _myCounters) {
      total += c.counter.likes;
    }
    return total;
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _deleteReview(_MyReview item) {
    setState(() => _myReviews.remove(item));
    _showMessage('Review deleted');
  }

  void _deleteCounter(_MyCounter item) {
    setState(() => _myCounters.remove(item));
    _showMessage('Counter review deleted');
  }

  Future<void> _confirmLogOut() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to log in again to use CineDeb.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: _confirmLogOut,
            icon: const Icon(Icons.logout),
            label: const Text('Log Out'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: <Widget>[
          _ProfileHeader(username: _username, joinDate: _joinDate),
          const SizedBox(height: AppSpacing.m),
          Row(
            children: <Widget>[
              Expanded(
                child: _StatBox(value: _myReviews.length, label: 'Reviews'),
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: _StatBox(value: _myCounters.length, label: 'Counters'),
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: _StatBox(value: _totalLikes, label: 'Likes'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.l),
          SegmentedButton<int>(
            segments: const <ButtonSegment<int>>[
              ButtonSegment<int>(value: 0, label: Text('My Reviews')),
              ButtonSegment<int>(value: 1, label: Text('My Counters')),
            ],
            selected: <int>{_tab},
            showSelectedIcon: false,
            onSelectionChanged: (Set<int> s) => setState(() => _tab = s.first),
          ),
          const SizedBox(height: AppSpacing.m),
          if (_tab == 0) ..._buildReviewList() else ..._buildCounterList(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (int index) {
          if (index == 0) Navigator.maybePop(context);
        },
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  List<Widget> _buildReviewList() {
    if (_myReviews.isEmpty) {
      return const <Widget>[_EmptyText('You have not written any reviews yet.')];
    }
    return <Widget>[
      for (final _MyReview item in _myReviews)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.m),
          child: _ProfileItemCard(
            title: item.movieTitle,
            subtitle: formatDate(item.review.date),
            text: item.review.text,
            rating: item.review.rating,
            likes: item.review.likes,
            counterCount: item.review.counterCount,
            onDelete: () => _deleteReview(item),
          ),
        ),
    ];
  }

  List<Widget> _buildCounterList() {
    if (_myCounters.isEmpty) {
      return const <Widget>[
        _EmptyText('You have not written any counter reviews yet.'),
      ];
    }
    return <Widget>[
      for (final _MyCounter item in _myCounters)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.m),
          child: _ProfileItemCard(
            title: item.movieTitle,
            subtitle: 'On ${item.originalAuthor}\'s review · '
                '${formatDate(item.counter.date)}',
            text: item.counter.text,
            likes: item.counter.likes,
            onDelete: () => _deleteCounter(item),
          ),
        ),
    ];
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.username, required this.joinDate});

  final String username;
  final DateTime joinDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.red,
          child: Text(
            username[0].toUpperCase(),
            style: AppText.h2,
          ),
        ),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('@$username', style: AppText.h2),
              const SizedBox(height: AppSpacing.xs),
              Text('Joined ${formatDate(joinDate)}', style: AppText.caption),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
        child: Column(
          children: <Widget>[
            Text('$value', style: AppText.h2.copyWith(color: AppColors.red)),
            const SizedBox(height: AppSpacing.xs),
            Text(label, style: AppText.caption),
          ],
        ),
      ),
    );
  }
}

class _ProfileItemCard extends StatelessWidget {
  const _ProfileItemCard({
    required this.title,
    required this.subtitle,
    required this.text,
    required this.likes,
    required this.onDelete,
    this.rating,
    this.counterCount,
  });

  final String title;
  final String subtitle;
  final String text;
  final int likes;
  final VoidCallback onDelete;
  final int? rating;
  final int? counterCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title, style: AppText.title),
                      Text(subtitle, style: AppText.caption),
                    ],
                  ),
                ),
                if (rating != null) RatingBadge(rating: rating!),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              text,
              style: AppText.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              children: <Widget>[
                const Icon(Icons.thumb_up_alt_outlined,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.xs),
                Text('$likes', style: AppText.caption),
                if (counterCount != null) ...<Widget>[
                  const SizedBox(width: AppSpacing.m),
                  const Icon(Icons.forum_outlined,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.xs),
                  Text('$counterCount counter reviews', style: AppText.caption),
                ],
                const Spacer(),
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

class _EmptyText extends StatelessWidget {
  const _EmptyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.l),
      child: Text(
        text,
        style: AppText.bodySecondary,
        textAlign: TextAlign.center,
      ),
    );
  }
}
