import 'package:cinedeb/models/movie.dart';
import 'package:cinedeb/models/review.dart';
import 'package:cinedeb/screens/write_review_screen.dart';
import 'package:cinedeb/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Inception
  final Movie movie = sampleMovies.first;

  const String validText = 'A clever movie with great music and visuals.';

  // The Write Review screen is opened from a button, like on Movie Detail,
  // so the test can check what it returns when it closes.
  Review? result;
  bool closed = false;

  Widget buildTestApp() {
    result = null;
    closed = false;
    return MaterialApp(
      theme: AppTheme.dark,
      home: Builder(
        builder: (BuildContext context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () async {
                result = await Navigator.push<Review>(
                  context,
                  MaterialPageRoute<Review>(
                    builder: (_) => WriteReviewScreen(movie: movie),
                  ),
                );
                closed = true;
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
  }

  void setScreenSize(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Future<void> openScreen(WidgetTester tester, {Size? size}) async {
    setScreenSize(tester, size ?? const Size(412, 915));
    await tester.pumpWidget(buildTestApp());
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  Future<void> tapButton(WidgetTester tester, String label) async {
    await tester.ensureVisible(find.text(label));
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  testWidgets('WriteReviewScreen shows the movie, both fields and buttons', (
    WidgetTester tester,
  ) async {
    await openScreen(tester);

    expect(find.text('Write a Review'), findsOneWidget);
    expect(find.text('Inception'), findsWidgets); // app bar and summary row
    expect(find.text('Your Rating*'), findsOneWidget);
    expect(find.text('Your Review*'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('Tap a number to rate the movie.'), findsOneWidget);
    expect(find.text('Post Review'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('Empty form shows an error under each field', (
    WidgetTester tester,
  ) async {
    await openScreen(tester);

    await tapButton(tester, 'Post Review');

    expect(find.text('Please select a rating from 1 to 10.'), findsOneWidget);
    expect(find.text('Please write your review.'), findsOneWidget);
    expect(find.text('Review Posted!'), findsNothing);
  });

  testWidgets('Errors update while the user fixes the form', (
    WidgetTester tester,
  ) async {
    await openScreen(tester);
    await tapButton(tester, 'Post Review');

    await tester.tap(find.text('7'));
    await tester.pump();
    expect(find.text('Please select a rating from 1 to 10.'), findsNothing);
    expect(find.text('Selected: 7/10 · Good'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Too short');
    await tester.pump();
    expect(find.textContaining('at least 20 characters'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), validText);
    await tester.pump();
    expect(find.textContaining('at least 20 characters'), findsNothing);
  });

  testWidgets('Valid form shows the dialog and returns the new review', (
    WidgetTester tester,
  ) async {
    await openScreen(tester);

    await tester.tap(find.text('8'));
    await tester.enterText(find.byType(TextFormField), validText);
    await tapButton(tester, 'Post Review');

    expect(find.text('Review Posted!'), findsOneWidget);
    expect(
      find.text('Your 8/10 review for Inception has been posted.'),
      findsOneWidget,
    );

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.byType(WriteReviewScreen), findsNothing);
    expect(closed, isTrue);
    expect(result, isNotNull);
    expect(result!.rating, 8);
    expect(result!.text, validText);
    expect(result!.username, WriteReviewScreen.currentUser);
  });

  testWidgets('Cancel asks before discarding a started review', (
    WidgetTester tester,
  ) async {
    await openScreen(tester);
    await tester.tap(find.text('5'));
    await tester.pump();

    await tapButton(tester, 'Cancel');
    expect(find.text('Discard review?'), findsOneWidget);

    // "Keep Writing" stays on the form.
    await tester.tap(find.text('Keep Writing'));
    await tester.pumpAndSettle();
    expect(find.byType(WriteReviewScreen), findsOneWidget);

    await tapButton(tester, 'Cancel');
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(find.byType(WriteReviewScreen), findsNothing);
    expect(closed, isTrue);
    expect(result, isNull);
  });

  testWidgets('Cancel closes right away when nothing was entered', (
    WidgetTester tester,
  ) async {
    await openScreen(tester);

    await tapButton(tester, 'Cancel');
    expect(find.text('Discard review?'), findsNothing);
    expect(find.byType(WriteReviewScreen), findsNothing);
  });

  // Small, medium and large phones in portrait mode.
  const List<Size> phoneSizes = <Size>[
    Size(320, 568),
    Size(360, 640),
    Size(430, 932),
  ];

  for (final Size size in phoneSizes) {
    testWidgets(
      'WriteReviewScreen has no overflow on a ${size.width.toInt()}x'
      '${size.height.toInt()} screen',
      (WidgetTester tester) async {
        await openScreen(tester, size: size);

        // Show the errors too, since they make the form taller.
        await tapButton(tester, 'Post Review');
        await tester.ensureVisible(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.text('Cancel'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
