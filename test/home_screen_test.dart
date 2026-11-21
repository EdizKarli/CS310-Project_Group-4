import 'package:cinedeb/screens/home_screen.dart';
import 'package:cinedeb/screens/profile_screen.dart';
import 'package:cinedeb/utils/app_theme.dart';
import 'package:cinedeb/widgets/movie_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestApp() {
    return MaterialApp(theme: AppTheme.dark, home: const HomeScreen());
  }

  void setScreenSize(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  // The outer vertical list of the Home screen.
  final Finder homeList = find.byType(Scrollable).first;

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(finder, 200, scrollable: homeList);
    await tester.pumpAndSettle();
  }

  String firstMovieCardTitle(WidgetTester tester) {
    return tester
        .widgetList<MovieListCard>(find.byType(MovieListCard))
        .first
        .movie
        .title;
  }

  testWidgets('HomeScreen renders greeting, search, tiles and sections', (
    WidgetTester tester,
  ) async {
    setScreenSize(tester, const Size(412, 915));
    await tester.pumpWidget(buildTestApp());

    expect(find.text('CINEDEB'), findsOneWidget);
    expect(find.text('WELCOME BACK, @CINEDEB_USER'), findsOneWidget);
    expect(find.text('What are we debating today?'), findsOneWidget);
    expect(find.text('Search by title, year or rating'), findsOneWidget);
    expect(find.text('GO'), findsOneWidget);
    expect(find.text('Top rated'), findsOneWidget);
    expect(find.text('New releases'), findsOneWidget);
    expect(find.text('My reviews'), findsOneWidget);
    expect(find.text('My counters'), findsOneWidget);
    expect(find.text('TRENDING NOW'), findsOneWidget);
    expect(find.byType(TrendingMovieTile), findsWidgets);

    await scrollTo(tester, find.text('HOT DEBATES'));
    expect(find.text('HOT DEBATES'), findsOneWidget);

    await scrollTo(tester, find.text('ALL MOVIES'));
    expect(find.text('Sort: Popular'), findsOneWidget);
  });

  testWidgets('Sort sheet changes the order of All Movies', (
    WidgetTester tester,
  ) async {
    setScreenSize(tester, const Size(412, 915));
    await tester.pumpWidget(buildTestApp());

    await scrollTo(tester, find.text('Sort: Popular'));
    // Most reviewed movie comes first by default.
    expect(firstMovieCardTitle(tester), 'Inception');

    await tester.tap(find.text('Sort: Popular'));
    await tester.pumpAndSettle();
    expect(find.text('Sort movies'), findsOneWidget);

    await tester.tap(find.text('Highest rating'));
    await tester.pumpAndSettle();
    expect(find.text('Sort movies'), findsNothing);
    expect(find.text('Sort: Highest rating'), findsOneWidget);
    expect(firstMovieCardTitle(tester), 'Parasite');
  });

  testWidgets('My counters opens Profile on the counters tab', (
    WidgetTester tester,
  ) async {
    setScreenSize(tester, const Size(412, 915));
    await tester.pumpWidget(buildTestApp());

    await tester.tap(find.text('My counters'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.textContaining("On username02's review"), findsOneWidget);

    // Home in the bottom bar returns to the Home screen.
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('What are we debating today?'), findsOneWidget);
  });

  testWidgets('Hot debate opens Counter Reviews and Home tab comes back', (
    WidgetTester tester,
  ) async {
    setScreenSize(tester, const Size(412, 915));
    await tester.pumpWidget(buildTestApp());

    await scrollTo(tester, find.text('5 Counter Reviews'));
    await tester.tap(find.text('5 Counter Reviews'));
    await tester.pumpAndSettle();
    expect(find.text('Counter Reviews'), findsOneWidget);
    expect(find.text("on username01's review"), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Counter Reviews'), findsNothing);
  });

  testWidgets('Tapping a hot debate card opens the Reviews screen', (
    WidgetTester tester,
  ) async {
    setScreenSize(tester, const Size(412, 915));
    await tester.pumpWidget(buildTestApp());

    await scrollTo(tester, find.text('INCEPTION'));
    await tester.tap(find.text('INCEPTION'));
    await tester.pumpAndSettle();
    expect(find.text('Reviews'), findsOneWidget);
    expect(find.text('Inception'), findsOneWidget);
  });

  // Small, medium and large phones in portrait mode.
  const List<Size> phoneSizes = <Size>[
    Size(320, 568),
    Size(360, 640),
    Size(430, 932),
  ];

  for (final Size size in phoneSizes) {
    testWidgets(
      'HomeScreen has no overflow on a ${size.width.toInt()}x'
      '${size.height.toInt()} screen',
      (WidgetTester tester) async {
        setScreenSize(tester, size);
        await tester.pumpWidget(buildTestApp());

        // Scroll the Trending row to its end.
        await tester.drag(
          find.byType(TrendingMovieTile).first,
          const Offset(-1000, 0),
        );
        await tester.pumpAndSettle();

        // Scroll down to the last movie in the list.
        await scrollTo(tester, find.text('Whiplash'));
        expect(find.text('Whiplash'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
