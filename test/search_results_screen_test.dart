import 'package:cinedeb/models/movie.dart';
import 'package:cinedeb/screens/home_screen.dart';
import 'package:cinedeb/screens/search_results_screen.dart';
import 'package:cinedeb/utils/app_theme.dart';
import 'package:cinedeb/widgets/movie_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestApp(Widget home) {
    return MaterialApp(theme: AppTheme.dark, home: home);
  }

  void setScreenSize(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  // The vertical results list (the search field scrolls horizontally).
  final Finder resultsList = find
      .byWidgetPredicate(
        (Widget w) => w is Scrollable && w.axisDirection == AxisDirection.down,
      )
      .first;

  String firstResultTitle(WidgetTester tester) {
    return tester
        .widgetList<MovieListCard>(find.byType(MovieListCard))
        .first
        .movie
        .title;
  }

  Future<void> pickOption(
    WidgetTester tester,
    String chipLabel,
    String option,
  ) async {
    await tester.tap(find.text(chipLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(option));
    await tester.pumpAndSettle();
  }

  group('Search query', () {
    testWidgets('shows the matching movies for the initial query', (
      WidgetTester tester,
    ) async {
      setScreenSize(tester, const Size(412, 915));
      await tester.pumpWidget(
        buildTestApp(const SearchResultsScreen(initialQuery: 'dark')),
      );

      expect(find.text('FILTERS'), findsOneWidget);
      expect(find.text('1 RESULT FOR "DARK"'), findsOneWidget);
      expect(find.byType(MovieListCard), findsOneWidget);
      expect(firstResultTitle(tester), 'The Dark Knight');
      expect(find.text('END OF RESULTS'), findsOneWidget);
    });

    testWidgets('typing updates the results and clear resets them', (
      WidgetTester tester,
    ) async {
      setScreenSize(tester, const Size(412, 915));
      await tester.pumpWidget(buildTestApp(const SearchResultsScreen()));
      expect(find.text('10 MOVIES'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'inter');
      await tester.pump();
      expect(find.text('1 RESULT FOR "INTER"'), findsOneWidget);
      expect(firstResultTitle(tester), 'Interstellar');

      await tester.tap(find.byTooltip('Clear search'));
      await tester.pump();
      expect(find.text('10 MOVIES'), findsOneWidget);
      expect(find.byTooltip('Clear search'), findsNothing);
    });

    testWidgets('matches by year, by rating and by genre', (
      WidgetTester tester,
    ) async {
      setScreenSize(tester, const Size(412, 915));
      await tester.pumpWidget(buildTestApp(const SearchResultsScreen()));

      await tester.enterText(find.byType(TextField), '2014');
      await tester.pump();
      expect(find.text('2 RESULTS FOR "2014"'), findsOneWidget);

      // A number up to 10 means "rated at least this".
      await tester.enterText(find.byType(TextField), '8.5');
      await tester.pump();
      expect(find.text('4 RESULTS FOR "8.5"'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'drama');
      await tester.pump();
      expect(find.text('5 RESULTS FOR "DRAMA"'), findsOneWidget);
    });

    testWidgets('shows an empty state when nothing matches', (
      WidgetTester tester,
    ) async {
      setScreenSize(tester, const Size(412, 915));
      await tester.pumpWidget(
        buildTestApp(const SearchResultsScreen(initialQuery: 'zzz')),
      );

      expect(find.text('0 RESULTS FOR "ZZZ"'), findsOneWidget);
      expect(find.text('No movies found'), findsOneWidget);
      expect(find.byType(MovieListCard), findsNothing);
      expect(find.text('END OF RESULTS'), findsNothing);
    });
  });

  group('Filters and sort', () {
    testWidgets('rating and genre filters combine and can be cleared', (
      WidgetTester tester,
    ) async {
      setScreenSize(tester, const Size(412, 915));
      await tester.pumpWidget(buildTestApp(const SearchResultsScreen()));
      expect(find.text('Clear filters'), findsNothing);

      await pickOption(tester, 'Rating: Any', '8+');
      expect(find.text('Rating: 8+'), findsOneWidget);
      expect(find.text('8 MOVIES'), findsOneWidget);

      await pickOption(tester, 'Genre: Any', 'Drama');
      expect(find.text('Genre: Drama'), findsOneWidget);
      expect(find.text('5 MOVIES'), findsOneWidget);

      await tester.tap(find.text('Clear filters'));
      await tester.pumpAndSettle();
      expect(find.text('Rating: Any'), findsOneWidget);
      expect(find.text('Genre: Any'), findsOneWidget);
      expect(find.text('10 MOVIES'), findsOneWidget);
    });

    testWidgets('year filter keeps only movies from that period', (
      WidgetTester tester,
    ) async {
      setScreenSize(tester, const Size(412, 915));
      await tester.pumpWidget(buildTestApp(const SearchResultsScreen()));

      await pickOption(tester, 'Year: Any', 'Before 2000');
      expect(find.text('Year: Before 2000'), findsOneWidget);
      expect(find.text('1 MOVIE'), findsOneWidget);
      expect(firstResultTitle(tester), 'Pulp Fiction');
    });

    testWidgets('sort option changes the order of the results', (
      WidgetTester tester,
    ) async {
      setScreenSize(tester, const Size(412, 915));
      await tester.pumpWidget(
        buildTestApp(const SearchResultsScreen(initialSort: MovieSort.title)),
      );
      expect(firstResultTitle(tester), 'Dune: Part Two');

      await pickOption(tester, 'Sort: Title A–Z', 'Highest rating');
      expect(find.text('Sort: Highest rating'), findsOneWidget);
      expect(firstResultTitle(tester), 'The Dark Knight');
    });
  });

  group('Navigation from Home', () {
    testWidgets('Top rated opens results sorted by rating; Back returns', (
      WidgetTester tester,
    ) async {
      setScreenSize(tester, const Size(412, 915));
      await tester.pumpWidget(buildTestApp(const HomeScreen()));

      await tester.tap(find.text('Top rated'));
      await tester.pumpAndSettle();
      expect(find.byType(SearchResultsScreen), findsOneWidget);
      expect(find.text('Sort: Highest rating'), findsOneWidget);
      expect(firstResultTitle(tester), 'The Dark Knight');

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('What are we debating today?'), findsOneWidget);
    });

    testWidgets('Home search bar opens results for the typed query', (
      WidgetTester tester,
    ) async {
      setScreenSize(tester, const Size(412, 915));
      await tester.pumpWidget(buildTestApp(const HomeScreen()));

      await tester.enterText(find.byType(TextField), 'inception');
      await tester.tap(find.text('GO'));
      await tester.pumpAndSettle();
      expect(find.text('1 RESULT FOR "INCEPTION"'), findsOneWidget);

      // Home in the bottom bar goes back to the Home screen.
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.byType(SearchResultsScreen), findsNothing);
      expect(find.text('What are we debating today?'), findsOneWidget);
    });
  });

  // Small, medium and large phones in portrait mode.
  const List<Size> phoneSizes = <Size>[
    Size(320, 568),
    Size(360, 640),
    Size(430, 932),
  ];

  for (final Size size in phoneSizes) {
    testWidgets(
      'SearchResultsScreen has no overflow on a ${size.width.toInt()}x'
      '${size.height.toInt()} screen',
      (WidgetTester tester) async {
        setScreenSize(tester, size);
        await tester.pumpWidget(
          buildTestApp(const SearchResultsScreen(initialQuery: 'a')),
        );

        // The longest picker (genres) must fit too.
        await pickOption(tester, 'Genre: Any', 'Any');

        await tester.scrollUntilVisible(
          find.text('END OF RESULTS'),
          200,
          scrollable: resultsList,
        );
        await tester.pumpAndSettle();
        expect(find.text('END OF RESULTS'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
