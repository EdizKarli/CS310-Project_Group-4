import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/common_widgets.dart';
import '../widgets/movie_widgets.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({
    super.key,
    this.initialQuery = '',
    this.initialSort = MovieSort.popular,
    this.movies = sampleMovies,
  });

  final String initialQuery;
  final MovieSort initialSort;
  final List<Movie> movies;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  static const String _anyGenre = 'Any';

  late final TextEditingController _queryController =
      TextEditingController(text: widget.initialQuery);

  late MovieSort _sort = widget.initialSort;
  YearFilter _year = YearFilter.any;
  RatingFilter _rating = RatingFilter.any;
  String _genre = _anyGenre;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  String get _query => _queryController.text.trim();

  bool get _hasActiveFilters =>
      _year != YearFilter.any ||
      _rating != RatingFilter.any ||
      _genre != _anyGenre;

  List<Movie> get _results {
    final List<Movie> matches = widget.movies.where((Movie movie) {
      return movie.matchesQuery(_query) &&
          _year.matches(movie.year) &&
          movie.rating >= _rating.minRating &&
          (_genre == _anyGenre || movie.genres.contains(_genre));
    }).toList();
    return sortMovies(matches, _sort);
  }

  String _resultsLabel(int count) {
    if (_query.isEmpty) {
      return '$count ${count == 1 ? 'MOVIE' : 'MOVIES'}';
    }
    return '$count ${count == 1 ? 'RESULT' : 'RESULTS'} '
        'FOR "${_query.toUpperCase()}"';
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

  void _clearQuery() {
    _queryController.clear();
    setState(() {});
  }

  void _clearFilters() {
    setState(() {
      _year = YearFilter.any;
      _rating = RatingFilter.any;
      _genre = _anyGenre;
    });
  }

  Future<void> _pickYear() async {
    final YearFilter? picked = await showSelectionSheet<YearFilter>(
      context: context,
      title: 'Release year',
      options: YearFilter.values,
      selected: _year,
      labelOf: (YearFilter year) => year.label,
    );
    if (picked == null || !mounted) return;
    setState(() => _year = picked);
  }

  Future<void> _pickRating() async {
    final RatingFilter? picked = await showSelectionSheet<RatingFilter>(
      context: context,
      title: 'Minimum rating',
      options: RatingFilter.values,
      selected: _rating,
      labelOf: (RatingFilter rating) => rating.label,
    );
    if (picked == null || !mounted) return;
    setState(() => _rating = picked);
  }

  Future<void> _pickGenre() async {
    final String? picked = await showSelectionSheet<String>(
      context: context,
      title: 'Genre',
      options: <String>[_anyGenre, ...allGenres(widget.movies)],
      selected: _genre,
      labelOf: (String genre) => genre,
    );
    if (picked == null || !mounted) return;
    setState(() => _genre = picked);
  }

  Future<void> _pickSort() async {
    final MovieSort? picked = await showSelectionSheet<MovieSort>(
      context: context,
      title: 'Sort results',
      options: MovieSort.values,
      selected: _sort,
      labelOf: (MovieSort sort) => sort.label,
    );
    if (picked == null || !mounted) return;
    setState(() => _sort = picked);
  }

  @override
  Widget build(BuildContext context) {
    final List<Movie> results = _results;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.maybePop(context),
        ),
        titleSpacing: 0,
        toolbarHeight: 64,
        title: Padding(
          padding: const EdgeInsets.only(right: AppSpacing.m),
          child: _buildSearchField(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.m, AppSpacing.s, AppSpacing.m, AppSpacing.m),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: <Widget>[
          const Text('FILTERS', style: AppText.overline),
          const SizedBox(height: AppSpacing.s),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: <Widget>[
              FilterDropdownChip(
                label: 'Year: ${_year.label}',
                active: _year != YearFilter.any,
                onTap: _pickYear,
              ),
              FilterDropdownChip(
                label: 'Rating: ${_rating.label}',
                active: _rating != RatingFilter.any,
                onTap: _pickRating,
              ),
              FilterDropdownChip(
                label: 'Genre: $_genre',
                active: _genre != _anyGenre,
                onTap: _pickGenre,
              ),
              FilterDropdownChip(
                label: 'Sort: ${_sort.label}',
                onTap: _pickSort,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          // Same height with or without "Clear filters", so the list
          // does not jump when a filter is turned on.
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _resultsLabel(results.length),
                    style: AppText.overline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_hasActiveFilters)
                  TextButton(
                    onPressed: _clearFilters,
                    child: const Text('Clear filters'),
                  ),
              ],
            ),
          ),
          if (results.isEmpty)
            _NoResults(hasActiveFilters: _hasActiveFilters)
          else ...<Widget>[
            for (final Movie movie in results)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.m),
                child: MovieListCard(
                  movie: movie,
                  onTap: () => _openMovie(movie),
                ),
              ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.s),
              child: Text(
                'END OF RESULTS',
                style: AppText.overline,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _queryController,
      textInputAction: TextInputAction.search,
      onChanged: (_) => setState(() {}),
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
      style: AppText.body,
      decoration: InputDecoration(
        hintText: 'Search by title, year or rating',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _queryController.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Clear search',
                onPressed: _clearQuery,
              ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.hasActiveFilters});

  final bool hasActiveFilters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.m),
          const Text('No movies found', style: AppText.title),
          const SizedBox(height: AppSpacing.xs),
          Text(
            hasActiveFilters
                ? 'Try a different search or clear the filters.'
                : 'Try a different title, year or rating.',
            style: AppText.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
