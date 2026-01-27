import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../../core/constants/app_constants.dart';
import 'auth_provider.dart';

// Mock Reviews
final _mockReviews = <Review>[
  Review(
    id: '1',
    experienceId: '1',
    userId: 'user1',
    userName: 'John Doe',
    bookingId: 'booking1',
    rating: 4.5,
    comment: 'Great experience! The sunrise was beautiful.',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    isVerified: true,
  ),
  Review(
    id: '2',
    experienceId: '1',
    userId: 'user2',
    userName: 'Jane Smith',
    bookingId: 'booking2',
    rating: 5.0,
    comment: 'Loved the boat ride. The guide was very knowledgeable.',
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    isVerified: true,
  ),
];

// Reviews for an experience
final experienceReviewsProvider = StreamProvider.family<List<Review>, String>((
  ref,
  experienceId,
) {
  return Stream.value(
    _mockReviews.where((r) => r.experienceId == experienceId).toList(),
  );
});

// User's reviews
final userReviewsProvider = StreamProvider<List<Review>>((ref) {
  // Mock: return all reviews or filter by mock user ID if we had one fixed
  return Stream.value(_mockReviews);
});

// Check if user can review (has completed booking)
final canReviewProvider = FutureProvider.family<bool, String>((
  ref,
  experienceId,
) async {
  // Allow reviewing for mock purposes essentially always or check mock bookings
  // For simplicity, let's say yes if logged in.
  final authState = ref.watch(authNotifierProvider);
  return authState.value != null;
});

// Review form state
class ReviewFormState {
  final double rating;
  final String title;
  final String comment;
  final List<String> photos;
  final bool isSubmitting;
  final String? error;

  ReviewFormState({
    this.rating = 5.0,
    this.title = '',
    this.comment = '',
    this.photos = const [],
    this.isSubmitting = false,
    this.error,
  });

  ReviewFormState copyWith({
    double? rating,
    String? title,
    String? comment,
    List<String>? photos,
    bool? isSubmitting,
    String? error,
  }) {
    return ReviewFormState(
      rating: rating ?? this.rating,
      title: title ?? this.title,
      comment: comment ?? this.comment,
      photos: photos ?? this.photos,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }

  bool get isValid => comment.length >= 10;
}

class ReviewFormNotifier extends StateNotifier<ReviewFormState> {
  ReviewFormNotifier() : super(ReviewFormState());

  void setRating(double rating) {
    state = state.copyWith(rating: rating);
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setComment(String comment) {
    state = state.copyWith(comment: comment);
  }

  void addPhoto(String photoUrl) {
    state = state.copyWith(photos: [...state.photos, photoUrl]);
  }

  void removePhoto(String photoUrl) {
    state = state.copyWith(
      photos: state.photos.where((p) => p != photoUrl).toList(),
    );
  }

  void reset() {
    state = ReviewFormState();
  }
}

final reviewFormProvider =
    StateNotifierProvider<ReviewFormNotifier, ReviewFormState>((ref) {
      return ReviewFormNotifier();
    });

// Review notifier for CRUD operations (Mocked)
class ReviewNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  ReviewNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> submitReview({
    required String experienceId,
    required String bookingId,
    required double rating,
    String? title,
    required String comment,
    List<String>? photos,
  }) async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(seconds: 1));

      final user = _ref.read(authNotifierProvider).value;
      if (user == null) throw Exception('User not logged in');

      final review = Review(
        id: 'mock_review_${DateTime.now().millisecondsSinceEpoch}',
        experienceId: experienceId,
        userId: user.id,
        userName: user.name,
        userPhotoUrl: user.photoUrl,
        bookingId: bookingId,
        rating: rating,
        title: title,
        comment: comment,
        photos: photos,
        isVerified: true,
        createdAt: DateTime.now(),
      );

      _mockReviews.add(review);

      // We don't really update experience rating in mock mode unless we link it back,
      // but showing the review locally is enough.

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _updateExperienceRating(String experienceId) async {
    // Mock update logic or no-op
  }

  Future<void> respondToReview(String reviewId, String response) async {
    // Mock response
  }

  Future<void> markHelpful(String reviewId) async {
    final index = _mockReviews.indexWhere((r) => r.id == reviewId);
    if (index != -1) {
      // Just mock incrementing locally
      _mockReviews[index] = _mockReviews[index].copyWith(
        helpfulCount: _mockReviews[index].helpfulCount + 1,
      );
    }
  }
}

final reviewNotifierProvider =
    StateNotifierProvider<ReviewNotifier, AsyncValue<void>>((ref) {
      return ReviewNotifier(ref);
    });
