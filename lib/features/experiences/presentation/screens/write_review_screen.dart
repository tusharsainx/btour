import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/text_fields.dart';
import '../../../../shared/providers/providers.dart';

class WriteReviewScreen extends ConsumerWidget {
  final String experienceId;
  final String bookingId;

  const WriteReviewScreen({
    super.key,
    required this.experienceId,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(reviewFormProvider);
    final notifier = ref.read(reviewFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Write a Review')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How was your experience?',
              style: AppTypography.headlineSmall,
            ),
            const SizedBox(height: 24),
            Center(
              child: RatingBar.builder(
                initialRating: formState.rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  notifier.setRating(rating);
                },
              ),
            ),
            const SizedBox(height: 32),
            Text('Share your thoughts', style: AppTypography.titleMedium),
            const SizedBox(height: 12),
            CustomTextField(
              hint: 'Title (e.g., "Amazing experience!")',
              onChanged: notifier.setTitle,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hint: 'Tell us more about your trip...',
              maxLines: 5,
              onChanged: notifier.setComment,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Submit Review',
              isLoading: formState.isSubmitting,
              onPressed: formState.isValid
                  ? () async {
                      await ref
                          .read(reviewNotifierProvider.notifier)
                          .submitReview(
                            experienceId: experienceId,
                            bookingId: bookingId,
                            rating: formState.rating,
                            title: formState.title,
                            comment: formState.comment,
                            photos: formState.photos,
                          );

                      if (context.mounted) {
                        context.pop(); // Go back
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Review submitted successfully!'),
                          ),
                        );
                      }
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
