import 'package:flutter/material.dart';

import '../models/counter_review.dart';
import '../models/movie.dart';
import '../models/review.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/auth_components.dart';
import '../widgets/common_widgets.dart';
import '../widgets/movie_widgets.dart';
import '../widgets/review_widgets.dart';
import 'counter_reviews_screen.dart';
import 'profile_screen.dart';
import 'reviews_screen.dart';
import 'search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.username = 'cinedeb_user'});

  final String username;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// A popular review shown in the "Hot Debates" section.
class _HotDebate {
  _HotDebate({required this.movieTitle, required this.review});

  final String movieTitle;
  final Review review;
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Movie> _movies = sampleMovies;
  MovieSort _sort = MovieSort.popular;

  final List<_HotDebate> _hotDebates = <_HotDebate>[
    _HotDebate(
      movieTitle: 'Inception',
      review: Review(
        id: 1,
        username: 'username01',
        date: DateTime(2026, 11, 12),
        rating: 8,
        text: 'The story is strong and the ending stays with you for days '
            'after watching it. The dream levels are easy to follow once '
            'you notice the small details in the first half.',
        likes: 12,
        dislikes: 3,
        counterReviews: sampleCounterReviews(5),
      ),
    ),
    _HotDebate(
      movieTitle: 'Parasite',
      review: Review(
        id: 2,
        username: 'filmbuff',
        date: DateTime(2026, 11, 16),
        rating: 6,
        text: 'The first half is brilliant and funny, but the ending turns '
            'violent too suddenly. It felt like a different movie and I did '
            'not enjoy the last twenty minutes as much.',
        likes: 18,
        dislikes: 9,
        counterReviews: sampleCounterReviews(3),
      ),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _openMovie(Movie movie) {
    // TODO: open the Movie Detail screen once it is built.
    _showMessage('${movie.title} details will open here');
  }

  void _openSearch({String query = '', MovieSort sort = MovieSort.popular}) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SearchResultsScreen(
          initialQuery: query,
          initialSort: sort,
        ),
      ),
    );
  }

  void _submitSearch() {
    FocusScope.of(context).unfocus();
    _openSearch(query: _searchController.text.trim());
  }

  void _openProfile({int tab = 0}) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => ProfileScreen(initialTab: tab)),
    );
  }

  Future<void> _openReviews(_HotDebate debate) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ReviewsScreen(movieTitle: debate.movieTitle),
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

  Future<void> _openSortSheet() async {
    final MovieSort? picked = await showSelectionSheet<MovieSort>(
      context: context,
      title: 'Sort movies',
      options: MovieSort.values,
      selected: _sort,
      labelOf: (MovieSort sort) => sort.label,
    );
    if (picked == null || !mounted) return;
    setState(() => _sort = picked);
  }

  @override
  Widget build(BuildContext context) {
    final List<Movie> trending = trendingMovies(_movies);
    final List<Movie> allMovies = sortMovies(_movies, _sort);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const BrandBadge(),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: AppSpacing.s, bottom: AppSpacing.m),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: <Widget>[
          Padding(
            padding: AppSpacing.screen,
            child: _buildGreeting(),
          ),
          const SizedBox(height: AppSpacing.m),
          Padding(
            padding: AppSpacing.screen,
            child: _buildSearchBar(),
          ),
          const SizedBox(height: AppSpacing.m),
          Padding(
            padding: AppSpacing.screen,
            child: _buildQuickAccess(),
          ),
          const SizedBox(height: AppSpacing.l),

          // Trending Now
          Padding(
            padding: AppSpacing.screen,
            child: SectionHeader(
              title: 'Trending Now',
              action: SeeAllButton(
                onPressed: () => _openSearch(sort: MovieSort.popular),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          _buildTrendingRow(trending),
          const SizedBox(height: AppSpacing.l),

          // Hot Debates
          const Padding(
            padding: AppSpacing.screen,
            child: SectionHeader(title: 'Hot Debates'),
          ),
          const SizedBox(height: AppSpacing.s),
          for (final _HotDebate debate in _hotDebates)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.m, 0, AppSpacing.m, AppSpacing.m),
              child: _HotDebateCard(
                debate: debate,
                onOpen: () => _openReviews(debate),
                onCounterReviews: () => _openCounterReviews(debate.review),
                onChallenge: () => _openCounterReviews(debate.review),
              ),
            ),
          const SizedBox(height: AppSpacing.s),

          // All Movies
          Padding(
            padding: AppSpacing.screen,
            child: SectionHeader(
              title: 'All Movies',
              action: TextButton.icon(
                onPressed: _openSortSheet,
                icon: const Icon(Icons.sort, size: 18),
                label: Text('Sort: ${_sort.label}'),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          for (final Movie movie in allMovies)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.m, 0, AppSpacing.m, AppSpacing.m),
              child: MovieListCard(
                movie: movie,
                onTap: () => _openMovie(movie),
              ),
            ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'WELCOME BACK, @${widget.username.toUpperCase()}',
          style: AppText.overline,
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text('What are we debating today?', style: AppText.h2),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _submitSearch(),
      style: AppText.body,
      decoration: InputDecoration(
        hintText: 'Search by title, year or rating',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: AppSpacing.xs),
          child: TextButton(
            onPressed: _submitSearch,
            child: const Text('GO'),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccess() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: QuickAccessTile(
                icon: Icons.star_outline_rounded,
                label: 'Top rated',
                onTap: () => _openSearch(sort: MovieSort.rating),
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: QuickAccessTile(
                icon: Icons.calendar_month_outlined,
                label: 'New releases',
                onTap: () => _openSearch(sort: MovieSort.newest),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s),
        Row(
          children: <Widget>[
            Expanded(
              child: QuickAccessTile(
                icon: Icons.rate_review_outlined,
                label: 'My reviews',
                onTap: () => _openProfile(tab: 0),
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: QuickAccessTile(
                icon: Icons.bolt_rounded,
                label: 'My counters',
                onTap: () => _openProfile(tab: 1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrendingRow(List<Movie> movies) {
    // A Row inside a horizontal scroll view takes the height of its tallest
    // tile, so it never overflows when the text size changes.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: AppSpacing.screen,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < movies.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: AppSpacing.m - AppSpacing.xs),
            TrendingMovieTile(
              movie: movies[i],
              onTap: () => _openMovie(movies[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _HotDebateCard extends StatelessWidget {
  const _HotDebateCard({
    required this.debate,
    required this.onOpen,
    required this.onCounterReviews,
    required this.onChallenge,
  });

  final _HotDebate debate;
  final VoidCallback onOpen;
  final VoidCallback onCounterReviews;
  final VoidCallback onChallenge;

  @override
  Widget build(BuildContext context) {
    final Review review = debate.review;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.local_fire_department_outlined,
                    size: 16,
                    color: AppColors.red,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      debate.movieTitle.toUpperCase(),
                      style: AppText.overline.copyWith(color: AppColors.red),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s),
              AuthorRow(
                username: review.username,
                date: review.date,
                trailing: RatingBadge(rating: review.rating),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                review.text,
                style: AppText.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.m),
              Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: <Widget>[
                  PillButton(
                    icon: Icons.forum_outlined,
                    label: '${review.counterCount} Counter Reviews',
                    onTap: onCounterReviews,
                  ),
                  PillButton(
                    icon: Icons.bolt_rounded,
                    label: 'Challenge',
                    outlined: true,
                    onTap: onChallenge,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
