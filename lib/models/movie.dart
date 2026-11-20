class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genres,
    required this.rating,
    required this.reviewCount,
    required this.debateCount,
  });

  final int id;
  final String title;
  final int year;
  final List<String> genres;

  /// Average CineDeb rating out of 10.
  final double rating;
  final int reviewCount;
  final int debateCount;

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
  ),
  Movie(
    id: 2,
    title: 'Interstellar',
    year: 2014,
    genres: <String>['Sci-Fi', 'Drama'],
    rating: 8.1,
    reviewCount: 96,
    debateCount: 21,
  ),
  Movie(
    id: 3,
    title: 'Parasite',
    year: 2019,
    genres: <String>['Thriller', 'Drama'],
    rating: 8.6,
    reviewCount: 88,
    debateCount: 30,
  ),
  Movie(
    id: 4,
    title: 'The Dark Knight',
    year: 2008,
    genres: <String>['Action', 'Crime'],
    rating: 8.9,
    reviewCount: 151,
    debateCount: 44,
  ),
  Movie(
    id: 5,
    title: 'Dune: Part Two',
    year: 2024,
    genres: <String>['Sci-Fi', 'Adventure'],
    rating: 7.9,
    reviewCount: 67,
    debateCount: 26,
  ),
  Movie(
    id: 6,
    title: 'Oppenheimer',
    year: 2023,
    genres: <String>['Drama', 'History'],
    rating: 8.2,
    reviewCount: 102,
    debateCount: 41,
  ),
  Movie(
    id: 7,
    title: 'Whiplash',
    year: 2014,
    genres: <String>['Drama', 'Music'],
    rating: 8.5,
    reviewCount: 59,
    debateCount: 12,
  ),
  Movie(
    id: 8,
    title: 'Spirited Away',
    year: 2001,
    genres: <String>['Animation', 'Fantasy'],
    rating: 8.7,
    reviewCount: 73,
    debateCount: 9,
  ),
  Movie(
    id: 9,
    title: 'Everything Everywhere All at Once',
    year: 2022,
    genres: <String>['Comedy', 'Sci-Fi', 'Action'],
    rating: 7.6,
    reviewCount: 81,
    debateCount: 35,
  ),
  Movie(
    id: 10,
    title: 'Pulp Fiction',
    year: 1994,
    genres: <String>['Crime', 'Drama'],
    rating: 8.3,
    reviewCount: 110,
    debateCount: 19,
  ),
];
