class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genres,
    required this.rating,
    required this.reviewCount,
    required this.debateCount,
    this.posterUrl,
    this.summary = '',
  });

  final int id;
  final String title;
  final int year;
  final List<String> genres;

  /// Average CineDeb rating out of 10.
  final double rating;
  final int reviewCount;
  final int debateCount;
  final String? posterUrl;

  /// Short plot description shown on the Movie Detail screen.
  final String summary;

  /// e.g. "Sci-Fi · Action"
  String get genreLabel => genres.join(' · ');

  /// True if the search text matches the title, year or a genre.
  /// A number up to 10 (e.g. "8" or "8.5") matches movies rated at least that.
  bool matchesQuery(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    if (title.toLowerCase().contains(q)) return true;
    if (year.toString().contains(q)) return true;
    if (genres.any((String g) => g.toLowerCase().contains(q))) return true;

    final double? minRating = double.tryParse(q);
    return minRating != null && minRating <= 10 && rating >= minRating;
  }
}

/// Release year filter on the Search Results screen.
enum YearFilter {
  any('Any'),
  from2020('2020s'),
  from2010('2010s'),
  from2000('2000s'),
  before2000('Before 2000');

  const YearFilter(this.label);

  final String label;

  bool matches(int year) {
    switch (this) {
      case YearFilter.any:
        return true;
      case YearFilter.from2020:
        return year >= 2020;
      case YearFilter.from2010:
        return year >= 2010 && year < 2020;
      case YearFilter.from2000:
        return year >= 2000 && year < 2010;
      case YearFilter.before2000:
        return year < 2000;
    }
  }
}

/// Minimum average rating filter on the Search Results screen.
enum RatingFilter {
  any('Any', 0),
  sevenPlus('7+', 7),
  eightPlus('8+', 8),
  eightHalfPlus('8.5+', 8.5);

  const RatingFilter(this.label, this.minRating);

  final String label;
  final double minRating;
}

/// Every genre used by [movies], sorted A–Z.
List<String> allGenres(List<Movie> movies) {
  final Set<String> genres = <String>{
    for (final Movie movie in movies) ...movie.genres,
  };
  return genres.toList()..sort();
}

/// Ways a list of movies can be ordered (used on Home and Search Results).
enum MovieSort {
  popular('Popular'),
  rating('Highest rating'),
  newest('Newest'),
  title('Title A–Z');

  const MovieSort(this.label);

  final String label;
}

/// Returns a new list with [movies] ordered by [sort].
List<Movie> sortMovies(List<Movie> movies, MovieSort sort) {
  final List<Movie> list = List<Movie>.of(movies);
  switch (sort) {
    case MovieSort.popular:
      list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    case MovieSort.rating:
      list.sort((a, b) => b.rating.compareTo(a.rating));
    case MovieSort.newest:
      list.sort((a, b) => b.year.compareTo(a.year));
    case MovieSort.title:
      list.sort((a, b) => a.title.compareTo(b.title));
  }
  return list;
}

/// Movies with the most active debates, for the "Trending Now" row.
List<Movie> trendingMovies(List<Movie> movies, {int count = 6}) {
  final List<Movie> list = List<Movie>.of(movies)
    ..sort((a, b) => b.debateCount.compareTo(a.debateCount));
  return list.take(count).toList();
}

/// Placeholder data until movies are loaded from Firebase in Step 3.
const List<Movie> sampleMovies = <Movie>[
  Movie(
    id: 1,
    title: 'Inception',
    year: 2010,
    genres: <String>['Sci-Fi', 'Action'],
    rating: 8.4,
    reviewCount: 124,
    debateCount: 38,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_FMjpg_UX1000_.jpg',
    summary:
        'A thief who steals secrets from people\'s dreams is offered one last '
        'job: instead of stealing an idea, he has to plant one. The deeper '
        'his team goes into dreams inside dreams, the harder it gets to tell '
        'what is real.',
  ),
  Movie(
    id: 2,
    title: 'Parasite',
    year: 2019,
    genres: <String>['Thriller', 'Drama'],
    rating: 8.6,
    reviewCount: 88,
    debateCount: 30,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BYjk1Y2U4MjQtY2ZiNS00OWQyLWI3MmYtZWUwNmRjYWRiNWNhXkEyXkFqcGc@._V1_.jpg',
    summary:
        'A poor family in Seoul gets hired one by one by a rich household by '
        'pretending to be unrelated experts. Their plan works well until a '
        'secret hidden inside the house turns the comedy into a tense '
        'thriller.',
  ),
  Movie(
    id: 3,
    title: 'Whiplash',
    year: 2014,
    genres: <String>['Drama', 'Music'],
    rating: 8.5,
    reviewCount: 59,
    debateCount: 12,
    posterUrl:
        'https://upload.wikimedia.org/wikipedia/tr/7/7e/Whiplash_%28film%2C_2014%29.jpg',
    summary:
        'A young jazz drummer joins the top band of a music school, led by a '
        'very harsh teacher. Pushed to his limits, he has to decide how much '
        'he is ready to give up to become great.',
  ),
];
