import 'package:cinedeb/models/movie.dart';
import 'package:cinedeb/screens/movie_detail_screen.dart';
import 'package:cinedeb/screens/reviews_screen.dart';
import 'package:cinedeb/screens/write_review_screen.dart';
import 'package:cinedeb/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Inception: 2010, Sci-Fi · Action, 124 reviews.
  final Movie movie = sampleMovies.first;

  const String newReview = 'A clever movie with great music and visuals.';

  Widget buildTestApp() {
    return MaterialApp(
      theme: AppTheme.dark,
      home: MovieDetailScreen(movie: movie),
    );
  }

  void setScreenSize(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  // Opens Write Review, fills in a valid review and confirms the dialog.
  Future<void> postReview(WidgetTester tester) async {
    await tester.tap(find.text('Write a Review'));
    await tester.pumpAndSettle();
    expect(find.byType(WriteReviewScreen), findsOneWidget);

    await tester.tap(find.text('9'));
    await tester.enterText(find.byType(TextFormField), newReview);
    await tester.ensureVisible(find.text('Post Review'));
    await tester.tap(find.text('Post Review'));
    await tester.pumpAndSettle();

    expect(find.text('Review Posted!'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  testWidgets('MovieDetailScreen shows the movie info and summary', (
    WidgetTester tester,
  ) async {
    setScreenSize(tester, const Size(412, 915));
    await tester.pumpWidget(buildTestApp());

    expect(find.text('Movie Details'), findsOneWidget);
    expect(find.text('Inception'), findsWidgets); // app bar and header
    expect(find.text('RELEASED 2010'), findsOneWidget);
    expect(find.text('Sci-Fi'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('124 REVIEWS · 38 DEBATES'), findsOneWidget);
    expect(find.text('SUMMARY'), findsOneWidget);
    expect(find.textContaining('plant one'), findsOneWidget);
    expect(find.text('Write a Review'), findsOneWidget);
  });

  testWidgets('Top reviews are shown, most liked first', (
    WidgetTester tester,
  ) async {
    setScreenSize(tester, const Size(412, 915));
    await tester.pumpWidget(buildTestApp());

    await scrollTo(tester, find.text('TOP REVIEWS'));
    expect(find.text('See all (124)'), findsOneWidget);

    await scrollTo(tester, find.text('username01'));
    expect(find.text('Like 12'), findsOneWidget);
    expect(find.text('5 Counter Reviews'), findsOneWidget);

    // Nobody else's review can be deleted.
    expect(find.text('Delete'), findsNothing);
  });

  testWidgets('Like button adds a like and can be undone', (
    WidgetTester tester,
  ) async {
    setScreenSize(tester, const Size(412, 915));
    await tester.pumpWidget(buildTestApp());

    await scrollTo(tester, find.text('Like 12'));
    await tester.tap(find.text('Like 12'));
    await tester.pump();
    expect(find.text('Like 13'), findsOneWidget);

    await tester.tap(find.text('Like 13'));
    await tester.pump();
    expect(find.text('Like 12'), findsOneWidget);
  });

  testWidgets('See all opens the Reviews screen', (WidgetTester tester) async {
    setScreenSize(tester, const Size(412, 915));
    await tester.pumpWidget(buildTestApp());

    await scrollTo(tester, find.text('See all (124)'));
    await tester.tap(find.text('See all (124)'));
    await tester.pumpAndSettle();

    expect(find.byType(ReviewsScreen), findsOneWidget);
    expect(find.text('Reviews'), findsOneWidget);
  });

  testWidgets('A posted review appears on top and can be deleted', (
    WidgetTester tester,
  ) async {
    setScreenSize(tester, const Size(412, 915));
    await tester.pumpWidget(buildTestApp());

    await postReview(tester);
    expect(find.byType(WriteReviewScreen), findsNothing);

    await scrollTo(tester, find.text(newReview));
    expect(find.text(newReview), findsOneWidget);
    expect(find.text('See all (125)'), findsOneWidget);

    await tester.ensureVisible(find.text('Delete'));
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text(newReview), findsNothing);
    expect(find.text('Review deleted'), findsOneWidget);

    // Undo puts it back.
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text(newReview), findsOneWidget);
  });

  // Small, medium and large phones in portrait mode.
  const List<Size> phoneSizes = <Size>[
    Size(320, 568),
    Size(360, 640),
    Size(430, 932),
  ];

  for (final Size size in phoneSizes) {
    testWidgets(
      'MovieDetailScreen has no overflow on a ${size.width.toInt()}x'
      '${size.height.toInt()} screen',
      (WidgetTester tester) async {
        setScreenSize(tester, size);
        await tester.pumpWidget(buildTestApp());

        await scrollTo(tester, find.text('username03'));
        expect(find.text('username03'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
