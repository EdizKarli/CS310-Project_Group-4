import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../models/review.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/auth_components.dart';
import '../widgets/movie_widgets.dart';

/// Form for posting a new review: a rating from 1 to 10 and the review text.
///
/// Both fields show their errors under them. After a valid submission a
/// confirmation dialog is shown, and the screen closes with the new [Review]
/// so the Movie Detail screen can add it to the list.
class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key, required this.movie});

  /// Username for new reviews until real accounts come in Step 3.
  static const String currentUser = 'you';

  static const int minLength = 20;
  static const int maxLength = 500;

  final Movie movie;

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();

  int? _rating;

  /// Errors are only shown after the first tap on "Post Review".
  bool _triedToSubmit = false;

  bool get _hasChanges =>
      _rating != null || _textController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String? _validateRating(int? value) {
    if (value == null) return 'Please select a rating from 1 to 10.';
    return null;
  }

  String? _validateText(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please write your review.';
    if (text.length < WriteReviewScreen.minLength) {
      return 'Review must be at least ${WriteReviewScreen.minLength} '
          'characters (${text.length}/${WriteReviewScreen.minLength}).';
    }
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _triedToSubmit = true);
    if (!_formKey.currentState!.validate()) return;

    final Review review = Review(
      id: DateTime.now().millisecondsSinceEpoch,
      username: WriteReviewScreen.currentUser,
      date: DateTime.now(),
      rating: _rating!,
      text: _textController.text.trim(),
    );

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.check_circle_outline,
          color: AppColors.red,
          size: 40,
        ),
        title: const Text('Review Posted!'),
        content: Text(
          'Your ${review.rating}/10 review for ${widget.movie.title} '
          'has been posted.',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // Go back to Movie Detail with the new review.
    if (!mounted) return;
    Navigator.pop(context, review);
  }

  // Asks before throwing away a half-written review.
  Future<void> _cancel() async {
    if (!_hasChanges) {
      Navigator.pop(context);
      return;
    }

    final bool? discard = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Discard review?'),
        content: const Text('Your rating and text will be lost.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep Writing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (discard != true || !mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Movie movie = widget.movie;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: _cancel,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Write a Review', style: AppText.title),
            Text(
              movie.title,
              style: AppText.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: _triedToSubmit
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.m),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: <Widget>[
            _MovieSummaryRow(movie: movie),
            const SizedBox(height: AppSpacing.m),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.l),

            // Field 1: rating from 1 to 10
            const AuthFieldHeader(
              label: 'Your Rating*',
              trailing: Text('*REQUIRED', style: AppText.overline),
            ),
            const SizedBox(height: AppSpacing.s),
            FormField<int>(
              validator: _validateRating,
              builder: (FormFieldState<int> field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _RatingSelector(
                      selected: field.value,
                      hasError: field.hasError,
                      onSelected: (int value) {
                        field.didChange(value);
                        setState(() => _rating = value);
                      },
                    ),
                    const SizedBox(height: AppSpacing.s),
                    if (field.hasError)
                      Text(
                        field.errorText!,
                        style: AppText.caption.copyWith(color: AppColors.error),
                      )
                    else
                      Text(
                        field.value == null
                            ? 'Tap a number to rate the movie.'
                            : 'Selected: ${field.value}/10 · '
                                '${_ratingLabel(field.value!)}',
                        style: AppText.caption,
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.l),

            // Field 2: review text
            const AuthFieldHeader(
              label: 'Your Review*',
              trailing: Text('*REQUIRED', style: AppText.overline),
            ),
            const SizedBox(height: AppSpacing.s),
            TextFormField(
              controller: _textController,
              minLines: 5,
              maxLines: 8,
              maxLength: WriteReviewScreen.maxLength,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              style: AppText.body,
              decoration: const InputDecoration(
                hintText: 'Share your thoughts about the movie...',
                helperText:
                    'At least ${WriteReviewScreen.minLength} characters.',
                alignLabelWithHint: true,
              ),
              onChanged: (_) => setState(() {}),
              validator: _validateText,
            ),
            const SizedBox(height: AppSpacing.l),

            ElevatedButton(
              onPressed: _submit,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Post Review'),
                  SizedBox(width: AppSpacing.s),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            OutlinedButton(
              onPressed: _cancel,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}

/// One word for the picked rating, shown under the rating boxes.
String _ratingLabel(int rating) {
  if (rating <= 2) return 'Terrible';
  if (rating <= 4) return 'Bad';
  if (rating <= 6) return 'Okay';
  if (rating <= 8) return 'Good';
  return 'Masterpiece';
}

/// Small poster with the title, year and genres of the movie being reviewed.
class _MovieSummaryRow extends StatelessWidget {
  const _MovieSummaryRow({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        MoviePoster(imageUrl: movie.posterUrl, width: 48, height: 72),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                movie.title,
                style: AppText.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${movie.year} · ${movie.genreLabel}'.toUpperCase(),
                style: AppText.overline,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The ten rating boxes. They sit in one row when there is enough width
/// and switch to two rows of five on small phones, so they never overflow.
class _RatingSelector extends StatelessWidget {
  const _RatingSelector({
    required this.selected,
    required this.hasError,
    required this.onSelected,
  });

  final int? selected;
  final bool hasError;
  final ValueChanged<int> onSelected;

  static const double _gap = 6;
  static const double _minBoxWidth = 30;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double oneRowBox = (width - _gap * 9) / 10;
        final int perRow = oneRowBox >= _minBoxWidth ? 10 : 5;
        final double boxWidth =
            ((width - _gap * (perRow - 1)) / perRow).floorToDouble();

        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: <Widget>[
            for (int value = 1; value <= 10; value++)
              _RatingBox(
                value: value,
                width: boxWidth,
                selected: value == selected,
                hasError: hasError,
                onTap: () => onSelected(value),
              ),
          ],
        );
      },
    );
  }
}

class _RatingBox extends StatelessWidget {
  const _RatingBox({
    required this.value,
    required this.width,
    required this.selected,
    required this.hasError,
    required this.onTap,
  });

  final int value;
  final double width;
  final bool selected;
  final bool hasError;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(AppRadius.s);
    Color borderColor = AppColors.border;
    if (hasError) borderColor = AppColors.error;
    if (selected) borderColor = AppColors.red;

    return Semantics(
      button: true,
      selected: selected,
      label: 'Rate $value out of 10',
      excludeSemantics: true,
      child: Material(
        color: selected ? AppColors.red : AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: borderColor),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(borderRadius: radius),
          child: SizedBox(
            width: width,
            height: 44,
            child: Center(
              child: Text(
                '$value',
                style: AppText.label.copyWith(fontSize: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
